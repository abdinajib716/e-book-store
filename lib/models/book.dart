class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageAssetPath;
  final String pdfAssetPath;
  final double price;
  final double originalPrice;
  final bool isDiscounted;
  final String language;
  final int pages;
  final double rating;
  final List<String> categories;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageAssetPath,
    required this.pdfAssetPath,
    required this.price,
    required this.originalPrice,
    this.isDiscounted = false,
    this.language = 'Somali',
    this.pages = 0,
    this.rating = 0.0,
    this.categories = const [],
  });

  factory Book.fromJson(Map<String, dynamic> json,
      [Map<String, dynamic>? priceInfo]) {
    final price = (priceInfo?['price'] ?? json['price'] ?? 19.99).toDouble();
    final originalPrice =
        (priceInfo?['originalPrice'] ?? json['originalPrice'] ?? price)
            .toDouble();

    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      imageAssetPath: json['imageAssetPath'] ?? '',
      pdfAssetPath: json['pdfAssetPath'] ?? '',
      price: price,
      originalPrice: originalPrice,
      isDiscounted: priceInfo?['discounted'] ?? false,
      language: json['language'] ?? 'Somali',
      pages: json['pages'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'imageAssetPath': imageAssetPath,
      'pdfAssetPath': pdfAssetPath,
      'price': price,
      'originalPrice': originalPrice,
      'isDiscounted': isDiscounted,
      'language': language,
      'pages': pages,
      'rating': rating,
      'categories': categories,
    };
  }
}
