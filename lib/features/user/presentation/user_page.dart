import 'package:clew_app/features/user/data/repositories/user_repository.dart';
import 'package:clew_app/features/user/presentation/pages/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final userInfo = UserRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userInfo.getInfoFromDB(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!.data();
        return UserProfile(
          username: data!['username'],
          email: data['email'],
          points: data['points'],
        );
      },
    );
  }
}
