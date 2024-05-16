import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_monitor/core/model/location_info.dart';

class FirebaseFirestoreHelper {
  static final firestore = FirebaseFirestore.instance;

  static void storeLocationInfo({required LocationInfo locationInfo}) {
    firestore
        .collection('LocationMonitore')
        .doc(locationInfo.date)
        .set(locationInfo.toMap());
  }

  static void storeFaluireInfo({required Object error}) {
    firestore
        .collection('FaluireInfo')
        .doc(DateTime.now().toString())
        .set({'error': error.toString()});
  }
}
