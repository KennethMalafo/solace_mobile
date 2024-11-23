import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthHelper {
  static Future<String> getOrCreateUserId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;

    // If user is not signed in, sign in anonymously
    if (currentUser == null) {
      final userCredential = await auth.signInAnonymously();
      final userId = userCredential.user!.uid;

      // Create user document if it doesn't exist
      final userCollection = FirebaseFirestore.instance.collection('users');
      await userCollection.doc(userId).set({
        'createdAt': FieldValue.serverTimestamp(),
        'hasAcceptedTerms': false,
      });

      return userId;
    } else {
      return currentUser.uid; // Return existing user ID if already authenticated
    }
  }
}
