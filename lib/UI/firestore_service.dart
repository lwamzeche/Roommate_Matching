import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static Future<void> updateUserData(String uid, String field, String value) async {
    if (uid.isEmpty) {
      print("Invalid User ID");
      return;
    }

    FirebaseFirestore.instance.collection('userProfiles').doc(uid).update({
      field: value,
    }).then((_) {
      print("$field updated successfully for user $uid.");
    }).catchError((error) {
      print("Error updating $field for user $uid: $error");
    });
  }
}
