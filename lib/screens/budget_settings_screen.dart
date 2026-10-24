
import 'package:flutter/material.dart';

class BudgetSettingsScreen extends StatefulWidget {
  final double currentBudget;

  const BudgetSettingsScreen({
    super.key,
    required this.currentBudget,
  });

  @override
  State<BudgetSettingsScreen> createState() =>
      _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState
    extends State<BudgetSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _budgetController.text =
        widget.currentBudget.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _saveBudget() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newBudget = double.parse(
      _budgetController.text.trim(),
    );

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
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 12),

            const Icon(
              Icons.account_balance_wallet,
              size: 56,
              color: Colors.green,
            ),

            const SizedBox(height: 16),

            const Text(
              'Set Your Monthly Budget',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            const Text(
              'Enter the amount you want to spend '
              'on meals and groceries each month.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            TextFormField(
              controller: _budgetController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monthly Budget',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final amount = double.tryParse(
                  value?.trim() ?? '',
                );

                if (amount == null ||
                    !amount.isFinite ||
                    amount <= 0) {
                  return 'Enter a valid budget greater than 0';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _saveBudget,
              icon: const Icon(Icons.save),
              label: const Text('Save Budget'),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),

            const SizedBox(height: 24),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Tip: Review your spending regularly '
                  'to stay within your monthly budget.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
