class Package {
  final String id;
  final String packageName;
  final String packageDescription;
  final String packagePrice;
  final String? discountPrice;
  final String overview;
  final String highlight;
  final String daysCount;
  final String locations;
  final String accommodation;
  final String meals;
  final String transportation;
  final String? image;
  final int trending;
  final int categoryId;
  bool isFavorite;

  Package({
    required this.id,
    required this.packageName,
    required this.packageDescription,
    required this.packagePrice,
    this.discountPrice,
    required this.overview,
    required this.highlight,
    required this.daysCount,
    required this.locations,
    required this.accommodation,
    required this.meals,
    required this.transportation,
    this.image,
    required this.trending,
    required this.categoryId,
    this.isFavorite = true,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id']?.toString() ?? '',
      packageName: json['package_name']?.toString() ?? '',
      packageDescription: json['package_description']?.toString() ?? '',
      packagePrice: json['package_price']?.toString() ?? '0',
      discountPrice: json['discount_price']?.toString(),
      overview: json['overview']?.toString() ?? '',
      highlight: json['highlight']?.toString() ?? '',
      daysCount: json['no_of_days']?.toString() ?? '1',
      locations: json['locations']?.toString() ?? '',
      accommodation: json['accommodation']?.toString() ?? '',
      meals: json['meals']?.toString() ?? '',
      transportation: json['transportation']?.toString() ?? '',
      image: _buildImageUrl(json['package_image']),
      trending: _parseInt(json['trending']),
      categoryId: _parseInt(json['category_id']),
      isFavorite: json['is_favorite'] ?? true,
    );
  }

  // Helper method to build full image URL
  static String? _buildImageUrl(dynamic imageData) {
    if (imageData == null) return null;
    final imagePath = imageData.toString();
    if (imagePath.isEmpty) return null;
    
    // If it's already a full URL, return as is
    if (imagePath.startsWith('http')) return imagePath;
    
    // Otherwise, prepend the base URL
    return 'https://ykstrip.in/$imagePath';
  }

  // Helper method to safely parse integers
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // Computed properties for easier access
  double get priceValue => double.tryParse(packagePrice) ?? 0.0;
  double get discountPriceValue => double.tryParse(discountPrice ?? '0') ?? 0.0;
  bool get hasDiscount => discountPrice != null && discountPriceValue > 0 && discountPriceValue < priceValue;
  int get daysCountInt => int.tryParse(daysCount) ?? 1;
  bool get isTrending => trending == 1;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'package_name': packageName,
      'package_description': packageDescription,
      'package_price': packagePrice,
      'discount_price': discountPrice,
      'overview': overview,
      'highlight': highlight,
      'no_of_days': daysCount,
      'locations': locations,
      'accommodation': accommodation,
      'meals': meals,
      'transportation': transportation,
      'package_image': image,
      'trending': trending,
      'category_id': categoryId,
      'is_favorite': isFavorite,
    };
  }
}