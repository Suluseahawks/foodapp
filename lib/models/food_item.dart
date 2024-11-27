class FoodItem {
  final int? id; // Nullable because it might not exist when creating a new item
  final String name;
  final double cost;

  FoodItem({
    this.id,
    required this.name,
    required this.cost,
  });

  // Convert a FoodItem into a Map (to store in the database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
    };
  }

  // Convert a Map (retrieved from the database) into a FoodItem
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      cost: map['cost'],
    );
  }
}
