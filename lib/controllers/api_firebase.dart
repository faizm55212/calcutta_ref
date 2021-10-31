import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> fetchApp(String location) async {
    QuerySnapshot snapshot = await _firestore
        .collection('Appliances')
        .where("location", arrayContains: location)
        .limit(3)
        .get();
    return snapshot.docs;
  }
}