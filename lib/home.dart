import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yksworld/package.dart'; // Add this import
import 'view_model/view_model.dart' as view_model;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:lottie/lottie.dart';
import 'package:yksworld/view_model/itinerary_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yksworld/view_model/package_model.dart';
import 'itinerary.dart';

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
  final Itinerary? itinerary;
  const ItineraryStepsPage({super.key, this.itinerary});

  @override
  State<ItineraryStepsPage> createState() => _ItineraryStepsPageState();
}

//Loading animation
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const LoadingScreen());
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true; // Simulates loading state

  @override
  void initState() {
    super.initState();
    // Simulate a loading process (e.g., fetching data)
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false; // Stop loading after 5 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lottie Loading Animation')),
      body: Center(
        child: _isLoading
            ? Lottie.asset(
                'assets/image/animations/Travel.json', // Path to your Lottie file
                width: 200,
                height: 200,
                fit: BoxFit.fill,
              )
            : const Text('Loading Complete!'),
      ),
    );
  }
}

class _ItineraryStepsPageState extends State<ItineraryStepsPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _currentStep = 0;
  }

  @override
  Widget build(BuildContext context) {
    // Use the passed itinerary or fall back to first itinerary from global list
    final itinerary = widget.itinerary;
    if (itinerary == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Itinerary Planner"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(child: Text("No itinerary data available")),
      );
    }

    final days = itinerary.days;
    return Scaffold(
      appBar: AppBar(
        title: Text(itinerary.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildStepperHeaderFixed(days),
          const SizedBox(height: 20),
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
                final day = days[index];
                return _buildDayContentFixed(day);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperHeaderFixed(List<Day> days) {
    return Row(
      children: List.generate(days.length, (index) {
        final day = days[index];
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
                        color: isActive
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                      ),
                    ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isActive
                        ? Colors.deepPurple
                        : Colors.grey.shade200,
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
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
                'Day ${day.day}',
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

  Widget _buildDayContentFixed(Day day) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day ${day.day}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: day.activities.isEmpty
                ? const Center(
                    child: Text(
                      "No activities planned for this day.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: day.activities.length,
                    itemBuilder: (context, index) {
                      final activity = day.activities[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            child: Icon(
                              _getActivityIcon(activity.icon),
                              color: Colors.deepPurple,
                            ),
                          ),
                          title: Text(
                            activity.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (activity.time.isNotEmpty)
                                Text(
                                  'Time: ${activity.time}',
                                  style: TextStyle(
                                    color: Colors.blue.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              Text(
                                activity.description,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
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

  IconData _getActivityIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'coffee':
        return Icons.local_cafe;
      case 'landmark':
        return Icons.account_balance;
      case 'food':
        return Icons.restaurant;
      case 'hotel':
        return Icons.hotel;
      case 'transport':
        return Icons.directions_car;
      default:
        return Icons.event;
    }
  }
}

Widget _buildReelsContent() {
  return const ReelsPage();
}

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
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            const Text(
                              "1.2k",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            IconButton(
                              icon: const Icon(
                                Icons.comment,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            const Text(
                              "230",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
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
  List<Itinerary> _itineraries = [];
  bool _isLoading = true;
  String? _profilePhotoUrl;
  List<Package> _packages = [];
  final bool _useMockData = true; // Set to false when API is ready
  List<Package> _favoritePackages = [];
  bool _isLoadingFavorites = false;
  String? userToken;
  List<Itinerary> _favoriteItineraries = [];
  bool _isLoadingFavoriteItineraries = false;

  @override
  void initState() {
    super.initState();
    _fetchData(); // This loads itineraries AND favorites

    // Toggle between mock and real API
    // if (_useMockData) {
    //   _loadMockPackages();
    //   _loadFavoritePackages(); // For packages
    // } else {
      _fetchPackages();
      _fetchFavoritePackages();
    // }

    // Remove the delayed call since _fetchData now handles it
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   _loadFavoriteItineraries();
    // });

    _loadUserProfile();
    Future.delayed(const Duration(seconds: 3), () {
      _showTrialOffer();
    });
  }

  //dynamic card
  //mini card packages
  void _loadFavoritePackages() {
    if (_packages.isEmpty) {
      setState(() => _favoritePackages = []);
      return;
    }

    setState(() {
      // Only show packages explicitly marked as favorites
      _favoritePackages = _packages
          .where((p) => p.isFavorite)
          .take(4) // Still limit to 4 max
          .toList();
    });

    // If no favorites, show empty state
    print(
      'Loaded ${_favoritePackages.length} favorite packages for home screen',
    );
  }

  //optional fav mini package
  Future<void> _fetchFavoritePackages() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://ykstrip.in/user/getfavoritepackages'),
            // Add headers if you need authentication
            headers: {
              'Authorization': 'Bearer YOUR_TOKEN', // if needed
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Connection timeout');
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          final List<dynamic> jsonData = jsonResponse['data'];

          final List<Package> loadedFavorites = jsonData
              .map((item) {
                try {
                  return Package.fromJson(item as Map<String, dynamic>);
                } catch (e) {
                  print('Error parsing favorite package: $e');
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<Package>()
              .toList();

          if (mounted) {
            setState(() {
              // Take only first 4
              _favoritePackages = loadedFavorites.take(4).toList();
            });
          }

          print(
            'Loaded ${_favoritePackages.length} favorite packages from API',
          );
        }
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      // Fallback to loading from all packages
      _loadFavoritePackages();
    }
  }

  // Add this helper method for error handling
  void _handleApiError(String message) {
    print(message);
    if (mounted) {
      setState(() => _isLoadingFavorites = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // fav itinerary card home
  // Add this method to _TravelStoriesPageState
  void _loadFavoriteItineraries() {
    print(
      'Loading favorite itineraries. Total itineraries: ${_itineraries.length}',
    );

    if (_itineraries.isEmpty) {
      setState(() => _favoriteItineraries = []);
      print('No itineraries found, setting empty favorites list');
      return;
    }

    setState(() {
      // Get explicitly favorited itineraries
      List<Itinerary> favorites = _itineraries
          .where((i) => i.isFavorite)
          .toList();
      print('Found ${favorites.length} explicitly favorited itineraries');

      // If no favorites or less than 2, use highest rated itineraries as fallback
      if (favorites.isEmpty || favorites.length < 2) {
        print('Using fallback: selecting top-rated itineraries');

        // Sort by rating (highest first), then by days count
        List<Itinerary> sortedItineraries = List.from(_itineraries);
        sortedItineraries.sort((a, b) {
          // First compare by rating
          int ratingComparison = b.rating.compareTo(a.rating);
          if (ratingComparison != 0) return ratingComparison;

          // If ratings are equal, compare by number of days
          int aDays = a.days?.length ?? 0;
          int bDays = b.days?.length ?? 0;
          return bDays.compareTo(aDays);
        });

        favorites = sortedItineraries.take(4).toList();
        print('Selected ${favorites.length} top-rated itineraries as fallback');

        // Debug: print details of selected itineraries
        for (var itinerary in favorites) {
          print(
            'Selected: ${itinerary.destination} - Rating: ${itinerary.rating}, Days: ${itinerary.days.length}',
          );
        }
      }

      // Ensure we show maximum 4 itineraries
      _favoriteItineraries = favorites.take(4).toList();
    });

    print('Final favorite itineraries count: ${_favoriteItineraries.length}');
  }

  //mock data
  void _loadMockPackages() {
    final mockPackagesJson = [
      {
        "id": 1,
        "package_name": "Kerala Backwaters Adventure",
        "package_description":
            "Experience the serene beauty of Kerala's famous backwaters",
        "package_price": "15000",
        "overview": "Discover the tranquil backwaters...",
        "highlight": "Luxury houseboat stay, Kathakali performance",
        "no_of_days": "3",
        "locations": "Alleppey, Kumarakom",
        "discount_price": "12000",
        "accommodation": "Premium houseboat + 3-star resort",
        "meals": "All meals included",
        "transportation": "Private AC vehicle",
        "image":
            "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800",
        "is_favorite": true, // Marked as favorite
      },
      {
        "id": 2,
        "package_name": "Munnar Hill Station Escape",
        "package_description": "Explore the misty tea plantations",
        "package_price": "18000",
        "overview": "Immerse yourself in breathtaking landscapes...",
        "highlight": "Tea plantation tour, Wildlife safari",
        "no_of_days": "4",
        "locations": "Munnar, Thekkady",
        "discount_price": "15500",
        "accommodation": "4-star hill resort",
        "meals": "Breakfast and Dinner",
        "transportation": "Private SUV",
        "image":
            "https://images.unsplash.com/photo-1598970434795-0c54fe7c0648?w=800",
        "is_favorite": true, // Marked as favorite
      },
      {
        "id": 3,
        "package_name": "Goa Beach Paradise",
        "package_description": "Sun, sand, and sea",
        "package_price": "22000",
        "overview": "Relax on pristine beaches...",
        "highlight": "Beach activities, Water sports",
        "no_of_days": "5",
        "locations": "North Goa, South Goa",
        "discount_price": null,
        "accommodation": "Beach resort with pool",
        "meals": "Breakfast included",
        "transportation": "Bike rental + Airport transfers",
        "image":
            "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800",
        "is_favorite": false, // Not marked as favorite
      },
      {
        "id": 4,
        "package_name": "Rajasthan Royal Heritage",
        "package_description": "Experience the grandeur of palaces",
        "package_price": "35000",
        "overview": "Journey through the land of kings...",
        "highlight": "Palace hotels, Camel safari",
        "no_of_days": "7",
        "locations": "Jaipur, Udaipur, Jodhpur",
        "discount_price": "29000",
        "accommodation": "Heritage hotels",
        "meals": "Breakfast and traditional dinners",
        "transportation": "Private car with driver",
        "image":
            "https://images.unsplash.com/photo-1599661046289-e31897846e41?w=800",
        "is_favorite": true, // Marked as favorite
      },
      {
        "id": 5,
        "package_name": "Manali Adventure Trek",
        "package_description": "Thrilling mountain adventure",
        "package_price": "25000",
        "overview": "Perfect for adventure enthusiasts...",
        "highlight": "Trekking, Paragliding, River rafting",
        "no_of_days": "6",
        "locations": "Manali, Solang Valley",
        "discount_price": "21000",
        "accommodation": "Mountain camps + Hotel",
        "meals": "All meals included",
        "transportation": "Volvo bus + Local jeep",
        "image":
            "https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=800",
        "is_favorite": false, // Not marked as favorite
      },
      {
        "id": 6,
        "package_name": "Andaman Island Exploration",
        "package_description": "Crystal clear waters and pristine beaches",
        "package_price": "42000",
        "overview": "Discover the stunning marine life...",
        "highlight": "Scuba diving, Beach camping, Boat safari",
        "no_of_days": "6",
        "locations": "Port Blair, Havelock, Neil Island",
        "discount_price": "38000",
        "accommodation": "Beach resorts and eco cottages",
        "meals": "All meals included",
        "transportation": "Ferry transfers + Local vehicles",
        "image":
            "https://images.unsplash.com/photo-1586500036706-41963de24d8b?w=800",
        "is_favorite": true, // Marked as favorite
      },
    ];

    final List<Package> mockPackages = mockPackagesJson
        .map((json) => Package.fromJson(json))
        .toList();

    setState(() {
      _packages = mockPackages;
      _isLoading = false;
    });

    // Load favorites after mock data is set
    _loadFavoritePackages();

    print('Loaded ${_packages.length} mock packages');
  }

  //to refresh the fav packages
  Future<void> _refreshHomeData() async {
    await _fetchPackages();
    // Favorites will be loaded automatically after packages load
  }

  // ...existing code...

  Future<void> _fetchPackages() async {
    try {
      final response = await http
          .get(Uri.parse('https://ykstrip.in/user/getpackages'))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Connection timeout');
            },
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          final List<dynamic> jsonData =
              jsonResponse['packages']; // Note: 'packages' instead of 'data'

          final List<Package> loadedPackages = jsonData
              .map((item) {
                try {
                  return Package.fromJson(item as Map<String, dynamic>);
                } catch (e) {
                  print('Error parsing package: $e');
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<Package>()
              .toList();

          if (mounted) {
            setState(() {
              _packages = loadedPackages;
            });

            // Load favorites after packages are loaded
            _loadFavoritePackages();
          }

          print('Total packages loaded: ${_packages.length}');
        } else {
          print('API returned failure status: ${jsonResponse['message']}');
        }
      } else {
        print('Failed to fetch packages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _fetchPackages: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading packages: $e')));
      }
    }
  }

  // Fetch itineraries from API

  Future<void> _fetchData() async {
    print('Starting to fetch itineraries...');
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://ykstrip.in/user/getdata'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          final List<dynamic> jsonData = jsonResponse['data'];

          final List<Itinerary> loadedItineraries = jsonData
              .map((item) {
                try {
                  return Itinerary.fromJson(item as Map<String, dynamic>);
                } catch (e) {
                  print('Error parsing itinerary item: $e');
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<Itinerary>()
              .toList();

          if (mounted) {
            setState(() {
              _itineraries = loadedItineraries;
              _isLoading = false;
            });

            // Load favorite itineraries immediately after itineraries are loaded
            print('Itineraries loaded, now loading favorites...');
            _loadFavoriteItineraries();
          }

          print('Total itineraries loaded: ${_itineraries.length}');
        } else {
          print('API returned failure status: ${jsonResponse['message']}');
          setState(() => _isLoading = false);
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error in _fetchData: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Travel Itineraries',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _itineraries.isEmpty
          ? _buildEmptyItineraryState() // Updated method name
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _itineraries.length,
              itemBuilder: (context, index) {
                final itinerary = _itineraries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildDynamicItineraryCard(itinerary),
                );
              },
            ),
    );
  }

  // Add this new method specifically for itinerary empty state
  Widget _buildEmptyItineraryState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No itineraries available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Travel itineraries will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Trigger a refresh of the data
              _fetchData();
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  // itinerary card design
  Widget _buildIteneraryCard(
    BuildContext context,
    String title,
    String location,
    String imageUrl,
  ) {
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
          // Positioned(
          //   top: 16,
          //   right: 16,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.7),
          //       shape: BoxShape.circle,
          //     ),
          //     child: Icon(Icons.favorite_border, color: Colors.grey.shade700),
          //   ),
          // ),
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

  // Package Card Design Updated Dynamic
  Widget _buildDynamicPackageCard(Package package) {
    // Use package image or fallback to placeholder
    final imageUrl = package.image ?? 'https://picsum.photos/400/250';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DynamicPackageDetailPage(
                package: package,
                onFavoriteToggled: (isFavorite) {
                  setState(() {
                    // Find and update the package in the main list
                    final index = _packages.indexWhere(
                      (p) => p.id == package.id,
                    );
                    if (index >= 0) {
                      _packages[index].isFavorite = isFavorite;
                    }

                    // Also update the package object directly
                    package.isFavorite = isFavorite;

                    // Reload favorites list to refresh home screen
                    _loadFavoritePackages();
                  });

                  print(
                    'Updated favorites list. New count: ${_favoritePackages.length}',
                  );
                },
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
                // Discount Badge
                if (package.hasDiscount)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${((1 - package.discountPriceValue / package.priceValue) * 100).toInt()}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                // Days Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${package.daysCount} Days',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    package.packageName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          package.locations,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Highlights
                  if (package.highlight.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              package.highlight,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Features Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFeatureChip(Icons.hotel, package.accommodation),
                      _buildFeatureChip(Icons.restaurant, package.meals),
                      _buildFeatureChip(
                        Icons.directions_car,
                        package.transportation,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price and Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (package.hasDiscount)
                            Text(
                              '₹${package.packagePrice}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            '₹${package.hasDiscount ? package.discountPrice : package.packagePrice}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            'per person',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      // View Details Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DynamicPackageDetailPage(
                                package: package,
                                onFavoriteToggled: (isFavorite) {
                                  setState(() {
                                    final index = _packages.indexWhere(
                                      (p) => p.id == package.id,
                                    );
                                    if (index >= 0) {
                                      _packages[index].isFavorite = isFavorite;
                                    }
                                    package.isFavorite = isFavorite;
                                    _loadFavoritePackages();
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for feature chips
  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
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
        return _buildPackagesContent();
      case 4:
        return _buildReelsContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _refreshHomeData,
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
                  'YKS Trips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                // Profile picture
                GestureDetector(
                  onTap: () {
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
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
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
                  border: InputBorder.none,
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

          // Horizontal scrollable demo packages Dynamic mini package card updated
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Header with "See All"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Packages',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentNavIndex = 3; // Navigate to packages tab
                          });
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Horizontal Package Cards
                  // Update the horizontal package card section in _buildHomeContent()
                  // Horizontal Package Cards New one
                  _isLoadingFavorites
                      ? Container(
                          height: 220,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )
                      : _favoritePackages.isEmpty
                      ? Container(
                          height: 220,
                          alignment: Alignment.center,
                          child: Text(
                            'No featured packages available',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 220,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _favoritePackages.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final package = _favoritePackages[index];
                              return _buildMiniPackageCard(package);
                            },
                          ),
                        ),

                  // Add this section in your _buildHomeContent() method, after the package mini cards section
                  // Mini Itinerary Cards Section
                  // In your _buildHomeContent() method, make sure this section exists:
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Itineraries',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentNavIndex = 1; // Navigate to itineraries tab
                          });
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Horizontal Itinerary Cards
                  _isLoadingFavoriteItineraries
                      ? Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        )
                      : _favoriteItineraries.isEmpty
                      ? Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Text(
                            'No featured itineraries available',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _favoriteItineraries.length,
                            itemBuilder: (context, index) {
                              final itinerary = _favoriteItineraries[index];
                              return _buildMiniItineraryCard(itinerary);
                            },
                          ),
                        ),

                  const SizedBox(height: 24),

                  const Text(
                    'Top Destinations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) => Container(
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 40,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Destination ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '5 Days / 4 Nights',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
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
              _buildNavItem(
                Icons.calendar_today,
                'Package',
                _currentNavIndex == 3,
                3,
              ),
              const SizedBox(width: 60), // Space for FAB
              _buildNavItem(Icons.event, 'Itinerary', _currentNavIndex == 1, 1),
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
              backgroundColor: Colors.grey.shade400,
              elevation: 4, // Use grey color to indicate disabled state
              child: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // Mini Itinerary Card
  // Add this method to _TravelStoriesPageState
  // ...existing code...

  Widget _buildMiniItineraryCard(Itinerary itinerary) {
    final int totalDays = itinerary.days.length;

    return Container(
      width: 280,
      height: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DynamicItineraryStepsPage(itinerary: itinerary),
              ),
            );
          },
          child: Stack(
            children: [
              // Background Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  itinerary.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue.shade400, Colors.blue.shade700],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Destination
                    Text(
                      itinerary.destination,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Description
                    Text(
                      itinerary.desc.length > 60
                          ? '${itinerary.desc.substring(0, 60)}...'
                          : itinerary.desc,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Tags Row
                    Row(
                      children: [
                        if (itinerary.rating > 0) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${itinerary.rating}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$totalDays Days',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite Button (top right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      itinerary.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: itinerary.isFavorite ? Colors.red : Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        itinerary.isFavorite = !itinerary.isFavorite;
                        _loadFavoriteItineraries();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            itinerary.isFavorite
                                ? 'Added to favorites'
                                : 'Removed from favorites',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Mini packages card widget
  // ...existing code...

  Widget _buildMiniPackageCard(Package package) {
    final imageUrl = package.image ?? 'https://picsum.photos/200/180';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DynamicPackageDetailPage(
              package: package,
              onFavoriteToggled: (isFavorite) {
                setState(() {
                  // Find and update the package in the main list
                  final index = _packages.indexWhere((p) => p.id == package.id);
                  if (index >= 0) {
                    _packages[index].isFavorite = isFavorite;
                  }

                  // Also update the package object directly
                  package.isFavorite = isFavorite;

                  // Reload favorites list to refresh home screen
                  _loadFavoritePackages();
                });

                print(
                  'Updated favorites list. New count: ${_favoritePackages.length}',
                );
              },
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Image.network(
                imageUrl,
                height: 220,
                width: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
                    width: 180,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[500],
                    ),
                  );
                },
              ),

              // Gradient Overlay
              Container(
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),

              // Days Badge (Top Right)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${package.daysCountInt}D',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Trending Badge (Top Left) - if applicable
              if (package.isTrending)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade600,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'TRENDING',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Discount Badge (Top Left) - if applicable and not trending
              if (package.hasDiscount && !package.isTrending)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${((1 - package.discountPriceValue / package.priceValue) * 100).toInt()}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // Package Title and Price (Bottom)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Package Name
                      Text(
                        package.packageName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              package.locations,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Price
                      Row(
                        children: [
                          if (package.hasDiscount)
                            Text(
                              '₹${package.packagePrice}',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          if (package.hasDiscount) const SizedBox(width: 6),
                          Text(
                            '₹${package.hasDiscount ? package.discountPrice : package.packagePrice}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // "View Details" overlay on tap hint
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.blue.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
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
    // Get the first itinerary for dynamic data, or use default

    final itinerary = _itineraries.isNotEmpty ? _itineraries.first : null;

    final List<ItineraryCardData> placeCards = [
      ItineraryCardData(
        title: 'Before You Fly',
        icon: Icons.flight_takeoff,
        color: Colors.blue.shade600,
        content:
            itinerary?.beforeYouFly.entries
                .map((e) => '${e.key}: ${e.value}')
                .toList() ??
            ['Check passport validity', 'Book flights', 'Travel insurance'],
      ),
      ItineraryCardData(
        title: 'Things To Know',
        icon: Icons.info_outline,
        color: Colors.indigo.shade400,
        content:
            itinerary?.thingsToKnow.entries
                .map((e) => '${e.key}: ${e.value}')
                .toList() ??
            ['Local customs', 'Currency info', 'Weather conditions'],
      ),
      ItineraryCardData(
        title: 'Itinerary',
        icon: Icons.map_outlined,
        color: Colors.green.shade400,
        content:
            itinerary?.days
                .map((d) => 'Day ${d.day}: ${d.activities.length} activities')
                .toList() ??
            ['Day 1: Arrival', 'Day 2: Sightseeing', 'Day 3: Departure'],
      ),
      ItineraryCardData(
        title: 'Budget & Tips',
        icon: Icons.account_balance_wallet_outlined,
        color: Colors.orange.shade400,
        content: itinerary != null
            ? [
                'Total Budget: ${itinerary.budget.total}',
                ...itinerary.budget.breakdown.entries.map(
                  (e) => '${e.key}: ${e.value}',
                ),
              ]
            : [
                'Total Budget: ${1000}',
                'Accommodation: ${400}',
                'Food: ${300}',
                'Activities: ${300}',
              ],
      ),
      ItineraryCardData(
        title: 'Packing List',
        icon: Icons.luggage_outlined,
        color: Colors.red.shade400,
        content: itinerary != null
            ? [
                ...itinerary.packingList.essentials.map(
                  (item) => 'Essential: $item',
                ),
                ...itinerary.packingList.clothing.map(
                  (item) => 'Clothing: $item',
                ),
                ...itinerary.packingList.extras.map((item) => 'Extra: $item'),
              ]
            : ['Clothes', 'Documents', 'Electronics', 'Medicines'],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // Planning cards
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
                        builder: (context) =>
                            ItineraryStepsPage(itinerary: itinerary),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailContentPage(
                          title: card.title,
                          content: card.content,
                          color: card.color,
                          icon: card.icon,
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
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
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
  Widget _buildPackagesContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Travel Packages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _packages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_travel,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No packages available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                final package = _packages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildDynamicPackageCard(package),
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

  Widget _buildDynamicItineraryCard(Itinerary itinerary) {
    // Calculate total days
    final totalDays = itinerary.days.length;

    // Get a sample activity for preview
    final sampleActivity =
        itinerary.days.isNotEmpty && itinerary.days[0].activities.isNotEmpty
        ? itinerary.days[0].activities[0].title
        : 'Explore amazing destinations';

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
                itinerary.image,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
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
          // Positioned(
          //   top: 16,
          //   right: 16,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.7),
          //       shape: BoxShape.circle,
          //     ),
          //     child: IconButton(
          //       icon: Icon(Icons.favorite_border, color: Colors.grey.shade700),
          //       onPressed: () {
          //         // TODO: Implement favorite functionality
          //       },
          //     ),
          //   ),
          // ),
          // Rating badge
          if (itinerary.rating > 0)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      itinerary.rating.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
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
                // Title and duration
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        itinerary.title,
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
                      child: Text(
                        '${totalDays}D',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Destination
                Text(
                  itinerary.destination,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                // Description
                Text(
                  itinerary.desc.length > 100
                      ? '${itinerary.desc.substring(0, 100)}...'
                      : itinerary.desc,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                // Tags
                Row(
                  children: [
                    if (itinerary.rating > 0)
                      _buildTag(Icons.star, '${itinerary.rating}.0'),
                    if (itinerary.rating > 0) const SizedBox(width: 8),
                    _buildTag(null, '${totalDays} Days'),
                    const SizedBox(width: 8),
                    if (totalDays >= 3) _buildTag(null, 'Complete Package'),
                  ],
                ),
                const SizedBox(height: 16),
                // Plan Your Trip button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(142, 255, 255, 255),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // Navigate to itinerary steps page instead of package detail
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DynamicItineraryStepsPage(itinerary: itinerary),
                        ),
                      );
                    },
                    child: const Text(
                      'Plan Your Trip',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
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

// itinerary Dynamic changes

class DynamicTravelPlanningPage extends StatefulWidget {
  final Itinerary itinerary;

  const DynamicTravelPlanningPage({super.key, required this.itinerary});

  @override
  State<DynamicTravelPlanningPage> createState() =>
      _DynamicTravelPlanningPageState();
}

class _DynamicTravelPlanningPageState extends State<DynamicTravelPlanningPage> {
  @override
  Widget build(BuildContext context) {
    final List<ItineraryCardData> planningCards = [
      ItineraryCardData(
        title: 'Before You Fly',
        icon: Icons.flight_takeoff,
        color: Colors.blue.shade600,
        content: widget.itinerary.beforeYouFly.entries
            .map((e) => '${e.key}: ${e.value}')
            .toList(),
      ),
      ItineraryCardData(
        title: 'Things To Know',
        icon: Icons.info_outline,
        color: Colors.indigo.shade400,
        content: widget.itinerary.thingsToKnow.entries
            .map((e) => '${e.key}: ${e.value}')
            .toList(),
      ),
      ItineraryCardData(
        title: 'Itinerary',
        icon: Icons.map_outlined,
        color: Colors.green.shade400,
        content: widget.itinerary.days
            .map((d) => 'Day ${d.day}: ${d.activities.length} activities')
            .toList(),
      ),
      ItineraryCardData(
        title: 'Budget & Tips',
        icon: Icons.account_balance_wallet_outlined,
        color: Colors.orange.shade400,
        content: [
          'Total Budget: ${widget.itinerary.budget.total}',
          ...widget.itinerary.budget.breakdown.entries.map(
            (e) => '${e.key}: ${e.value}',
          ),
        ],
      ),
      ItineraryCardData(
        title: 'Packing List',
        icon: Icons.luggage_outlined,
        color: Colors.red.shade400,
        content: [
          ...widget.itinerary.packingList.essentials.map(
            (item) => 'Essential: $item',
          ),
          ...widget.itinerary.packingList.clothing.map(
            (item) => 'Clothing: $item',
          ),
          ...widget.itinerary.packingList.extras.map((item) => 'Extra: $item'),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itinerary.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.itinerary.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.itinerary.destination,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.itinerary.days.length} Days Journey',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Planning cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: planningCards.length,
              itemBuilder: (context, index) {
                final card = planningCards[index];
                return GestureDetector(
                  onTap: () {
                    if (card.title == "Itinerary") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DynamicItineraryStepsPage(
                            itinerary: widget.itinerary,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailContentPage(
                            title: card.title,
                            content: card.content,
                            color: card.color,
                            icon: card.icon,
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: card.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(card.icon, color: card.color, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: card.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${card.content.length} items',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                      ],
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

class DynamicItineraryStepsPage extends StatefulWidget {
  final Itinerary itinerary;

  const DynamicItineraryStepsPage({super.key, required this.itinerary});

  @override
  State<DynamicItineraryStepsPage> createState() =>
      _DynamicItineraryStepsPageState();
}

class _DynamicItineraryStepsPageState extends State<DynamicItineraryStepsPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  IconData _getIconForActivity(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'coffee':
        return Icons.local_cafe;
      case 'landmark':
        return Icons.account_balance;
      case 'food':
        return Icons.restaurant;
      case 'hotel':
        return Icons.hotel;
      case 'transport':
        return Icons.directions_car;
      case 'activity':
        return Icons.local_activity;
      case 'shopping':
        return Icons.shopping_bag;
      case 'sightseeing':
        return Icons.camera_alt;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = widget.itinerary.days;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itinerary.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildStepperHeader(days),
          const SizedBox(height: 20),
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
                final day = days[index];
                return _buildDayContent(day);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperHeader(List<Day> days) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isActive = index <= _currentStep;
          final isCurrent = index == _currentStep;

          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 8),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? Colors.deepPurple
                          : isActive
                          ? Colors.deepPurple.shade300
                          : Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: isCurrent
                          ? Border.all(color: Colors.deepPurple, width: 3)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Day ${day.day}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCurrent
                          ? Colors.deepPurple
                          : isActive
                          ? Colors.deepPurple.shade300
                          : Colors.grey,
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

  Widget _buildDayContent(Day day) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day ${day.day}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${day.activities.length} activities planned',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: day.activities.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No activities planned for this day",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: day.activities.length,
                    itemBuilder: (context, index) {
                      final activity = day.activities[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getIconForActivity(activity.icon),
                              color: Colors.deepPurple,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            activity.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              if (activity.time.isNotEmpty)
                                Text(
                                  'Time: ${activity.time}',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                activity.description,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
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

//Package Card Essential Class Updated new
class DynamicPackageDetailPage extends StatefulWidget {
  final Package package;
  final Function(bool)? onFavoriteToggled; // Add this callback parameter

  const DynamicPackageDetailPage({
    super.key,
    required this.package,
    this.onFavoriteToggled,
  });

  @override
  State<DynamicPackageDetailPage> createState() =>
      _DynamicPackageDetailPageState();
}

class _DynamicPackageDetailPageState extends State<DynamicPackageDetailPage> {
  // Track favorite status in state instead of modifying the package
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    // Initialize with the package's current favorite status
    _isFavorite = widget.package.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.package.image ?? 'https://picsum.photos/400/300';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  widget.package.isFavorite = _isFavorite;
                  if (widget.onFavoriteToggled != null) {
                    widget.onFavoriteToggled!(_isFavorite);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite
                            ? 'Added to favorites!'
                            : 'Removed from favorites!',
                      ),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.package.packageName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                ),
              ),
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey[300]);
                },
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Section
                  Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.package.hasDiscount)
                                Text(
                                  '₹${widget.package.packagePrice}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              Text(
                                '₹${widget.package.hasDiscount ? widget.package.discountPrice : widget.package.packagePrice}',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                              Text(
                                'per person',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          if (widget.package.hasDiscount)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'SAVE ₹${(widget.package.priceValue - widget.package.discountPriceValue).toInt()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Overview
                  _buildSection(
                    'Overview',
                    widget.package.overview,
                    Icons.info_outline,
                  ),

                  // Highlights
                  _buildSection(
                    'Highlights',
                    widget.package.highlight,
                    Icons.star_border,
                  ),

                  // Details
                  const Text(
                    'Package Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  _buildDetailTile(
                    Icons.calendar_today,
                    'Duration',
                    '${widget.package.daysCount} Days', // Changed from noOfDays to daysCount
                  ),
                  _buildDetailTile(
                    Icons.location_on,
                    'Locations',
                    widget.package.locations,
                  ),
                  _buildDetailTile(
                    Icons.hotel,
                    'Accommodation',
                    widget.package.accommodation,
                  ),
                  _buildDetailTile(
                    Icons.restaurant_menu,
                    'Meals',
                    widget.package.meals,
                  ),
                  _buildDetailTile(
                    Icons.directions_car,
                    'Transportation',
                    widget.package.transportation,
                  ),

                  const SizedBox(height: 24),

                  // Book Now Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking feature coming soon!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 15, height: 1.5)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.blue.shade600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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

class DetailContentPage extends StatelessWidget {
  final String title;
  final List<String> content;
  final Color color;
  final IconData icon;

  const DetailContentPage({
    Key? key,
    required this.title,
    required this.content,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: content.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No $title information available',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: content.length,
              itemBuilder: (context, index) {
                final item = content[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(icon, color: color),
                    title: Text(item, style: const TextStyle(fontSize: 14)),
                  ),
                );
              },
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
