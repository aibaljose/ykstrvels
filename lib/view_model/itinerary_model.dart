
class Itinerary {
  final int id;
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
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      desc: json['desc'],
      rating: json['rating'],
      destination: json['destination'],
      beforeYouFly: Map<String, String>.from(json['beforeyfly']),
      thingsToKnow: Map<String, String>.from(json['things2know']),
      days: (json['itinerary']['days'] as List)
          .map((day) => Day.fromJson(day))
          .toList(),
      budget: Budget.fromJson(json['budget']),
      packingList: PackingList.fromJson(json['packinglist']),
      createdAt: json['createdAt'],
    );
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
      day: json['day'],
      activities: (json['activities'] as List)
          .map((activity) => Activity.fromJson(activity))
          .toList(),
    );
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
      time: json['time'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
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
      total: json['total'],
      breakdown: Map<String, String>.from(json['breakdown']),
    );
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
  
  // Extract lists first
  final List<String> essentials = List<String>.from(jsonCopy['essentials'] ?? []);
  final List<String> clothing = List<String>.from(jsonCopy['clothing'] ?? []);  
  final List<String> extras = List<String>.from(jsonCopy['extras'] ?? []);
  
  // Remove the list keys
  jsonCopy.removeWhere((key, value) => ['essentials', 'clothing', 'extras'].contains(key));
  
  // Convert remaining items to Map<String, String>
  final Map<String, String> items = {};
  jsonCopy.forEach((key, value) {
    items[key] = value?.toString() ?? '';
  });

  return PackingList(
    items: items,
    essentials: essentials,
    clothing: clothing,
    extras: extras,
  );
}
}