import 'package:cloud_firestore/cloud_firestore.dart';

class EventsRepository {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('events');

  getEventsData() async {
    QuerySnapshot _querySnapshot = await _collectionReference.get();

    final eventsData = _querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return eventsData;
  }

  getEventByIndex(int index) async {
    if (index != null) {
      QuerySnapshot _querySnapshot = await _collectionReference.get();

      final allData = _querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return allData[index];
    } else {
      return null;
    }
  }
}
