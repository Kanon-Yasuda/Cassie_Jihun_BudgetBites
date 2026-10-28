import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> meals;

  const HistoryScreen({super.key, required this.meals});

  String formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    final Map<String, double> categoryTotals = {};

    for (var meal in meals) {
      final amount = meal['amount'] as double;
      final category = meal['category'] as String;

      total += amount;
      categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Insights'),
        backgroundColor: Colors.green.shade100,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Spending Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              title: const Text('Total Spending'),
              subtitle: Text('${meals.length} recorded meals'),
              trailing: Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Spending by Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...categoryTotals.entries.map((entry) {
            final progress = total > 0
                ? (entry.value / total).clamp(0.0, 1.0)
                : 0.0;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${entry.key}: \$${entry.value.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: progress),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          const Text(
            'All Meals',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (meals.isEmpty)
            const Text('No meals recorded yet.')
          else
            ...meals.map((meal) {
              final amount = meal['amount'] as double;
              final date = meal['date'] as DateTime;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(meal['name'] as String),
                  subtitle: Text('${meal['category']} - ${formatDate(date)}'),
                  trailing: Text('\$${amount.toStringAsFixed(2)}'),
                ),
              );
            }),
        ],
      ),
    );
  }
}
