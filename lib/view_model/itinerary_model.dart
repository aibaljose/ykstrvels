import 'package:flutter/material.dart';

class Itinerary {
  final String id; // Changed from int to String
  final String title;
  final String image;
  final String desc;
  final int rating;
  final String destination;
  final Map<String, String> beforeYouFly;
  final Map<String, String> thingsToKnow;
  final List<Day> days;
  final Budget budget;
  final PackingList packingList;
  final String createdAt;
  bool isFavorite;

  Itinerary({
    required this.id,
    required this.title,
    required this.image,
    required this.desc,
    required this.rating,
    required this.destination,
    required this.beforeYouFly,
    required this.thingsToKnow,
    required this.days,
    required this.budget,
    required this.packingList,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id']?.toString() ?? '', // Handle string ID
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      rating: _parseRating(json['rating']), // Parse rating safely
      destination: json['destination']?.toString() ?? '',
      beforeYouFly: _parseStringMap(json['beforeyfly']),
      thingsToKnow: _parseStringMap(json['things2know']),
      days: _parseDays(json['itinerary']),
      budget: Budget.fromJson(json['budget'] ?? {}),
      packingList: PackingList.fromJson(json['packinglist'] ?? {}),
      createdAt: json['createdAt']?.toString() ?? '',
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  // Helper method to safely parse rating
  static int _parseRating(dynamic rating) {
    if (rating == null) return 0;
    if (rating is int) return rating;
    if (rating is String) {
      return int.tryParse(rating) ?? 0;
    }
    return 0;
  }

  // Helper method to safely parse string maps
  static Map<String, String> _parseStringMap(dynamic data) {
    if (data == null) return {};
    if (data is Map) {
      return data.map((key, value) => MapEntry(
        key.toString(),
        value?.toString() ?? '',
      ));
    }
    return {};
  }

  // Helper method to safely parse days
  static List<Day> _parseDays(dynamic itineraryData) {
    if (itineraryData == null) return [];
    if (itineraryData is! Map) return [];
    
    final daysData = itineraryData['days'];
    if (daysData == null || daysData is! List) return [];

    return daysData
        .map((day) {
          try {
            return Day.fromJson(day as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing day: $e');
            return null;
          }
        })
        .where((day) => day != null)
        .cast<Day>()
        .toList();
  }
}

class Day {
  final int day;
  final List<Activity> activities;

  Day({
    required this.day,
    required this.activities,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      day: _parseInt(json['day']),
      activities: _parseActivities(json['activities']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static List<Activity> _parseActivities(dynamic activitiesData) {
    if (activitiesData == null || activitiesData is! List) return [];

    return activitiesData
        .map((activity) {
          try {
            return Activity.fromJson(activity as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing activity: $e');
            return null;
          }
        })
        .where((activity) => activity != null)
        .cast<Activity>()
        .toList();
  }
}

class Activity {
  final String time;
  final String title;
  final String description;
  final String icon;

  Activity({
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      time: json['time']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
    );
  }
}

class Budget {
  final String total;
  final Map<String, String> breakdown;

  Budget({
    required this.total,
    required this.breakdown,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      total: json['total']?.toString() ?? '¥0',
      breakdown: _parseStringMap(json['breakdown']),
    );
  }

  static Map<String, String> _parseStringMap(dynamic data) {
    if (data == null) return {};
    if (data is Map) {
      return data.map((key, value) => MapEntry(
        key.toString(),
        value?.toString() ?? '',
      ));
    }
    return {};
  }
}

class PackingList {
  final Map<String, String> items;
  final List<String> essentials;
  final List<String> clothing;
  final List<String> extras;

  PackingList({
    required this.items,
    required this.essentials,
    required this.clothing,
    required this.extras,
  });

  factory PackingList.fromJson(Map<String, dynamic> json) {
    // Create a copy of json to avoid modifying the original
    final Map<String, dynamic> jsonCopy = Map<String, dynamic>.from(json);
    
    // Extract lists first - handle null values
    final List<String> essentials = _parseStringList(jsonCopy['essentials']);
    final List<String> clothing = _parseStringList(jsonCopy['clothing']);  
    final List<String> extras = _parseStringList(jsonCopy['extras']);
    
    // Remove the list keys
    jsonCopy.removeWhere((key, value) => ['essentials', 'clothing', 'extras'].contains(key));
    
    // Convert remaining items to Map<String, String>
    final Map<String, String> items = {};
    jsonCopy.forEach((key, value) {
      if (value != null) {
        items[key] = value.toString();
      }
    });

    return PackingList(
      items: items,
      essentials: essentials,
      clothing: clothing,
      extras: extras,
    );
  }

  // Helper method to safely parse string lists
  static List<String> _parseStringList(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data.map((item) => item?.toString() ?? '').where((item) => item.isNotEmpty).toList();
    }
    if (data is String) {
      return [data];
    }
    return [];
  }
}