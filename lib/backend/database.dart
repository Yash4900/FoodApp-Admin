import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future<bool> checkIfUserExists(String phoneNum) async {
    bool retValue = false;
    await FirebaseFirestore.instance
        .collection('Admin')
        .where('phoneNum', isEqualTo: phoneNum)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        retValue = true;
      }
    });
    return retValue;
  }

  Stream<QuerySnapshot> getOrders() {
    return FirebaseFirestore.instance.collection('Orders').snapshots();
  }
}
