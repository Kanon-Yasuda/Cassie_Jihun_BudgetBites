
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> meals;

  const HistoryScreen({
    super.key,
    required this.meals,
  });

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final totalSpent = meals.fold<double>(
      0,
      (sum, meal) => sum + (meal['amount'] as double),
    );

    final Map<String, double> categoryTotals = {};

    for (final meal in meals) {
      final category = meal['category'] as String;
      final amount = meal['amount'] as double;

      categoryTotals[category] =
          (categoryTotals[category] ?? 0) + amount;
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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Spending'),
                  const SizedBox(height: 8),
                  Text(
                    '\$${totalSpent.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${meals.length} recorded meals'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Spending by Category',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (categoryTotals.isEmpty)
            const Text('No spending data yet.')
          else
            ...categoryTotals.entries.map((entry) {
              final progress = totalSpent > 0
                  ? (entry.value / totalSpent).clamp(0.0, 1.0)
                  : 0.0;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key),
                          Text(
                            '\$${entry.value.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),
          const Text(
            'All Meals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (meals.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No meals recorded yet.'),
              ),
            )
          else
            ...meals.map((meal) {
              final name = meal['name'] as String;
              final amount = meal['amount'] as double;
              final category = meal['category'] as String;
              final date = meal['date'] as DateTime;

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(name),
                  subtitle: Text(
                    '$category • ${_formatDate(date)}',
                  ),
                  trailing: Text(
                    '\$${amount.toStringAsFixed(2)}',
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
