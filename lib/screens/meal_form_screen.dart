
import 'package:flutter/material.dart';

class MealFormScreen extends StatefulWidget {
  final Map<String, dynamic>? existingMeal;

  const MealFormScreen({
    super.key,
    this.existingMeal,
  });

  @override
  State<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends State<MealFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  String _category = 'Meal';

  bool get isEditing => widget.existingMeal != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final meal = widget.existingMeal!;
      _nameController.text = meal['name'] as String;
      _amountController.text =
          (meal['amount'] as double).toStringAsFixed(2);
      _category = meal['category'] as String;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveMeal() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(context, <String, dynamic>{
      'name': _nameController.text.trim(),
      'amount': double.parse(_amountController.text.trim()),
      'category': _category,
      'date': isEditing
          ? widget.existingMeal!['date']
          : DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Meal' : 'Add Meal'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              isEditing ? 'Edit Meal' : 'Add a New Meal',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Meal Name',
                hintText: 'e.g. Pizza',
                prefixIcon: Icon(Icons.restaurant),
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
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final amount =
                    double.tryParse(value?.trim() ?? '');
                if (amount == null ||
                    !amount.isFinite ||
                    amount <= 0) {
                  return 'Enter a valid amount greater than 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Meal',
                  child: Text('Meal'),
                ),
                DropdownMenuItem(
                  value: 'Groceries',
                  child: Text('Groceries'),
                ),
                DropdownMenuItem(
                  value: 'Snack',
                  child: Text('Snack'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _category = value);
                }
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saveMeal,
              icon: const Icon(Icons.save),
              label: Text(isEditing ? 'Save Changes' : 'Save Meal'),
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
