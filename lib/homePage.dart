import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracking/google_sign_in.dart';
import 'package:expense_tracking/expense_model.dart';
import 'package:expense_tracking/crud_operations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracking/firestore_service.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user, required this.userId});

  final User user;
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Expense> expenses = [];
  String userToken = '';
  String id = '';
  String title = '';
  double amount = 0;
  String expenseType = '';
  String explanation = '';
  String paymentMethod = '';
  Timestamp timestamp = Timestamp.now();
  DateTime date = DateTime.now();

  final CrudOperations _crudOperations = CrudOperations();
  final FirestoreService _firestoreService = FirestoreService();

  double total = 80.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Tracker',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(111, 61, 209, 1),
        actions: [
          IconButton(
              onPressed: () async {
                await GoogleSignInProvider().signOutGoogle();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: FutureBuilder(
          future: _firestoreService.getExpenses(), // Bunu kullanabilirsin
          //future: _firestoreService.getExpenses2(widget.userId),
          //future: _firestoreService.getExpenses3(widget.userId),
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
                  userToken = expenses[index]['userToken'];
                  id = expenses[index]['id'];
                  title = expenses[index]['title'];
                  amount = expenses[index]['amount'];
                  expenseType = expenses[index]['expenseType'];
                  explanation = expenses[index]['explanation'];
                  paymentMethod = expenses[index]['paymentMethod'];
                  timestamp = expenses[index]['date'];
                  date = timestamp.toDate();
                  print('USERTOKEN: ${userToken}');
                  print('\n\nUSERID: ${widget.userId}');
                  if (userToken.substring(0, 102) ==
                      widget.userId.substring(0, 102)) {
                    return Card(
                      child: ListTile(
                        title: Wrap(
                          children: [
                            Container(
                                width: 240,
                                child: Card(
                                  child: Text(title),
                                )),
                          ],
                        ),
                        subtitle: Wrap(
                          children: [
                            Container(
                                width: 240,
                                height: 50,
                                child: Card(
                                  child: Text(explanation),
                                )),
                            Card(
                                child: Text(
                                    '\$${amount.toStringAsFixed(2)} - ${paymentMethod} - ${expenseType}'))
                          ],
                        ),
                        leading: Text(DateFormat('yyyy-MM-dd \n kk:mm')
                            .format(expenses[index]['date'].toDate())
                            .toString()),
                        trailing: Wrap(
                          children: [
                            new IconButton(
                              icon: new Icon(Icons.update_rounded),
                              onPressed: () {
                                _addExpense(context, true, 'update');
                              },
                            ),
                            new IconButton(
                              icon: new Icon(Icons.delete),
                              onPressed: () {
                                _removeExpense(id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (expenses.length == 0) {
                    return Center(
                      child: Text('Lütfen bir gider ekleyiniz'),
                    );
                  } else {
                    return null;
                  }
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _addExpense(context, false, 'add');
        },
        backgroundColor: Theme.of(context).primaryColor,
        label: Text(
          'Total: \$${total}',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _addExpense(BuildContext context, bool isUpdated, String choice) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(
        choice,
        usr: widget.user,
      ),
    );

    if (isUpdated == false) {
      // Eklemek için
      setState(() {
        _crudOperations.addExpense(result);
      });
    } else if (isUpdated == true) {
      // Update için
      setState(() {
        _crudOperations.deleteExpense(id);
        _crudOperations.addExpense(result);
      });
    }
  }

  void _removeExpense(String id) {
    setState(() {
      _crudOperations.deleteExpense(id);
    });
  }

  Future<String?> getUserId() async {
    String? s;
    await widget.user.getIdToken().then((value) {
      s = value;
    });
    return s;
  }
}

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog(String choice,
      {super.key, this.isUpdate, this.exp, this.usr});

  final String? isUpdate;
  final Expense? exp;
  final User? usr;

  @override
  _AddExpenseDialogState createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final textController = TextEditingController(text: Uuid().v4());

  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  TextEditingController _explanationController = TextEditingController();

  final List<String> expenseTypeList = <String>[
    'Diğer',
    'Yemek',
    'Elektrik',
    'Su',
    'Isınma',
    'İnternet ve TV',
    'Eğlence',
    'Ulaşım',
    'Sağlık'
  ];

  final List<String> paymentMethodList = <String>['Cash', 'Card', 'Other'];
  String paymentMethod = 'Cash';

  String? expenseType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isUpdate == 'update') {
      _titleController.text = widget.exp!.title;
      _amountController.text = widget.exp!.amount.toString();
      _explanationController.text = widget.exp!.explanation;
      expenseType = widget.exp!.expenseType;
      paymentMethod = widget.exp!.paymentMethod;
    } else {
      _titleController.text = 'Title';
      _amountController.text = 'Amount';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: _titleController.text),
          ),
          TextField(
            controller: _amountController,
            decoration: InputDecoration(hintText: _amountController.text),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          DropdownButton(
            items: expenseTypeList.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? value) {
              expenseType = value;
            },
          ),
          Column(
            children: [
              ListTile(
                title: const Text('Cash'),
                leading: Radio(
                  value: paymentMethodList[0],
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value.toString();
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Card'),
                leading: Radio(
                  value: paymentMethodList[1],
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value.toString();
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Transfer'),
                leading: Radio(
                  value: paymentMethodList[2],
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value.toString();
                    });
                  },
                ),
              ),
            ],
          ),
          TextField(
            maxLines: 3, //or null
            decoration:
                InputDecoration.collapsed(hintText: "Enter your text here"),
            controller: _explanationController,
          ),
          TextFormField(controller: textController),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final title = _titleController.text;
            final amount = double.tryParse(_amountController.text);
            final expType = expenseType;
            final payMethod = paymentMethod;
            final expl = _explanationController.text;
            final dt = DateTime.now();
            final documentId = textController.text;
            final usrTkn = await getUserId();

            // if (widget.isUpdate == 'add') {
            //   final uuid = Uuid();
            //   documentId = uuid.v4();
            // } else {
            //   documentId = '';
            // }

            if (title.isNotEmpty &&
                amount != null &&
                expType != null &&
                usrTkn != null) {
              Navigator.of(context).pop(Expense(
                  id: documentId,
                  title: title,
                  amount: amount,
                  expenseType: expType,
                  paymentMethod: payMethod,
                  explanation: expl,
                  userToken: usrTkn,
                  date: dt));
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Future<String?> getUserId() async {
    String? s;
    await widget.usr?.getIdToken().then((value) {
      s = value;
    });
    return s;
  }
}
