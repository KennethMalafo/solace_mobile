import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SavingUserReports {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save data (image URL, message, and location, email, and phone number) to Firestore
  Future<void> saveDataToFirestore(
    String imageUrl, 
    double latitude, 
    double longitude, 
    String message,
    String email,
    String phoneNumber,
    ) async {
    try {
      // Create a reference to the collection where data will be saved
      CollectionReference uploadsCollection = _firestore.collection('user_uploads');

      // Create the data to be saved
      Map<String, dynamic> uploadData = {
        'imageUrl': imageUrl,
        'latitude': latitude,
        'longitude': longitude,
        'message': message,
        'email' : email,
        'phoneNumber' : phoneNumber,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save the data to Firestore
      await uploadsCollection.add(uploadData);
      if (kDebugMode) {
        print('Data saved to Firestore successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving data to Firestore: $e');
      }
    }
  }

  // Method to retrieve all uploaded data
  Future<List<Map<String, dynamic>>> getUploadedData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('user_uploads').get();
      List<Map<String, dynamic>> uploads = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      return uploads;
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving data from Firestore: $e');
      }
      return [];
    }
  }
}
