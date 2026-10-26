import 'package:flutter/material.dart';

import 'screens/meal_form_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/history_screen.dart';
import 'screens/budget_settings_screen.dart';

void main() {
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
  double budget = 200.00;

  // Sample data until SQLite is connected.
  final List<Map<String, dynamic>> meals = [
    {
      'name': 'Lunch',
      'amount': 12.50,
      'category': 'Meal',
      'date': DateTime(2026, 10, 24),
    },
    {
      'name': 'Groceries',
      'amount': 35.00,
      'category': 'Groceries',
      'date': DateTime(2026, 10, 23),
    },
    {
      'name': 'Breakfast',
      'amount': 8.00,
      'category': 'Meal',
      'date': DateTime(2026, 10, 22),
    },
  ];

  // Add all meal costs.
  double get totalSpent {
    double total = 0;

    for (var meal in meals) {
      total += meal['amount'] as double;
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Add a new meal.
  Future<void> addMeal() async {
    final newMeal = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const MealFormScreen()),
    );

    if (!mounted || newMeal == null) return;

    setState(() {
      meals.insert(0, newMeal);
    });

    showMessage('Meal added successfully!');
  }

  // View, edit, or delete a meal.
  Future<void> openMeal(int index) async {
    final meal = Map<String, dynamic>.from(meals[index]);

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => MealDetailScreen(meal: meal)),
    );

    if (!mounted || result == null) return;

    if (result['action'] == 'delete') {
      setState(() {
        meals.removeAt(index);
      });

      showMessage('Meal deleted successfully!');
    }

    if (result['action'] == 'edit') {
      final updatedMeal = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (context) => MealFormScreen(existingMeal: meal),
        ),
      );

      if (!mounted || updatedMeal == null) return;

      setState(() {
        meals[index] = updatedMeal;
      });

      showMessage('Meal updated successfully!');
    }
  }

  // Open spending history.
  void openHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryScreen(meals: meals)),
    );
  }

  // Change the monthly budget.
  Future<void> openSettings() async {
    final newBudget = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetSettingsScreen(currentBudget: budget),
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
    final progress = (spent / budget).clamp(0.0, 1.0);

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Welcome to Budget Bites!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    color: remaining < 0 ? Colors.red : Colors.green,
                  ),
                  const SizedBox(height: 12),
                  Text('Spent: \$${spent.toStringAsFixed(2)}'),
                  Text(
                    'Remaining: \$${remaining.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: remaining < 0 ? Colors.red : Colors.green,
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (meals.isEmpty)
            const Center(child: Text('No meals yet. Add your first meal!'))
          else
            ...List.generate(meals.length, (index) {
              final meal = meals[index];

              return Card(
                child: ListTile(
                  onTap: () => openMeal(index),
                  leading: Icon(categoryIcon(meal['category'] as String)),
                  title: Text(meal['name'] as String),
                  subtitle: Text(formatDate(meal['date'] as DateTime)),
                  trailing: Text(
                    '\$${(meal['amount'] as double).toStringAsFixed(2)}',
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
