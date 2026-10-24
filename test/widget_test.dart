
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_bites/main.dart';

void main() {
  testWidgets(
    'Budget Bites dashboard loads correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const BudgetBitesApp(),
      );

      expect(
        find.text('Budget Bites'),
        findsOneWidget,
      );

      expect(
        find.text('Recent Meals'),
        findsOneWidget,
      );

      expect(
        find.text('Add Meal'),
        findsOneWidget,
      );

      expect(
        find.byIcon(Icons.add),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Add Meal screen opens and validates input',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const BudgetBitesApp(),
      );

      await tester.tap(find.text('Add Meal'));
      await tester.pumpAndSettle();

      expect(
        find.text('Add a New Meal'),
        findsOneWidget,
      );

      await tester.tap(find.text('Save Meal'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please enter a meal name'),
        findsOneWidget,
      );

      expect(
        find.text('Enter a valid amount greater than 0'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Adding a meal updates the dashboard',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const BudgetBitesApp(),
      );

      await tester.tap(find.text('Add Meal'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Meal Name'),
        'Pizza',
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Amount'),
        '15.50',
      );

      await tester.tap(find.text('Save Meal'));
      await tester.pumpAndSettle();

      expect(
        find.text('Pizza'),
        findsOneWidget,
      );

      expect(
        find.text('Spent: \$71.00'),
        findsOneWidget,
      );

      expect(
        find.text('Remaining: \$129.00'),
        findsOneWidget,
      );
    },
  );
}
