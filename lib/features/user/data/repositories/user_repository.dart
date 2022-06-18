import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  Future<DocumentSnapshot<Map<String, dynamic>>> getInfoFromDB() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userDataFuture =
        FirebaseFirestore.instance.collection("usersData").doc(userId).get();

    return userDataFuture;
  }

  Future<void> setNewPoints(int newPoints) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userDataFuture = await FirebaseFirestore.instance
        .collection("usersData")
        .doc(userId)
        .set(
      {
        'points': newPoints,
      },
      SetOptions(merge: true),
    );
  }
}
