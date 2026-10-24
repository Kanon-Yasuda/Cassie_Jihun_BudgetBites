
import 'package:flutter/material.dart';
import 'screens/meal_form_screen.dart';
import 'screens/meal_detail_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
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
  final double budget = 200.00;

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

  double get totalSpent => meals.fold<double>(
        0.0,
        (sum, meal) => sum + (meal['amount'] as double),
      );

  Future<void> _openAddMeal() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const MealFormScreen(),
      ),
    );

    if (!mounted || result == null) return;

    setState(() => meals.insert(0, result));
    _showMessage('Meal added successfully!');
  }

  Future<void> _openMealDetail(int index) async {
    final meal = Map<String, dynamic>.from(meals[index]);

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(meal: meal),
      ),
    );

    if (!mounted || result == null) return;

    if (result['action'] == 'delete') {
      setState(() => meals.removeAt(index));
      _showMessage('Meal deleted successfully!');
    } else if (result['action'] == 'edit') {
      final updatedMeal =
          await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (_) => MealFormScreen(existingMeal: meal),
        ),
      );

      if (!mounted || updatedMeal == null) return;

      setState(() => meals[index] = updatedMeal);
      _showMessage('Meal updated successfully!');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Groceries':
        return Icons.shopping_cart;
      case 'Snack':
        return Icons.cookie;
      default:
        return Icons.lunch_dining;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spent = totalSpent;
    final remaining = budget - spent;
    final progress = budget > 0
        ? (spent / budget).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Bites'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
        actions: [
          IconButton(
            tooltip: 'Budget Settings',
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showMessage('Budget Settings is coming soon!');
            },
          ),
        ],
      ),
      body: ListView(
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
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: Colors.green.shade100,
                    color: remaining < 0
                        ? Colors.red
                        : Colors.green.shade700,
                  ),
                  const SizedBox(height: 12),
                  Text('Spent: \$${spent.toStringAsFixed(2)}'),
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
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No meals yet. Tap Add Meal to get started!',
                  ),
                ),
              ),
            )
          else
            ...List.generate(meals.length, (index) {
              final meal = meals[index];
              final name = meal['name'] as String;
              final amount = meal['amount'] as double;
              final category = meal['category'] as String;
              final date = meal['date'] as DateTime;

              return Card(
                child: ListTile(
                  onTap: () => _openMealDetail(index),
                  leading: Icon(_categoryIcon(category)),
                  title: Text(name),
                  subtitle: Text(_formatDate(date)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${amount.toStringAsFixed(2)}'),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddMeal,
        icon: const Icon(Icons.add),
        label: const Text('Add Meal'),
      ),
    );
  }
}
