import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ykstravels/view_model/view_model.dart';
import '../widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final ViewModel _viewModel = ViewModel();

  @override
  void initState() {
    super.initState();

    // Preload Lottie animation to avoid delay
    AssetLottie('assets/images/animations/Travel.json').load().then((composition) {
      print('✅ Lottie preloaded: ${composition.duration}');
    }).catchError((error) {
      print('❌ Lottie preload error: $error');
    });

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Create animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations and check login status
    _fadeController.forward();
    _scaleController.forward().then((_) {
      if (mounted) _checkLoginStatus(); // Start login check after logo animation
    });
  }

  Future<void> _checkLoginStatus() async {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        child: LoadingIndicator(),
      ),
    );

    final startTime = DateTime.now();
    const minLoadingDuration = Duration(milliseconds: 1500); // 1.5s for visibility

    try {
      bool isLoggedIn = await _viewModel.isUserLoggedIn();
      final elapsed = DateTime.now().difference(startTime);
      final remaining = minLoadingDuration - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }
      if (mounted) Navigator.pop(context);
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/signup');
      }
    } catch (e) {
      print('Login check error: $e');
      final elapsed = DateTime.now().difference(startTime);
      final remaining = minLoadingDuration - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }
      if (mounted) Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/signup');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_fadeController, _scaleController]),
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Clean logo presentation
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.travel_explore,
                                size: 80,
                                color: Colors.blue.shade700,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // App name with elegant typography
                      Text(
                        "YKS Trips",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}