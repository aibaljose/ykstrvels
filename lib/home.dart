import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ykstravels/package.dart'; // Add this import
import 'view_model/view_model.dart' as view_model;

class TravelStoriesPage extends StatefulWidget {
  const TravelStoriesPage({super.key});

  @override
  State<TravelStoriesPage> createState() => _TravelStoriesPageState();
}

class _TravelStoriesPageState extends State<TravelStoriesPage> {
  int selectedTab = 0;
  int _currentNavIndex = 0;
  final view_model.ViewModel _viewModel = view_model.ViewModel();
  List<view_model.HomeDataModel> _trips = [];
  bool _isLoading = true;
  String? _profilePhotoUrl;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _loadUserProfile();
  }

  Future<void> _fetchData() async {
    try {
      final trips = await _viewModel.fetchHomeData();
      setState(() {
        _trips = trips;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error loading trips: $e");
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final photoUrl = await _viewModel.getUserPhotoUrl();
      setState(() {
        _profilePhotoUrl = photoUrl;
      });
    } catch (e) {
      print("Error loading user profile: $e");
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Only exit the app if on the home tab
        if (_currentNavIndex == 0) {
          // Exit the app
          SystemNavigator.pop();
          return false;
        }
        // If not on home, go to home tab instead of exiting
        setState(() {
          _currentNavIndex = 0;
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFfdfdfd),
        body: SafeArea(
          child: _isLoading ? _buildLoadingIndicator() : _buildPageContent(),
        ),
        bottomNavigationBar: _buildBottomNavBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color.fromARGB(255, 57, 43, 43),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildPageContent() {
    // Return different content based on current navigation index
    switch (_currentNavIndex) {
      case 0: // Home tab
        return _buildHomeContent();
      case 1: // Places tab
        return _buildPlacesContent();
      case 2: // Events tab
        return _buildEventsContent();
      case 3: // Profile tab
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
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
                child: const Icon(Icons.explore, color: Colors.white, size: 20),
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

              // Profile picture from Google Sign-in
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(20),
                  image: _profilePhotoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(_profilePhotoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                // Show icon as fallback if no profile photo
                child: _profilePhotoUrl == null
                    ? const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ), // Balance the layout
            ],
          ),
        ),
 Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.grey.shade300, // light grey border
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search destination...',
        prefixIcon: Icon(Icons.search, color: Colors.blue.shade400),
        border: InputBorder.none, // remove TextField’s own border
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onChanged: (value) {
        // TODO: Implement search/filter logic
      },
    ),
  ),
),
    const SizedBox(height: 20),
        // Tab selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildTabButton('Kerala', 0, selectedTab == 0),
              const SizedBox(width: 12),
              _buildTabButton('Dubai', 1, selectedTab == 1),
              const SizedBox(width: 12),
              _buildTabButton('Rajasthan', 2, selectedTab == 2),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Search bar
      

        // Stories list
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamic trips from ViewModel
                if (_trips.isEmpty)
                  _buildEmptyState()
                else
                  ..._trips.map((trip) {
                    return Column(
                      children: [
                        _buildTripCard(
                          title: trip.title ?? 'Unnamed Trip',
                          host: trip.host ?? 'Unknown Host',
                          date: trip.date ?? 'No date',
                          stories:
                              trip.stories
                                  ?.map(
                                    (story) => StoryData(
                                      title: story.storyTitle ?? 'No Title',
                                      subtitle:
                                          story.storyContent ?? 'No Content',
                                      image: story.imageUrl ?? '',
                                      isNetworkImage:
                                          story.imageUrl != null &&
                                          story.imageUrl!.isNotEmpty,
                                      description: story.description ?? '',
                                      location:
                                          story.location ??
                                          '', // <-- Pass location from ViewModel
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }),

                const SizedBox(height: 80), // Extra space for bottom nav
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String text, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildTripCard({
    required String title,
    required String host,
    required String date,
    required List<StoryData> stories,
  }) {
    return GestureDetector(
      onTap: () {
        // Use first story for details, or fallback if none
        final story = stories.isNotEmpty
            ? stories[0]
            : StoryData(
                title: 'No Title',
                subtitle: 'No Content',
                image:
                    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
                isNetworkImage: true,
              );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackageDetailPage(
              imageUrl: story.image,
              title: title,
              location: host,
              price: 154, // You can add price to your model for dynamic value
              rating: 5.0, // Add rating to your model for dynamic value
              reviews: 12, // Add reviews to your model for dynamic value
              description: story.subtitle, // Use story content as description
            ),
          ),
        );
      },
      child: Column(
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
      ),
    );
  }

  Widget _buildStoryCard(StoryData story) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackageDetailPage(
              imageUrl: story.image,
              title: story.title,
              location: story.location, // You can pass trip.host if needed
              price: 154,
              rating: 5.0,
              reviews: 12,
              description: story.description, // Use content instead of subtitle
            ),
          ),
        );
      },
      child: Container(
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
                  image: _getImageProvider(story),
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
      ),
    );
  }

  // Removed unused _buildSingleStory method

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
          _buildNavItem(Icons.home, 'Home', _currentNavIndex == 0, 0),
          _buildNavItem(Icons.auto_stories, 'Places', _currentNavIndex == 1, 1),
          const SizedBox(width: 30), // Space for FAB
          _buildNavItem(Icons.message, 'Events', _currentNavIndex == 2, 2),
          _buildNavItem(Icons.settings, 'Profile', _currentNavIndex == 3, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });

        // Handle navigation actions based on index
        switch (index) {
          case 0: // Home
            // Already on home, just refresh data if needed
            _fetchData();
            break;
          case 1: // Places
            // Navigate to Itinerary page
            Navigator.pushNamed(context, '/itinerary');
            break;
          case 2: // Events
            // Events view functionality
            break;
          case 3: // Profile
            // Profile view functionality
            break;
        }
      },
      child: Column(
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
      ),
    );
  }

  // Removed unused _getGradientColors method

  ImageProvider _getImageProvider(StoryData story) {
    if (story.isNetworkImage && story.image.isNotEmpty) {
      try {
        // Use network image with error handling
        return NetworkImage(story.image);
      } catch (e) {
        print("Error loading network image: $e");
        // Fallback to default placeholder image on error
        return const AssetImage('assets/images/card1.jpg');
      }
    } else if (story.image.isNotEmpty) {
      // Use asset image if provided
      return AssetImage(story.image);
    } else {
      // Fallback to default placeholder image
      return const AssetImage('assets/images/card1.jpg');
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.travel_explore, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No trips available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your travel stories will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Places tab content
  Widget _buildPlacesContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 80, color: Colors.green.shade300),
          const SizedBox(height: 16),
          Text(
            'Places',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Discover amazing travel destinations',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  // Events tab content
  Widget _buildEventsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event, size: 80, color: Colors.blue.shade300),
          const SizedBox(height: 16),
          Text(
            'Events',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Upcoming travel events and activities',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  // Profile tab content
  Widget _buildProfileContent() {
    return Column(
      children: [
        const SizedBox(height: 40),
        // Profile picture
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
            border: Border.all(color: Colors.white, width: 4),
            image: _profilePhotoUrl != null
                ? DecorationImage(
                    image: NetworkImage(_profilePhotoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _profilePhotoUrl == null
              ? Icon(Icons.person, size: 60, color: Colors.grey.shade600)
              : null,
        ),
        const SizedBox(height: 16),
        const Text(
          'My Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        // Profile options
        _buildProfileOption(Icons.person_outline, 'Personal Information'),
        _buildProfileOption(Icons.history, 'Travel History'),
        _buildProfileOption(Icons.favorite_border, 'Saved Places'),
        _buildProfileOption(Icons.settings, 'Settings'),
        _buildProfileOption(Icons.help_outline, 'Help & Support'),
        const SizedBox(height: 16),
        // Logout button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButton(
            onPressed: () async {
              await _viewModel.logoutUser();
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
            child: const Text('Logout'),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          // Handle option tap
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue.shade700),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryData {
  final String title;
  final String subtitle;
  final String image;
  final bool isNetworkImage;
  final bool isVideo;
  final String description;
  final String location;

  StoryData({
    required this.title,
    required this.subtitle,
    required this.image,
    this.isNetworkImage = false,
    this.isVideo = false,
    this.description = '',
    this.location = '',
  });
}
