# YKSTRAVELS

## Firebase Security Rules Configuration

To fix the "Missing or insufficient permissions" error in Firestore, you need to update your Firestore security rules. Here's how:

1. Log in to the [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. In the left sidebar, click on "Firestore Database"
4. Click on the "Rules" tab
5. Replace the existing rules with the ones from the `firestore.rules` file in this project
6. Click "Publish"

Here are the rules for quick reference:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow public read access to all documents
    match /{document=**} {
      allow read: if true;
    }
    
    // Allow write access to trips collection and subcollections
    match /trips/{tripId} {
      allow write: if true;
      
      match /stories/{storyId} {
        allow write: if true;
      }
    }
    
    // Allow write access to users collection
    match /users/{userId} {
      allow write: if true;
    }
  }
}
```

> **Note**: These rules allow public read and write access to your database. This is suitable for development but not for production. For production, implement proper authentication and authorization.

## Add Sample Data

You can add sample data with images by clicking the photo icon in the app header. This will populate your Firestore database with sample trips and stories, including images from Unsplash.
