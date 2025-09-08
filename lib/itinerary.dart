import 'package:flutter/material.dart';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  int _selectedIndex = -1;

  final List<ItineraryCardData> _cardData = [
    ItineraryCardData(
      title: 'Before You Fly',
      icon: Icons.flight_takeoff,
      color: Colors.blue.shade600,
      content: [
        'Check passport validity (min 6 months)',
        'Confirm flight details & check-in online',
        'Purchase travel insurance',
        'Notify your bank of travel plans',
        'Make copies of important documents',
        'Exchange currency or arrange travel card',
        'Check weather forecast',
        'Confirm hotel reservations',
      ],
    ),
    ItineraryCardData(
      title: 'Things To Know',
      icon: Icons.info_outline,
      color: Colors.indigo.shade400,
      content: [
        'Local emergency numbers: 911',
        'Embassy contact: +1-555-123-4567',
        'Local language: English',
        'Currency: USD',
        'Time zone: UTC-5',
        'Tipping: 15-20%',
        'Tap water is safe',
        'Public transport: Subway, buses, rideshare',
      ],
    ),
    ItineraryCardData(
      title: 'Itinerary: Munnar',
      icon: Icons.map_outlined,
      color: Colors.green.shade400,
      content: [
        // We'll use a custom widget for this card in the detail view
        // So keep this content list empty or with a placeholder
      ],
    ),
    ItineraryCardData(
      title: 'Budget & Tips',
      icon: Icons.account_balance_wallet_outlined,
      color: Colors.orange.shade400,
      content: [
        'Accommodation: \$150-200/night',
        'Meals: \$50-80/day',
        'Transport: \$30/day',
        'Activities: \$200 total',
        'Tips: Use public transport, city passes, free museum days',
      ],
    ),
    ItineraryCardData(
      title: 'Packing List',
      icon: Icons.luggage_outlined,
      color: Colors.red.shade400,
      content: [
        'Passport & ID',
        'Flight tickets',
        'Credit cards & cash',
        'Phone & charger',
        'Medications',
        'Weather-appropriate clothes',
        'Comfortable shoes',
        'Toiletries',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Travel Planning',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: _selectedIndex == -1
          ? _buildCardsGridView(context)
          : _buildDetailView(context, _selectedIndex),
    );
  }

  Widget _buildCardsGridView(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 700 ? 2 : 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: _cardData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.6,
        ),
        itemBuilder: (context, index) {
          final card = _cardData[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: card.color.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(card.icon, color: card.color, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    card.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: card.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...card.content
                      .take(2)
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• $item',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                  if (card.content.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '+${card.content.length - 2} more',
                        style: TextStyle(
                          color: card.color,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailView(BuildContext context, int index) {
    final card = _cardData[index];

    // Custom timeline for "Itinerary: Munnar"
    if (card.title.startsWith('Itinerary')) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _dayTimeline(
            dayTitle: "Day 1, 10 Mar 2025",
            activities: [
              TimelineActivity(
                icon: Icons.flight_land,
                title: "Arrive at Kochi Airport",
                time: "09:00 AM",
              ),
              TimelineActivity(
                icon: Icons.hotel,
                title: "Hotel Check In",
                time: "11:00 AM",
              ),
              TimelineActivity(
                icon: Icons.restaurant,
                title: "Lunch at Saravana Bhavan",
                time: "01:30 PM",
                actionLabel: "View directions",
                onAction: () {},
              ),
              TimelineActivity(
                icon: Icons.nature,
                title: "Visit Tea Gardens",
                time: "04:00 PM",
              ),
              TimelineActivity(
                icon: Icons.dinner_dining,
                title: "Dinner at Rapsy Restaurant",
                time: "08:00 PM",
              ),
            ],
          ),
          _dayTimeline(
            dayTitle: "Day 2, 11 Mar 2025",
            activities: [
              TimelineActivity(
                icon: Icons.breakfast_dining,
                title: "Breakfast at Hotel",
                time: "09:00 AM",
              ),
              TimelineActivity(
                icon: Icons.park,
                title: "Explore Eravikulam National Park",
                time: "11:00 AM",
              ),
              TimelineActivity(
                icon: Icons.shopping_bag,
                title: "Shopping at Local Market",
                time: "03:00 PM",
              ),
              TimelineActivity(
                icon: Icons.dinner_dining,
                title: "Dinner at Hotel",
                time: "08:00 PM",
              ),
            ],
          ),
          _dayTimeline(
            dayTitle: "Day 3, 12 Mar 2025",
            activities: [
              TimelineActivity(
                icon: Icons.coffee,
                title: "Breakfast & Checkout",
                time: "09:00 AM",
              ),
              TimelineActivity(
                icon: Icons.directions_bus,
                title: "Depart for Kochi",
                time: "10:00 AM",
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: card.color,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = -1),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: Icon(Icons.arrow_back, color: Colors.black87),
                    ),
                  ),
                  const Spacer(),
                  Icon(card.icon, color: Colors.white, size: 32),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                card.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: card.content.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, color: card.color, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      card.content[i],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dayTimeline({
    required String dayTitle,
    required List<TimelineActivity> activities,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...activities.map((activity) => _timelineTile(activity)).toList(),
        ],
      ),
    );
  }

  Widget _timelineTile(TimelineActivity activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(activity.icon, color: Colors.green.shade400, size: 24),
              Container(width: 2, height: 32, color: Colors.green.shade100),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  activity.time,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                if (activity.actionLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: activity.onAction,
                      child: Text(activity.actionLabel!),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItineraryCardData {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> content;

  ItineraryCardData({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
  });
}

class TimelineActivity {
  final IconData icon;
  final String title;
  final String time;
  final String? actionLabel;
  final VoidCallback? onAction;

  TimelineActivity({
    required this.icon,
    required this.title,
    required this.time,
    this.actionLabel,
    this.onAction,
  });
}
