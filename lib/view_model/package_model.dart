class Package {
  final int? id;
  final String packageName;
  final String packageDescription;
  final String packagePrice;
  final String overview;
  final String highlight;
  final String noOfDays;
  final String locations;
  final String? discountPrice;
  final String accommodation;
  final String meals;
  final String transportation;
  final String? image; // Add if your API returns image URL
  bool isFavorite;//package model to support favourites

  Package({
    this.id,
    required this.packageName,
    required this.packageDescription,
    required this.packagePrice,
    required this.overview,
    required this.highlight,
    required this.noOfDays,
    required this.locations,
    this.discountPrice,
    required this.accommodation,
    required this.meals,
    required this.transportation,
    this.image,
    this.isFavorite = false,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      packageName: json['package_name'] ?? '',
      packageDescription: json['package_description'] ?? '',
      packagePrice: json['package_price']?.toString() ?? '0',
      overview: json['overview'] ?? '',
      highlight: json['highlight'] ?? '',
      noOfDays: json['no_of_days']?.toString() ?? '0',
      locations: json['locations'] ?? '',
      discountPrice: json['discount_price']?.toString(),
      accommodation: json['accommodation'] ?? '',
      meals: json['meals'] ?? '',
      transportation: json['transportation'] ?? '',
      image: json['image'],
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true, // Handle both int and bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'package_name': packageName,
      'package_description': packageDescription,
      'package_price': packagePrice,
      'overview': overview,
      'highlight': highlight,
      'no_of_days': noOfDays,
      'locations': locations,
      'discount_price': discountPrice,
      'accommodation': accommodation,
      'meals': meals,
      'transportation': transportation,
      'image': image,
    };
  }

  bool get hasDiscount => discountPrice != null && discountPrice!.isNotEmpty;
  
  double get priceValue => double.tryParse(packagePrice) ?? 0;
  double get discountPriceValue => double.tryParse(discountPrice ?? '0') ?? 0;
  int get daysCount => int.tryParse(noOfDays) ?? 0;
}