import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Api {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> fetchAppliances(
      String location, bool limit) async {
    QuerySnapshot snapshot;
    limit
        ? snapshot = await _firestore
            .collection('Appliances')
            .where("location", arrayContains: location)
            .orderBy('timestamp', descending: true)
            .limit(4)
            .get()
        : snapshot = await _firestore
            .collection('Appliances')
            .where("location", arrayContains: location)
            .orderBy('timestamp', descending: true)
            .get();

    return snapshot.docs;
  }

  Future<List<DocumentSnapshot>> fetchOffers() async {
    QuerySnapshot snapshot = await _firestore.collection('Offers').get();

    return snapshot.docs;
  }

  Future<DocumentSnapshot> fetchServices(String appliance) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('Appliances').doc(appliance).get();

    return snapshot;
  }
}
