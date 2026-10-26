import 'package:flutter/material.dart';

class MealFormScreen extends StatefulWidget {
  final Map<String, dynamic>? existingMeal;

  const MealFormScreen({super.key, this.existingMeal});

  @override
  State<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends State<MealFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  String category = 'Meal';

  bool get isEditing => widget.existingMeal != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final meal = widget.existingMeal!;
      nameController.text = meal['name'] as String;
      amountController.text = (meal['amount'] as double).toString();
      category = meal['category'] as String;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void saveMeal() {
    if (!formKey.currentState!.validate()) return;

    final meal = {
      'name': nameController.text.trim(),
      'amount': double.parse(amountController.text.trim()),
      'category': category,
      'date': isEditing ? widget.existingMeal!['date'] : DateTime.now(),
    };

    Navigator.pop(context, meal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Meal' : 'Add Meal'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Meal Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a meal name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final amount = double.tryParse(value ?? '');

                if (amount == null || !amount.isFinite || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: ['Meal', 'Groceries', 'Snack']
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: saveMeal,
              child: Text(isEditing ? 'Save Changes' : 'Add Meal'),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
