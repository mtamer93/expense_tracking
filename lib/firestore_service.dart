import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getExpenses() async {
    QuerySnapshot snapshot = await _firestore.collection('expenses').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getExpenses2(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection(
              'expenses') // Replace 'expenses' with your collection name
          .where('userToken', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> expenses = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> doc) =>
              doc.data()!..addAll({'id': doc.id}))
          .toList();

      return expenses;
    } catch (e) {
      print('Error getting expenses: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getExpenses3(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection(
              'expenses') // Replace 'expenses' with your collection name
          .where('userToken', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> expenses = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return expenses;
    } catch (e) {
      print('Error getting expenses: $e');
      throw e;
    }
  }
}
