import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracking/models/expense_model.dart';

class CrudOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExpense(Expense expense) async {
    await _firestore
        .collection('expenses')
        .doc(expense.id)
        .set(expense.toMap());
  }

  Future<void> updateExpense(String id, Expense expense) async {
    await _firestore.collection('expenses').doc(id).set(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _firestore.collection('expenses').doc(id).delete();
  }
}
