import 'package:flutter/material.dart';

class BudgetSettingsScreen extends StatefulWidget {
  final double currentBudget;

  const BudgetSettingsScreen({super.key, required this.currentBudget});

  @override
  State<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  final formKey = GlobalKey<FormState>();
  final budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    budgetController.text = widget.currentBudget.toStringAsFixed(2);
  }

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  void saveBudget() {
    if (!formKey.currentState!.validate()) return;

    final newBudget = double.parse(budgetController.text.trim());

    Navigator.pop(context, newBudget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Settings'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(
              Icons.account_balance_wallet,
              size: 56,
              color: Colors.green,
            ),
            const SizedBox(height: 16),

            const Text(
              'Set Your Monthly Budget',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const Text(
              'Enter your monthly budget for meals and groceries.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            TextFormField(
              controller: budgetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monthly Budget',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final amount = double.tryParse(value?.trim() ?? '');

                if (amount == null || !amount.isFinite || amount <= 0) {
                  return 'Enter a valid budget greater than 0';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: saveBudget,
              icon: const Icon(Icons.save),
              label: const Text('Save Budget'),
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
