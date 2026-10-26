import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_bites/main.dart';

void main() {
  testWidgets('Dashboard loads correctly', (tester) async {
    await tester.pumpWidget(const BudgetBitesApp());

    expect(find.text('Budget Bites'), findsOneWidget);
    expect(find.text('Recent Meals'), findsOneWidget);
    expect(find.text('Add Meal'), findsOneWidget);
  });

  testWidgets('Add Meal screen opens', (tester) async {
    await tester.pumpWidget(const BudgetBitesApp());

    await tester.tap(find.text('Add Meal'));
    await tester.pumpAndSettle();

    expect(find.text('Meal Name'), findsOneWidget);
    expect(find.text('Amount'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
  });

  testWidgets('Adding a meal updates spending', (tester) async {
    await tester.pumpWidget(const BudgetBitesApp());

    // Open the Add Meal screen.
    await tester.tap(find.text('Add Meal'));
    await tester.pumpAndSettle();

    // Enter meal information.
    await tester.enterText(find.byType(TextFormField).at(0), 'Pizza');

    await tester.enterText(find.byType(TextFormField).at(1), '15.50');

    // Save the meal.
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Add Meal'));

    await tester.tap(find.widgetWithText(FilledButton, 'Add Meal'));

    await tester.pumpAndSettle();

    // Verify the new meal and updated spending.
    expect(find.text('Pizza'), findsOneWidget);
    expect(find.text('Spent: \$71.00'), findsOneWidget);
    expect(find.text('Remaining: \$129.00'), findsOneWidget);
  });
}
