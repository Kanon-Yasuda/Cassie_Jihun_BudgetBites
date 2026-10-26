import 'package:flutter/material.dart';

class MealDetailScreen extends StatelessWidget {
  final Map<String, dynamic> meal;

  const MealDetailScreen({super.key, required this.meal});

  String formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> deleteMeal(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Meal'),
        content: const Text('Are you sure you want to delete this meal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.pop(context, {'action': 'delete'});
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = meal['amount'] as double;
    final date = meal['date'] as DateTime;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Details'),
        backgroundColor: Colors.green.shade100,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal['name'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Amount: \$${amount.toStringAsFixed(2)}'),
                  Text('Category: ${meal['category']}'),
                  Text('Date: ${formatDate(date)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context, {'action': 'edit'});
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Meal'),
          ),
          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () => deleteMeal(context),
            icon: const Icon(Icons.delete),
            label: const Text('Delete Meal'),
          ),
        ],
      ),
    );
  }
}
