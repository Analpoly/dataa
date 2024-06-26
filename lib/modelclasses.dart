  // Home page
class Category {
  final String id;
  final String name;
  final String imgUrlPath;

  Category({required this.id, required this.name, required this.imgUrlPath});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['Id'],
      name: json['Name'],
      imgUrlPath: json['ImgUrlPath'],
    );
  }
} 

 // Second page
class SubCategory {
  final String id;
  final String name;
  final String imgUrlPath;

  SubCategory({required this.id, required this.name, required this.imgUrlPath});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['Id'],
      name: json['Name'],
      imgUrlPath: json['ImgUrlPath'],
    );
  }
}