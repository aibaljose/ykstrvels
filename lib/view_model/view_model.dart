import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewModel {
  createUserAccountWithEmailAndPassword(
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

  saveUserdata({required String name, required String email}) async {
    try {
      Map<String, dynamic> userData = {
        "name": name,
        "email": email,
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(userData);

          return "true";
    } catch (e) {
      return e.toString();
    }
  }

  loginwithemailandpassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "true";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}


  // -----------------------------
  // Fetch trips with nested stories
  // -----------------------------
  Future<List<HomeDataModel>> fetchHomeData() async {
    try {
      List<HomeDataModel> tripsList = [];

      // Get trips collection
      QuerySnapshot tripSnapshot =
          await FirebaseFirestore.instance.collection("trips").get();

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
          );
        }).toList();

        tripsList.add(HomeDataModel(
          title: tripData['title'] ?? '',
          host: tripData['host'] ?? '',
          date: tripData['date'] ?? '',
          stories: stories,
        ));
      }

      return tripsList;
    } catch (e) {
      print("Error fetching home data: $e");
      return [];
    }
  }


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

  StoryData({this.storyTitle, this.storyContent});
}