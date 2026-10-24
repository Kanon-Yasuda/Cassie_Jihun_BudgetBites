class Purchase {
  final int? id;
  final int mealId;
  final String itemName;
  final double cost;
  final DateTime date;

  Purchase({
    this.id,
    required this.mealId,
    required this.itemName,
    required this.cost,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'meal_id': mealId,
      'item_name': itemName,
      'cost': cost,
      'date': date.toIso8601String(),
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      mealId: map['meal_id'],
      itemName: map['item_name'],
      cost: (map['cost'] as num).toDouble(),
      date: DateTime.parse(map['date']),
    );
  }
}