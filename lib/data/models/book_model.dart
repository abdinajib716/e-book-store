import '../../domain/entities/models/book.dart';

class BookModel extends Book {
  BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.description,
    required super.imageAssetPath,
    required super.pdfAssetPath,
    required super.price,
    required super.originalPrice,
    super.isDiscounted,
    super.language,
    super.pages,
    super.rating,
    super.categories,
  });

  factory BookModel.fromJson(Map<String, dynamic> json,
      [Map<String, dynamic>? priceInfo]) {
    final price = (priceInfo?['price'] ?? json['price'] ?? 19.99).toDouble();
    final originalPrice =
        (priceInfo?['originalPrice'] ?? json['originalPrice'] ?? price)
            .toDouble();

    return BookModel(
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

  @override
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
