import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text('Smart Helper Content'),
      ),
    );
  }
}