import 'package:clew_app/features/map/data/repository/get_current_position.dart';
import 'package:clew_app/features/map/data/repository/get_positions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EquitablePositions {
  final MapRepositories mapRepository = MapRepositories();
  Future comparePostions() async {
    final currrentPostion = await getCurrentPosition();
    final List locations = await mapRepository.getLocationData();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final _collectionRef = FirebaseFirestore.instance
        .collection('userLocations')
        .doc(userId)
        .collection('userLocationInfo');

    for (int i = 0; i <= locations.length; i++) {
      if (double.parse(
                (currrentPostion.latitude).toStringAsFixed(3),
              ) ==
              double.parse(
                (locations[i]['lat']).toStringAsFixed(3),
              ) &&
          double.parse(
                (currrentPostion.longitude).toStringAsFixed(3),
              ) ==
              double.parse(
                (locations[i]['lon']).toStringAsFixed(3),
              )) {
        Map<String, dynamic> userInfoMap = {
          "isVisited": true,
        };

        return await _collectionRef.doc('$i').set(userInfoMap);
      } else {
        return null;
      }
    }
  }
}
