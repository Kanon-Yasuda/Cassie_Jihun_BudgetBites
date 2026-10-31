
import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/meal.dart';
import 'models/purchase.dart';

import 'screens/meal_form_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/history_screen.dart';
import 'screens/budget_settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BudgetBitesApp());
}

class BudgetBitesApp extends StatelessWidget {
  const BudgetBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Bites',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseHelper db = DatabaseHelper.instance;

  double budget = 200.00;
  List<Map<String, dynamic>> meals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  // Load meals and purchases from SQLite.
  Future<void> loadMeals() async {
    try {
      final savedMeals = await db.getAllMeals();
      final purchases = await db.getAllPurchases();

      debugPrint('SQLite meals: ${savedMeals.length}');
      debugPrint('SQLite purchases: ${purchases.length}');

      final loadedMeals = <Map<String, dynamic>>[];

      for (final meal in savedMeals) {
        double amount = 0;

        for (final purchase in purchases) {
          if (purchase.mealId == meal.id) {
            amount += purchase.cost;
          }
        }

        loadedMeals.add({
          'id': meal.id,
          'name': meal.name,
          'amount': amount,
          'category': meal.category,
          'date': meal.date,
        });
      }

      if (!mounted) return;

      setState(() {
        meals = loadedMeals;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('SQLite load error: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage('Could not load meals.');
      rethrow;
    }
  }

  // Calculate total spending.
  double get totalSpent {
    double total = 0;

    for (final meal in meals) {
      total += (meal['amount'] as num).toDouble();
    }

    return total;
  }

  double get remainingBudget => budget - totalSpent;

  String formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  IconData categoryIcon(String category) {
    switch (category) {
      case 'Groceries':
        return Icons.shopping_cart;
      case 'Snack':
        return Icons.cookie;
      default:
        return Icons.lunch_dining;
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Add a new meal to SQLite.
  Future<void> addMeal() async {
    final newMeal = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const MealFormScreen(),
      ),
    );

    if (!mounted || newMeal == null) return;

    try {
      final name = newMeal['name'] as String;
      final category = newMeal['category'] as String;
      final amount = (newMeal['amount'] as num).toDouble();
      final date = newMeal['date'] as DateTime;

      final meal = Meal(
        name: name,
        category: category,
        date: date,
      );

      final mealId = await db.createMeals(meal);
      debugPrint('Saved meal ID: $mealId');

      final purchaseId = await db.createPurchase(
        Purchase(
          mealId: mealId,
          itemName: name,
          cost: amount,
          date: date,
        ),
      );

      debugPrint('Saved purchase ID: $purchaseId');

      await loadMeals();

      if (!mounted) return;

      showMessage('Meal added successfully!');
    } catch (e) {
      debugPrint('SQLite add error: $e');

      if (!mounted) return;

      showMessage('Could not add meal.');
    }
  }

  // View, edit, or delete a meal.
  Future<void> openMeal(int index) async {
    final meal = Map<String, dynamic>.from(meals[index]);

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailScreen(meal: meal),
      ),
    );

    if (!mounted || result == null) return;

    final mealId = meal['id'] as int;

    // Delete meal.
    if (result['action'] == 'delete') {
      try {
        await db.deleteMeal(mealId);
        await loadMeals();

        if (!mounted) return;

        showMessage('Meal deleted successfully!');
      } catch (e) {
        debugPrint('SQLite delete error: $e');

        if (!mounted) return;

        showMessage('Could not delete meal.');
      }
    }

    // Edit meal.
    if (result['action'] == 'edit') {
      final updatedMeal = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (context) => MealFormScreen(existingMeal: meal),
        ),
      );

      if (!mounted || updatedMeal == null) return;

      try {
        final name = updatedMeal['name'] as String;
        final category = updatedMeal['category'] as String;
        final amount = (updatedMeal['amount'] as num).toDouble();
        final date = updatedMeal['date'] as DateTime;

        final updated = Meal(
          id: mealId,
          name: name,
          category: category,
          date: date,
        );

        await db.updateMeal(mealId, updated);

        final purchases = await db.getAllPurchases();
        bool foundPurchase = false;

        for (final purchase in purchases) {
          if (purchase.mealId == mealId && purchase.id != null) {
            await db.updatePurchase(purchase.id!, {
              'item_name': name,
              'cost': amount,
              'date': date.toIso8601String(),
            });

            foundPurchase = true;
            break;
          }
        }

        if (!foundPurchase) {
          await db.createPurchase(
            Purchase(
              mealId: mealId,
              itemName: name,
              cost: amount,
              date: date,
            ),
          );
        }

        await loadMeals();

        if (!mounted) return;

        showMessage('Meal updated successfully!');
      } catch (e) {
        debugPrint('SQLite update error: $e');

        if (!mounted) return;

        showMessage('Could not update meal.');
      }
    }
  }

  // Open spending history.
  void openHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(meals: meals),
      ),
    );
  }

  // Change the monthly budget.
  Future<void> openSettings() async {
    final newBudget = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetSettingsScreen(
          currentBudget: budget,
        ),
      ),
    );

    if (!mounted || newBudget == null) return;

    setState(() {
      budget = newBudget;
    });

    showMessage('Budget updated successfully!');
  }

  @override
  Widget build(BuildContext context) {
    final spent = totalSpent;
    final remaining = remainingBudget;

    final double progress =
        budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Bites'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
        actions: [
          IconButton(
            tooltip: 'History & Insights',
            icon: const Icon(Icons.bar_chart),
            onPressed: openHistory,
          ),
          IconButton(
            tooltip: 'Budget Settings',
            icon: const Icon(Icons.settings),
            onPressed: openSettings,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Welcome to Budget Bites!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Budget summary.
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Monthly Budget'),
                        const SizedBox(height: 8),
                        Text(
                          '\$${budget.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: Colors.green.shade100,
                          color: remaining < 0
                              ? Colors.red
                              : Colors.green,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Spent: \$${spent.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Remaining: \$${remaining.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: remaining < 0
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Recent Meals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                if (meals.isEmpty)
                  const Center(
                    child: Text(
                      'No meals yet. Add your first meal!',
                    ),
                  )
                else
                  ...List.generate(meals.length, (index) {
                    final meal = meals[index];

                    return Card(
                      child: ListTile(
                        onTap: () => openMeal(index),
                        leading: Icon(
                          categoryIcon(meal['category'] as String),
                        ),
                        title: Text(meal['name'] as String),
                        subtitle: Text(
                          formatDate(meal['date'] as DateTime),
                        ),
                        trailing: Text(
                          '\$${(meal['amount'] as num).toStringAsFixed(2)}',
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 80),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addMeal,
        icon: const Icon(Icons.add),
        label: const Text('Add Meal'),
      ),
    );
  }
}
