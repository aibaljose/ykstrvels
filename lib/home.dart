import 'package:flutter/material.dart';

class TravelStoriesPage extends StatefulWidget {
  const TravelStoriesPage({Key? key}) : super(key: key);

  @override
  State<TravelStoriesPage> createState() => _TravelStoriesPageState();
}

class _TravelStoriesPageState extends State<TravelStoriesPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.explore,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Travel itinerary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  
                  const SizedBox(width: 40),
                     Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                     Icons.person_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ), // Balance the layout
                ],
              ),
            ),

            // Tab selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildTabButton('FRIENDS', 0, true),
                  const SizedBox(width: 12),
                  _buildTabButton('TRAVELLERS', 1, false),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Stories list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trip to Goa
                    _buildTripCard(
                      title: 'Itinerary',
                      host: 'Best Place to vist',
                      date: 'view all',
                      stories: [
                        StoryData(
                          title: 'Discovery of Divar Island',
                          subtitle: '3 hr ago',
                          image: 'assets/images/card1.jpg',
                          isVideo: true,
                        ),
                        StoryData(
                          title: 'Chronicles and Echoes of Divar Island',
                          subtitle: '6 hr ago',
                          image: 'assets/images/card1.jpg',
                        ),
                        StoryData(
                          title: 'Fishing at Aguada',
                          subtitle: '12 hr ago',
                          image: 'assets/images/card1.jpg',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Nandi Hills trip
                    _buildTripCard(
                      title: 'A Day at Nandi Hills, Bangalore',
                      host: 'Hosted by Tanvi',
                      date: 'Mon, 6 Feb',
                      stories: [
                        StoryData(
                          title: 'Tipu\'s Drop',
                          subtitle: '1 day ago',
                          image: 'assets/images/card1.jpg',
                        ),
                        StoryData(
                          title: 'Discovery Village Nandi Foot Hills',
                          subtitle: '1 day ago',
                          image: 'assets/images/card1.jpg',
                        ),
                        StoryData(
                          title: 'Skydiving at Yoga Santosha',
                          subtitle: '1 day ago',
                          image: 'assets/images/card1.jpg',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Ulsoor Lake
                    _buildSingleStory(
                      title: 'Sightseeing Tours to Ulsoor Lake',
                      host: 'Hosted by Prateek',
                      date: 'Mon, 6 Feb',
                    ),

                    const SizedBox(height: 80), // Extra space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green.shade400,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTabButton(String text, int index, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade400 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard({
    required String title,
    required String host,
    required String date,
    required List<StoryData> stories,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trip header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  host,
                  style: TextStyle(fontSize: 14, color: Colors.blue.shade600),
                ),
              ],
            ),
            Text(
              date,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Stories horizontal scroll
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return Container(
                width: 140,
                margin: EdgeInsets.only(
                  right: index < stories.length - 1 ? 12 : 0,
                ),
                child: _buildStoryCard(story),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStoryCard(StoryData story) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image
          Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    image: DecorationImage(
      image: AssetImage(story.image),
      fit: BoxFit.cover,
    ),
  ),
),

          // Content overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),

          // Heart icon
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                color: Colors.grey.shade600,
                size: 16,
              ),
            ),
          ),

          // Video icon
          if (story.isVideo)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),

          // Title and subtitle
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  story.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleStory({
    required String title,
    required String host,
    required String date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  host,
                  style: TextStyle(fontSize: 14, color: Colors.blue.shade600),
                ),
              ],
            ),
            Text(
              date,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', false),
          _buildNavItem(Icons.auto_stories, 'Places', true),
          const SizedBox(width: 30), // Space for FAB
          _buildNavItem(Icons.message, 'Events', false),
          _buildNavItem(Icons.settings, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.green.shade400 : Colors.grey.shade500,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Colors.green.shade400 : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  List<Color> _getGradientColors(String title) {
    if (title.contains('Discovery')) {
      return [Colors.green.shade300, Colors.green.shade600];
    } else if (title.contains('Chronicles')) {
      return [Colors.blue.shade300, Colors.blue.shade600];
    } else if (title.contains('Fishing')) {
      return [Colors.teal.shade300, Colors.teal.shade600];
    } else if (title.contains('Tipu')) {
      return [Colors.orange.shade300, Colors.orange.shade600];
    } else if (title.contains('Village')) {
      return [Colors.purple.shade300, Colors.purple.shade600];
    } else if (title.contains('Skydiving')) {
      return [Colors.indigo.shade300, Colors.indigo.shade600];
    }
    return [Colors.grey.shade300, Colors.grey.shade600];
  }
}

class StoryData {
  final String title;
  final String subtitle;
  final String image;
  final bool isVideo;

  StoryData({
    required this.title,
    required this.subtitle,
    required this.image,
    this.isVideo = false,
  });
}
