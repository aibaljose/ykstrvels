import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yksworld/view_model/itinerary_model.dart';
import 'package:yksworld/theme.dart'; // For AppColors
import 'dart:convert';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

// ...existing code...

class _ItineraryPageState extends State<ItineraryPage> {
  List<Itinerary> _itineraries = [];
  Map<String, int> _currentStep =
      {}; // Changed from Map<int, int> to Map<String, int>

  @override
  void initState() {
    super.initState();
    _loadItineraries();
  }

  void _loadItineraries() {
    // Mock JSON data (replace with API call in production)
    const jsonString = '''
    [
      {
        "id": "1758950263858", // Change to string
        "title": "Kerala blackwaters",
        "image": "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "desc": "Explore the serene backwaters of Kerala.",
        "rating": 0,
        "destination": "Kerala, India",
        "beforeyfly": {
          "asdasdsad": "asdasdasdsadasd",
          "asdsadasd": "asdasdsadasdasd",
          "asdasdas": "dasdasdadsasd",
          "sdfsfsdfsdf": "sdfsdfsdfd",
          "sdfsdfsdf": "sdfsdfsdf"
        },
        "things2know": {
          "sdfsdf": "sdfsdf",
          "dfsdfsdfs": "dfsdfsdf",
          "dfsdfsd": "fsdfsdf",
          "sdfsdfs": "sfdfsdfsd"
        },
        "itinerary": {
          "days": [
            {
              "day": 1,
              "activities": [
                {
                  "time": "1",
                  "title": "foiod",
                  "description": "asdadasdasd",
                  "icon": "Coffee"
                },
                {
                  "time": "2",
                  "title": "sdfsf",
                  "description": "sdfdsfsdfsdfsdfdsf",
                  "icon": "Coffee"
                },
                {
                  "time": "3",
                  "title": "cxvcv",
                  "description": "vdsdv",
                  "icon": "Landmark"
                }
              ]
            },
            {
              "day": 2,
              "activities": [
                {
                  "time": "1",
                  "title": "sdsdf",
                  "description": "sfdsdfdsfsdfsdfsdfsdfsdfdsfsdfdsf",
                  "icon": "Coffee"
                },
                {
                  "time": "2",
                  "title": "sdvsdvsdvs",
                  "description": "vsdvsdvdsvsdvsdvsdvsdvsdv",
                  "icon": "Coffee"
                },
                {
                  "time": "3",
                  "title": "sdcvds",
                  "description": "svsdvsdvsvsdvsdv",
                  "icon": "Coffee"
                }
              ]
            },
            {
              "day": 3,
              "activities": [
                {
                  "time": "1",
                  "title": "sdvsvs",
                  "description": "svsdvsdvsdvdsv",
                  "icon": "Coffee"
                },
                {
                  "time": "2",
                  "title": "sdfsdcsdvsvsdv",
                  "description": "scsdfdsfdsfdsfsdf",
                  "icon": "Coffee"
                }
              ]
            }
          ]
        },
        "budget": {
          "total": "¥0",
          "breakdown": {
            "fsdfdsfds": "fsdfdfsdf",
            "sdfsdfsdfs": "fsdf",
            "dfsdfsdf": "sdfs",
            "sdfsdf": "sdfsdf"
          }
        },
        "packinglist": {
          "sdfsfd": "sdfs",
          "sdfdsf": "sdfsdf",
          "sdfsdf": "sdfsdf",
          "sdfdsf": "sdfsdf",
          "essentials": [],
          "clothing": [],
          "extras": [
            "sdfs",
            "sdfsdf",
            "sdfsdf",
            "sdfsdf"
          ]
        },
        "createdAt": "2025-09-27T05:17:43.858Z"
      },
      {
        "id": "1758875035892", // Change to string
        "title": "Bali | 2D1N",
        "image": "https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "desc": "This was a temple in Bali well known for the sunset's it can produce...",
        "rating": 0,
        "destination": "Bali, Indonesi",
        "beforeyfly": {
          "asdadad": "sadasdasdaas",
          "asdasdasd": "asdsada",
          "asdasdad": "asdasda",
          "asdasda": "adsasda",
          "adasd": "asdasd"
        },
        "things2know": {
          "asdsad": "asdasd",
          "asdasd": "asdasd",
          "sdasd": "asdasd"
        },
        "itinerary": {
          "days": [
            {
              "day": 1,
              "activities": [
                {
                  "time": "1:00 AM",
                  "title": "Food",
                  "description": "Food thitrha mathi",
                  "icon": "Coffee"
                },
                {
                  "time": "2",
                  "title": "3",
                  "description": "3",
                  "icon": "Coffee"
                }
              ]
            },
            {
              "day": 2,
              "activities": [
                {
                  "time": "2",
                  "title": "3",
                  "description": "2",
                  "icon": "Coffee"
                },
                {
                  "time": "3",
                  "title": "4",
                  "description": "3",
                  "icon": "Coffee"
                }
              ]
            }
          ]
        },
        "budget": {
          "total": "¥0",
          "breakdown": {
            "asdasd": "asdasd",
            "asdad": "asdsad"
          }
        },
        "packinglist": {
          "asdasda": "adasda",
          "essentials": [],
          "clothing": [],
          "extras": [
            "adasda"
          ]
        },
        "createdAt": "2025-09-26T08:23:55.892Z"
      }
    ]
    ''';
    final List<dynamic> jsonData = jsonDecode(jsonString);
    setState(() {
      _itineraries = jsonData.map((item) => Itinerary.fromJson(item)).toList();
      _currentStep = {for (var itinerary in _itineraries) itinerary.id: 0};
    });
  }

  // Add more icon mappings
  IconData _getIconForActivity(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'coffee':
        return Icons.local_cafe;
      case 'landmark':
        return Icons.account_balance;
      case 'sunrise':
        return Icons.wb_sunny;
      case 'theater':
        return Icons.theaters;
      case 'hotel':
        return Icons.hotel;
      case 'car':
        return Icons.directions_car;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Itineraries"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _itineraries.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _itineraries.length,
              itemBuilder: (context, index) {
                final itinerary = _itineraries[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ...existing image and content code...
                      // Itinerary Days
                      _buildStepperHeader(itinerary),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          controller: PageController(),
                          itemCount: itinerary.days.length,
                          onPageChanged: (pageIndex) {
                            setState(() {
                              _currentStep[itinerary.id] = pageIndex;
                            });
                          },
                          itemBuilder: (context, pageIndex) {
                            return _buildDayContent(itinerary.days[pageIndex]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStepperHeader(Itinerary itinerary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(itinerary.days.length, (index) {
          final day = itinerary.days[index];
          final isActive = index <= (_currentStep[itinerary.id] ?? 0);

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index != 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isActive
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isActive
                          ? AppColors.primary
                          : Colors.grey.shade200,
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (index != itinerary.days.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: (index < (_currentStep[itinerary.id] ?? 0))
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Day ${day.day}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ...rest of the existing code remains the same...

  Widget _buildDayContent(Day day) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day ${day.day}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: day.activities.length,
              itemBuilder: (context, index) {
                final activity = day.activities[index];
                return ListTile(
                  leading: Icon(
                    _getIconForActivity(activity.icon),
                    color: AppColors.accent,
                  ),
                  title: Text(
                    activity.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${activity.time}: ${activity.description}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
