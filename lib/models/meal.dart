class Meal {
  final int? id;
  final String name;
  final String category;
  final DateTime date;
  final String notes;

  Meal({
    this.id,
    required this.name,
    required this.category,
    required this.date,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      notes: map['notes'] ?? '',
    );
  }
}