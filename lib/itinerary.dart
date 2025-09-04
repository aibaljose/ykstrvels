import 'package:flutter/material.dart';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  // Current selected card index
  int _selectedIndex = -1;

  // List of card data
  final List<ItineraryCardData> _cardData = [
    ItineraryCardData(
      title: 'BEFORE YOU FLY',
      color: Colors.blue.shade700,
      icon: Icons.flight_takeoff,
      content: [
        'Check your passport validity (minimum 6 months)',
        'Confirm your flight details and check-in online',
        'Purchase travel insurance',
        'Notify your bank of travel plans',
        'Make copies of important documents',
        'Exchange currency or arrange for a travel card',
        'Check weather forecast at your destination',
        'Confirm hotel reservations',
      ],
    ),
    ItineraryCardData(
      title: 'THINGS TO KNOW',
      color: Colors.purple.shade700,
      icon: Icons.lightbulb_outline,
      content: [
        'Local emergency numbers: 911',
        'Embassy contact: +1-555-123-4567',
        'Local language: English',
        'Currency: USD (1 USD = approx. 0.85 EUR)',
        'Time zone: UTC-5 (Eastern Standard Time)',
        'Tipping: 15-20% for services',
        'Tap water is generally safe to drink',
        'Public transportation options: Subway, buses, rideshare services',
      ],
    ),
    ItineraryCardData(
      title: 'ITINERARY',
      color: Colors.green.shade700,
      icon: Icons.map_outlined,
      content: [
        'Day 1: Arrival & Hotel Check-in',
        '• 2:30 PM: Flight arrival at JFK Airport',
        '• 4:00 PM: Check-in at Grand Central Hotel',
        '• 7:00 PM: Welcome dinner at Skyline Restaurant',
        'Day 2: City Exploration',
        '• 9:00 AM: Breakfast at hotel',
        '• 10:30 AM: Guided city tour',
        '• 1:00 PM: Lunch at Harbor View Café',
        '• 3:00 PM: Museum visit',
        '• 7:30 PM: Dinner cruise',
        'Day 3: Day Trip',
        '• 8:00 AM: Breakfast',
        '• 9:30 AM: Depart for mountain excursion',
        '• 12:30 PM: Picnic lunch',
        '• 5:00 PM: Return to hotel',
        '• 7:00 PM: Dinner at local restaurant',
      ],
    ),
    ItineraryCardData(
      title: 'BUDGET & TRAVEL TIPS',
      color: Colors.orange.shade700,
      icon: Icons.account_balance_wallet_outlined,
      content: [
        'Estimated Budget:',
        '• Accommodation: \$150-200 per night',
        '• Meals: \$50-80 per day',
        '• Transportation: \$30 per day',
        '• Activities: \$200 total',
        '• Shopping & Souvenirs: \$100-200',
        'Money-Saving Tips:',
        '• Buy a city attraction pass',
        '• Use public transportation',
        '• Look for "prix fixe" lunch menus',
        '• Carry a water bottle',
        '• Check for free museum days',
      ],
    ),
    ItineraryCardData(
      title: 'PACKING LIST',
      color: Colors.red.shade700,
      icon: Icons.luggage_outlined,
      content: [
        'Essentials:',
        '• Passport and ID',
        '• Flight tickets/confirmations',
        '• Credit cards and cash',
        '• Phone and charger',
        '• Medications',
        'Clothing:',
        '• Weather-appropriate outfits',
        '• Comfortable walking shoes',
        '• Sleepwear',
        '• Formal outfit for nice restaurants',
        'Toiletries:',
        '• Toothbrush and toothpaste',
        '• Shampoo and conditioner',
        '• Sunscreen',
        '• Personal hygiene items',
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
        title: Text(
          'Travel Planner',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey.shade800),
            onPressed: () {},
          ),
        ],
      ),
      body: _selectedIndex >= 0 ? _buildDetailView() : _buildCardsGridView(),
    );
  }

  Widget _buildCardsGridView() {
    // Use LayoutBuilder to make the design responsive
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the optimal number of columns based on screen width
        final double width = constraints.maxWidth;
        final int crossAxisCount = width > 700 ? 2 : 1;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Travel Planning',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Everything you need for your trip',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.4,
                ),
                itemCount: _cardData.length,
                itemBuilder: (context, index) {
                  return _buildCard(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(int index) {
    final card = _cardData[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: card.color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: card.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(card.icon, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      card.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Card preview content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${card.content.length} items',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Show first 2 items as preview
                    ...card.content
                        .take(2)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: card.color.withOpacity(0.7),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        ,
                    if (card.content.length > 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+ ${card.content.length - 2} more',
                          style: TextStyle(
                            color: card.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailView() {
    final card = _cardData[_selectedIndex];

    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: card.color,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = -1;
                        });
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      radius: 18,
                      child: Icon(
                        Icons.bookmark_border,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      radius: 18,
                      child: Icon(Icons.share, size: 20, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Icon(card.icon, color: Colors.white, size: 40),
                const SizedBox(height: 16),
                Text(
                  card.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${card.content.length} items',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: card.content.length,
            itemBuilder: (context, index) {
              final item = card.content[index];
              final bool isHeader =
                  !item.startsWith('•') && !item.startsWith('- ');

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isHeader)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.check_circle,
                          color: card.color,
                          size: 18,
                        ),
                      ),
                    if (isHeader)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(
                          item.contains('Day')
                              ? Icons.calendar_today
                              : Icons.label,
                          color: card.color,
                          size: 18,
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item,
                            style: TextStyle(
                              fontSize: isHeader ? 18 : 15,
                              fontWeight: isHeader
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          if (isHeader) const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ItineraryCardData {
  final String title;
  final Color color;
  final IconData icon;
  final List<String> content;

  ItineraryCardData({
    required this.title,
    required this.color,
    required this.icon,
    required this.content,
  });
}
