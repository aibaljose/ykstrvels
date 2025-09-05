import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup.dart';
import "login.dart";
import "splashscreen.dart";
import 'package:firebase_core/firebase_core.dart';
import "home.dart";
import "itinerary.dart";
import "package.dart"; // Add this import
import 'theme.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(
        255,
        255,
        255,
        255,
      ), // background color of status bar
      statusBarIconBrightness: Brightness.light, // white icons
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YKSTRAVELS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: AppColors.accent,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.primary),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
          ),
        ),
      ),
      routes: {
        '/signup': (context) => const Signup(),
        '/login': (context) => const Login(),
        '/home': (context) => const TravelStoriesPage(),
        '/itinerary': (context) => const ItineraryPage(),
        '/package': (context) => const PackageDetailPage(
          imageUrl: '',
          title: '',
          location: '',
          price: 0,
          rating: 0,
          reviews: 0,
          description: '',
        ),
      },
      home: const SplashScreen(),
    );
  }
}
