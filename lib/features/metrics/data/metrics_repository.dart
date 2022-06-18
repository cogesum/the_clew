import 'package:cloud_firestore/cloud_firestore.dart';

class MetricsRepository {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('metrics');

  getMetricsInfo() async {
    QuerySnapshot _querySnapshot = await _collectionReference.get();

    final metricsData = _querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return metricsData[0];
  }

  setMetricsInfo(int openEventsPageCounter, int openMapCounter) async {
    Map<String, dynamic> transactionInfoMap = {
      "open_map": openMapCounter,
      "open_events_page": openEventsPageCounter,
    };

    await FirebaseFirestore.instance
        .collection("metrics")
        .doc('BoAtXkdHou8fFCOekNKh')
        .set(
      {
        "open_map": openMapCounter,
        "open_events_page": openEventsPageCounter,
      },
      SetOptions(merge: true),
    );
  }
}
