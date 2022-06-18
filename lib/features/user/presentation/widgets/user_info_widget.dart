import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserInfo extends StatelessWidget {
  final String documentId;
  const GetUserInfo({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference user =
        FirebaseFirestore.instance.collection("usersData");
    return FutureBuilder<DocumentSnapshot>(
        future: user.doc(documentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text("${data['username']} - ${data['points']}");
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
