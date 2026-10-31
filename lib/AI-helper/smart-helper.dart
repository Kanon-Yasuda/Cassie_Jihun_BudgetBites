class SmartHelper {
  String suggestMoney(
    double budget,
    double totalSpent
  ){
    if (totalSpent >= budget/2)
    return "Slow down! You are halfway to your budget";
    if (totalSpent >= budget)
    return "You have exceeded your budget!";
    if (totalSpent < budget/2)
    return "You have not spent much yet. This purchase is within your budget.";
  }
  String suggestFood(
    double budget,
    double purchaseAmount,
    // add something that looks at your meal database and suggest something within your budget
  ){
    
  }
}

