class Category {
  final String id;
  final String name;
  final List<Category> children;

  Category({
    required this.id,
    required this.name,
    required this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      children: (json['children'] as List?)
          ?.map((e) => Category.fromJson(e))
          .toList() ??
          [],
    );
  }
}