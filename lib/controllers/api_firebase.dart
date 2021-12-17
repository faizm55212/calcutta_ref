import 'package:calcutta_ref/controllers/global_constans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<DocumentSnapshot> fetchProfile() async {
    DocumentSnapshot snapshot =
        await _firestore.collection('Users').doc(loggedInUser!.uid).get();

    return snapshot;
  }

  Future<DocumentSnapshot> fetchServices(String appliance) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('Appliances').doc(appliance).get();

    return snapshot;
  }

  updateProfile({
    String? name,
    int? mobile,
    String? email,
    String? street,
    String? landMark,
    String? city,
    int? pincode,
  }) {
    // if (loggedInUser!.phoneNumber == null) {
    //   FirebaseAuth.instance.currentUser!.updatePhoneNumber(PhoneAuthCredential);
    // }
    FirebaseFirestore.instance.collection('Users').doc(loggedInUser!.uid).set({
      'name': name,
      'mobile': mobile,
      'email': email,
      'street': street,
      'landMark': landMark,
      'city': city,
      'pincode': pincode,
      'address': street! +
          ', ' +
          landMark! +
          ', ' +
          city! +
          ' - ' +
          pincode!.toString(),
    }, SetOptions(merge: true));
  }
}
