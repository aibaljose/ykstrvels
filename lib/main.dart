
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup.dart';
import "login.dart";
import "splashscreen.dart";
import 'package:firebase_core/firebase_core.dart';
 // ✅ Added import
 import "home.dart";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 255, 255, 255), // background color of status bar
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
        primarySwatch: Colors.blue,
      ),
      
      routes: {
        '/signup': (context) => const Signup(),
        '/login': (context) => const Login(),
        '/home': (context) => const TravelStoriesPage(),
      },
      home: const SplashScreen(),
    );
  }
}