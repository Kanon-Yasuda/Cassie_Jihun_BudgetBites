import 'package:flutter/material.dart';
import '../AI-helper/smart-helper.dart';

class SmartHelperScreen extends StatelessWidget {
  final double budget;
  final double totalSpent;

  const SmartHelperScreen({
    Key? key,
    required this.budget,
    required this.totalSpent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Helper'),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Budget: \$${budget.toStringAsFixed(2)}'),
              Text('Spent: \$${totalSpent.toStringAsFixed(2)}'),

              SizedBox(height: 20),

              Text(SmartHelper().suggestMoney(budget, totalSpent), textAlign: TextAlign.center,
                ),
            ],
          ),
      ),
    );
  }
}