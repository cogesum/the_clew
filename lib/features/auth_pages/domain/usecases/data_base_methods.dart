import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("usersData")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<DocumentSnapshot> getUserInfoDB(String userId) async {
    return FirebaseFirestore.instance.collection('usersData').doc(userId).get();
  }
}
