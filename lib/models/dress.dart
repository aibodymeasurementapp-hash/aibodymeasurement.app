class Dress {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String type;
  final List<String> availableSizes;
  final String suggestedSize;

  Dress({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.type,
    required this.availableSizes,
    required this.suggestedSize,
  });
}

enum DressCategory { men, women, kids }
enum DressType { pantShirt, shalwarQameez }
