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
      id: json['_id'],
      name: json['name'],
      children: json['children'] != null
          ? List<Category>.from(
          json['children'].map((x) => Category.fromJson(x)))
          : [],
    );
  }
}