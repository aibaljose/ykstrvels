import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ykstravels/package.dart'; // Add this import
import 'view_model/view_model.dart' as view_model;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

//reels
class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class TravelStoriesPage extends StatefulWidget {
  const TravelStoriesPage({super.key});

  @override
  State<TravelStoriesPage> createState() => _TravelStoriesPageState();
}

// itinerary inside cont

class ItineraryStepsPage extends StatefulWidget {
  const ItineraryStepsPage({super.key});

  @override
  State<ItineraryStepsPage> createState() => _ItineraryStepsPageState();
}

class _ItineraryStepsPageState extends State<ItineraryStepsPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Example days with demo activities
  final List<Map<String, dynamic>> days = [
    {
      "title": "Day 1",
      "icon": Icons.looks_one,
      "activities": [
        "Arrival at Airport",
        "Hotel Check-in",
        "Welcome Dinner",
        "Evening City Walk"
      ],
    },
    {
      "title": "Day 2",
      "icon": Icons.looks_two,
      "activities": [
        "Breakfast at Hotel",
        "Visit Local Museum",
        "Lunch at Riverside Café",
        "Boat Ride Experience",
        "Dinner & Rest"
      ],
    },
    {
      "title": "Day 3",
      "icon": Icons.looks_3,
      "activities": [
        "Morning Yoga Session",
        "Mountain Hiking",
        "Picnic Lunch",
        "Photography Tour",
        "Campfire Night"
      ],
    },
    {
      "title": "Day 4",
      "icon": Icons.looks_4,
      "activities": [
        "City Sightseeing",
        "Shopping at Local Market",
        "Lunch with Traditional Food",
        "Relax at Spa",
        "Night Market Visit"
      ],
    },
    {
      "title": "Day 5",
      "icon": Icons.looks_5,
      "activities": [
        "Breakfast & Checkout",
        "Last-minute Shopping",
        "Airport Drop",
        "Flight Departure"
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Itinerary Planner"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // 🔹 Horizontal Stepper Header
          _buildStepperHeader(),

          const SizedBox(height: 20),

          // 🔹 PageView with swipe support
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: days.length,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildDayContent(
                  days[index]["title"] as String,
                  List<String>.from(days[index]["activities"] ?? []), // ✅ SAFE
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Stepper Header (Day1 → Day2 → Day3 → ...)
  Widget _buildStepperHeader() {
    return Row(
      children: List.generate(days.length, (index) {
        final step = days[index];
        final isActive = index <= _currentStep;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index != 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isActive ? Colors.deepPurple : Colors.grey.shade300,
                      ),
                    ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                    isActive ? Colors.deepPurple : Colors.grey.shade200,
                    child: Icon(
                      step["icon"] as IconData,
                      color: isActive ? Colors.white : Colors.grey,
                    ),
                  ),
                  if (index != days.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: (index < _currentStep)
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                step["title"] as String,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.deepPurple : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// 🔹 Day Content (shows activities list)
  Widget _buildDayContent(String dayTitle, List<String> activities) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: activities.isEmpty
                ? const Center(
              child: Text(
                "No activities planned for this day.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                    title: Text(
                      activities[index],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
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

Widget _buildReelsContent() {
  return  ReelsPage();
}

//reel page content
class _ReelsPageState extends State<ReelsPage> {
  final PageController _pageController = PageController();

  // List of YouTube video IDs (not full URLs)
  final List<String> _videoIds = [
    'qJE4yMLyAjA', // Example Shorts video ID
    'lT7aJUr_8x0',
    'anMPE8me6vs', // Another video
  ];

  final List<YoutubePlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var id in _videoIds) {
      final controller = YoutubePlayerController(
        initialVideoId: id,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          loop: true,
          disableDragSeek: true,
          hideControls: false,
        ),
      );
      _controllers.add(controller);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          // Loop endlessly using modulo
          final controller = _controllers[index % _controllers.length];

          return YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
            ),
            builder: (context, player) {
              return Stack(
                children: [
                  Center(child: player),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "@traveler123",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Exploring the hidden gems 🌍✨",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite,
                                  color: Colors.white),
                              onPressed: () {},
                            ),
                            const Text("1.2k",
                                style: TextStyle(color: Colors.white)),
                            const SizedBox(height: 16),
                            IconButton(
                              icon: const Icon(Icons.comment,
                                  color: Colors.white),
                              onPressed: () {},
                            ),
                            const Text("230",
                                style: TextStyle(color: Colors.white)),
                            const SizedBox(height: 16),
                            IconButton(
                              icon:
                              const Icon(Icons.share, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
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

    // Add this to show the trial offer popup after a brief delay
    Future.delayed(Duration(milliseconds: 500), () {
      _showTrialOffer();
    });
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
      ),
    );
  }


  //template itinerary
  Widget _buildItineraryContent() {
    final events = [
      {
        "title": "Heart of Majestic Forests",
        "location": "Norway's",
        "imageUrl": "https://picsum.photos/400/250",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Itinerary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildIteneraryCard(
              context,
              event['title']!,
              event['location']!,
              event['imageUrl']!,
            ),
          );
        },
      ),
    );
  }

// itinerary card design
  Widget _buildIteneraryCard(
      BuildContext context, String title, String location, String imageUrl) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          SizedBox(
            height: 260,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                imageUrl,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay
          Container(
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.65),
                ],
              ),
            ),
          ),
          // Heart icon
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite_border, color: Colors.grey.shade700),
            ),
          ),
          // Card content
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '\$850',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Island paradise with culture, beaches, and adventures all in one.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                // Tags
                Row(
                  children: [
                    _buildTag(Icons.star, '4.8'),
                    const SizedBox(width: 8),
                    _buildTag(null, 'Popular'),
                    const SizedBox(width: 8),
                    _buildTag(null, 'Limited Offer'),
                  ],
                ),
                const SizedBox(height: 16),
                // Plan Your Trip button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: const Text(
                                "Travel Planning",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              centerTitle: true,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                            ),
                            body: _buildPlacesContent(), // 👈 Show the content
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Plan Your Trip',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


// itinerary card design component
  Widget _buildTag(IconData? icon, String label) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
            children: [
              if (icon != null) Icon(icon, color: Colors.white, size: 14),
              if (icon != null) const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            ),
        );
    }




    Widget _buildPageContent() {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildItineraryContent(); // Update this line
      case 2:
        return _buildPlacesContent();
      case 3:
        return _buildEventsContent();
      case 4:
        return _buildReelsContent();
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Show profile content in a modal bottom sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: _buildProfileContent(),
                      ),
                    );
                  });
                },
                child: Container(
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
                  child: _profilePhotoUrl == null
                      ? const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
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
              _buildTabButton('India', 0, selectedTab == 0),
              const SizedBox(width: 12),
              _buildTabButton('Dubai', 1, selectedTab == 1),
              const SizedBox(width: 12),
              _buildTabButton('Japan', 2, selectedTab == 2),
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
    return Stack(
      children: [
        Container(
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
              _buildNavItem(Icons.calendar_today,'Package',_currentNavIndex == 3,3,),
              const SizedBox(width: 60), // Space for FAB
              _buildNavItem(Icons.event, 'Events', _currentNavIndex == 1, 1),
              _buildNavItem(Icons.movie, 'Reels', _currentNavIndex == 4, 4),
            ],
          ),
        ),
        // Floating Search Button
        // Update the Floating Search Button in _buildBottomNavBar
        Positioned(
          left: 0,
          right: 0,
          top: 5,
          child: Center(
            child: FloatingActionButton(
              onPressed: null, // Disable the button
              backgroundColor: Colors.grey.shade400, // Use grey color to indicate disabled state
              child: const Icon(Icons.search, color: Colors.white),
              elevation: 4,
            ),
          ),
        ),
      ],
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
                case 0:
                  _fetchData();
                  break;
                case 1:
                  // Itinerary logic
                  break;
                case 3:
                  // Events logic
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
    final List<ItineraryCardData> placeCards = [
      ItineraryCardData(
        title: 'Before You Fly',
        icon: Icons.flight_takeoff,
        color: Colors.blue.shade600,
        content: [],
      ),
      ItineraryCardData(
        title: 'Things To Know',
        icon: Icons.info_outline,
        color: Colors.indigo.shade400,
        content: [],
      ),
      ItineraryCardData(
        title: 'Itinerary',
        icon: Icons.map_outlined,
        color: Colors.green.shade400,
        content: [],
      ),
      ItineraryCardData(
        title: 'Budget & Tips',
        icon: Icons.account_balance_wallet_outlined,
        color: Colors.orange.shade400,
        content: [],
      ),
      ItineraryCardData(
        title: 'Packing List',
        icon: Icons.luggage_outlined,
        color: Colors.red.shade400,
        content: [],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
        // 🔹 Heading
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Text(
        //     'Travel Planning',
        //     style: const TextStyle(
        //       fontSize: 24,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black87,
        //     ),
        //   ),
        // ),

        // 🔹 Vertical list of cards
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: placeCards.length,
            itemBuilder: (context, index) {
              final card = placeCards[index];
              return GestureDetector(
                onTap: () {
                  if (card.title == "Itinerary") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ItineraryStepsPage(),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: Text(card.title),
                            backgroundColor: card.color,
                            elevation: 0,
                          ),
                          body: Center(
                            child: Text(
                              '${card.title} details go here',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: card.color.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(card.icon, color: card.color, size: 36),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          card.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: card.color,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  // Events tab content
  Widget _buildEventsContent() {
    final events = [
      {
        "title": "Heart of Majestic Forests",
        "location": "Norway's",
        "imageUrl": "https://picsum.photos/400/250",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
      {
        "title": "Sunny Beach Escape",
        "location": "Maldives",
        "imageUrl": "https://picsum.photos/400/251",
      },
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Itinerary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          elevation: 0,
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildEventCard(
                  event['title']!,
                  event['location']!,
                  event['imageUrl']!,
                ),
              );
            },
        ),
    );
  }


  Widget _buildEventCard(String title, String location, String imageUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Text + Button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_outward),
                    onPressed: () {},
                  ),
                ),
              ],
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

  void _showTrialOffer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'First Time Login Offer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Limited Time',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Icon(Icons.card_giftcard, size: 60, color: Colors.amber),
                SizedBox(height: 16),
                Text(
                  '3 Months Free Trial',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$1000',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 20,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'FREE',
                      style: TextStyle(
                        color: Colors.green[300],
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    // Add your activation logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Activate Now',
                    style: TextStyle(
                      color: Color(0xFF4A148C),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add this method to get day-wise plans
  List<List<String>> _getDayPlans(String cardTitle) {
    switch (cardTitle) {
      case 'Itinerary':
        return [
          [
            'Arrive at Kochi Airport - 10:00 AM',
            'Transfer to Hotel - 11:30 AM',
            'Hotel Check-in - 12:30 PM',
            'Lunch at Hotel - 1:30 PM',
            'Visit Tea Gardens - 3:00 PM',
            'Evening Tea Tasting - 5:00 PM',
            'Dinner at Local Restaurant - 8:00 PM',
          ],
          [
            'Breakfast at Hotel - 8:00 AM',
            'Depart for Eravikulam National Park - 9:00 AM',
            'Park Exploration - 10:00 AM',
            'Lunch at Park Restaurant - 1:00 PM',
            'Shopping at Local Market - 3:30 PM',
            'Evening at Hotel - 6:00 PM',
            'Dinner - 8:00 PM',
          ],
          [
            'Breakfast - 8:00 AM',
            'Pack and Check-out - 10:00 AM',
            'Last-minute Shopping - 11:00 AM',
            'Lunch - 1:00 PM',
            'Transfer to Airport - 2:30 PM',
            'Flight Departure - 5:00 PM',
          ],
        ];
      case 'Before You Fly':
        return [
          [
            'Check passport and visa requirements',
            'Book flights and accommodation',
            'Purchase travel insurance',
          ],
          [
            'Pack essential documents',
            'Arrange airport transfer',
            'Online check-in',
          ],
        ];
      // Add more cases for other cards
      default:
        return [
          ['No detailed plan available'],
        ];
    }
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
