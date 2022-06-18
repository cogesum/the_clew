import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? username;
  final String? email;
  final int? points;

  UserModel({
    this.username,
    this.email,
    this.points,
  });

  UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : username = snapshot.data()?["username"],
        email = snapshot.data()?["email"],
        points = snapshot.data()?["points"];

  Map<String, dynamic> toFirestore() {
    return {
      if (username != null) "username": username,
      if (email != null) "email": email,
      if (points != null) "country": points,
    };
  }
}
