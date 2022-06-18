import 'package:cloud_firestore/cloud_firestore.dart';

class MapRepositories {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('locations');

  getLocationData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final allData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return allData;
  }

  getLocationByIndex(int index) async {
    if (index != null) {
      QuerySnapshot querySnapshot = await _collectionRef.get();

      final allData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return allData[index];
    } else {
      return null;
    }
  }
}
