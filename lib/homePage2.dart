import 'package:flutter/material.dart';
// import 'package:expense_tracking/crud_operations.dart';
import 'package:expense_tracking/firestore_service.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  // final CrudOperations _crudOperations = CrudOperations();
  final FirestoreService _firestoreService = FirestoreService();
  // final TextEditingController _titleController = TextEditingController();
  // final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: FutureBuilder(
        future: _firestoreService.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> expenses =
                snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(expenses[index]['title']),
                  subtitle: Text('\$${expenses[index]['amount']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
