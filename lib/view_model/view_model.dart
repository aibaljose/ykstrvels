import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// -----------------------------
// HomeDataModel for trips
// -----------------------------
class HomeDataModel {
  String? title;
  String? host;
  String? date;
  List<StoryData>? stories;

  HomeDataModel({this.title, this.host, this.date, this.stories});
}

// -----------------------------
// StoryData for individual stories
// -----------------------------
class StoryData {
  String? storyTitle;
  String? storyContent;
  String? description;
  String? imageUrl;
  String? location; // <-- Add this field

  StoryData({
    this.storyTitle,
    this.storyContent,
    this.imageUrl,
    this.description,
    this.location,
  });
}

class ViewModel {
  Future<String> createUserAccountWithEmailAndPassword(
    String email,
    String name,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserdata(name: name, email: email);
      return "true";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> saveUserdata({
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    try {
      Map<String, dynamic> userData = {"name": name, "email": email};

      // Add photo URL if available
      if (photoUrl != null && photoUrl.isNotEmpty) {
        userData["photoUrl"] = photoUrl;
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(userData);

      return "true";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> loginwithemailandpassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Save user login state
      await _saveUserLoginState(userCredential.user!.uid);
      return "true";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // Google Sign-In
  Future<String> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return "Google sign-in was cancelled";
      }

      // Get authentication details from request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      // Check if it's a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // Save user data to Firestore for new Google sign-in users
        await saveUserdata(
          name: userCredential.user?.displayName ?? "Google User",
          email: userCredential.user?.email ?? "",
          photoUrl: userCredential.user?.photoURL,
        );
      }

      // Save user login state
      await _saveUserLoginState(userCredential.user!.uid);

      return "true";
    } catch (e) {
      return e.toString();
    }
  }

  // -----------------------------
  // Login Persistence Methods
  // -----------------------------
  Future<void> _saveUserLoginState(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', uid);
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<String?> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    // Try to sign out from Google as well
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      // Ignore errors if Google Sign-In wasn't used
    }

    // Clear saved login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId');
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      String? userId = await getLoggedInUserId();
      if (userId == null) return null;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user profile: $e");
      return null;
    }
  }

  Future<String?> getUserPhotoUrl() async {
    try {
      // Check if a user is currently signed in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Return photo URL if available (usually from Google Sign-in)
        if (user.photoURL != null && user.photoURL!.isNotEmpty) {
          return user.photoURL;
        }

        // If no photo URL in Firebase User, try Firestore
        String? userId = await getLoggedInUserId();
        if (userId != null) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .get();

          if (userDoc.exists) {
            final userData = userDoc.data() as Map<String, dynamic>;
            return userData['photoUrl'] as String?;
          }
        }
      }
      return null;
    } catch (e) {
      print("Error getting user photo URL: $e");
      return null;
    }
  }

  // -----------------------------
  // Fetch trips with nested stories
  // -----------------------------
  Future<List<HomeDataModel>> fetchHomeData() async {
    try {
      List<HomeDataModel> tripsList = [];

      // Get trips collection
      QuerySnapshot tripSnapshot = await FirebaseFirestore.instance
          .collection("trips")
          .get();

      for (var tripDoc in tripSnapshot.docs) {
        Map<String, dynamic> tripData = tripDoc.data() as Map<String, dynamic>;

        // Get nested stories for this trip
        QuerySnapshot storySnapshot = await FirebaseFirestore.instance
            .collection("trips")
            .doc(tripDoc.id)
            .collection("stories")
            .get();

        List<StoryData> stories = storySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return StoryData(
            storyTitle: data['title'] ?? '',
            storyContent: data['subtitle'] ?? '',
            description: data['content'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
            location: data['location'] ?? '', // <-- Add this line
          );
        }).toList();

        tripsList.add(
          HomeDataModel(
            title: tripData['title'] ?? '',
            host: tripData['host'] ?? '',
            date: tripData['date'] ?? '',
            stories: stories,
          ),
        );
      }

      return tripsList;
    } catch (e) {
      print("Error fetching home data: $e");
      return [];
    }
  }
}
