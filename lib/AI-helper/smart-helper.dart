import '../database/database_helper.dart';

class SmartHelper {
  String suggestMoney(
    double budget,
    double totalSpent
  ){
    if (totalSpent >= budget) {
      return "You have exceeded your budget!";
    }
    if (totalSpent >= budget / 2) {
      return "Slow down! You are halfway to your budget";
    }
    return "You have not spent much yet. You can purchase more if you wish.";
  }
  Future<String> suggestFood(
    double budget,
    double totalSpent,
    double purchaseAmount,
  ) async {
    if (budget <= 0 || totalSpent < 0 || purchaseAmount < 0) {
      return "Invalid amount.";
    }

    final remaining = budget - totalSpent;

    if (purchaseAmount <= remaining) {
      return "This purchase is within your budget!";
    }

    final meals = await DatabaseHelper.instance.getAllMeals();
    final purchases = await DatabaseHelper.instance.getAllPurchases();

    for (final meal in meals) {
      double mealCost = 0;

      for (final purchase in purchases) {
        if (purchase.mealId == meal.id) {
          mealCost += purchase.cost;
        }
      }

      if (mealCost > 0 && mealCost <= remaining) {
        return "Consider ${meal.name} instead. "
            "It previously cost \$${mealCost.toStringAsFixed(2)}.";
      }
    }

    return "This purchase exceeds your remaining budget. "
        "No cheaper meal was found in your history.";
  }
}

