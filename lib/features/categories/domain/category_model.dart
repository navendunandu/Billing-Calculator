/// Model representing a product category
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.itemCount = 0,
  });

  final int id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int itemCount;

  CategoryModel copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? itemCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      itemCount: itemCount ?? this.itemCount,
    );
  }
}

/// Draft data for creating or editing a category
class CategoryDraft {
  const CategoryDraft({
    required this.name,
    this.description,
  });

  final String name;
  final String? description;
}
