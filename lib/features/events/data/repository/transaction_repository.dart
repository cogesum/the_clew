import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionRepository {
  getTransactionInfo() async {
    final CollectionReference _collectionReference =
        FirebaseFirestore.instance.collection('transactions');
    QuerySnapshot querySnapshot = await _collectionReference.get();

    final transactionInfo = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    return transactionInfo;
  }

  getEventsId() async {
    List<String> docIDs = [];

    await FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIDs.add(document.reference.id);
            }));

    return docIDs;
  }

  addTransactionInfo(String eventId, int newBalance, int oldBalance,
      int sumTransaction, String userId, DateTime dateTime) async {
    Map<String, dynamic> transactionInfoMap = {
      "eventId": eventId,
      "newBalance": newBalance,
      "oldBalance": oldBalance,
      "sumTransaction": sumTransaction,
      "userId": userId,
      "dateTime": dateTime,
    };

    await FirebaseFirestore.instance
        .collection('transactions')
        .doc()
        .set(transactionInfoMap);
  }
}
