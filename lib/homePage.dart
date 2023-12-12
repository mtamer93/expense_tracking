import 'package:expense_tracking/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Expense {
  final String title;
  final double amount;
  final String expenseType;
  final String paymentMethod;
  final String explanation;

  Expense(
      {required this.title,
      required this.amount,
      required this.expenseType,
      required this.paymentMethod,
      required this.explanation});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> expenses = [
    Expense(
        title: 'Groceries',
        amount: 50.0,
        expenseType: 'Yemek',
        paymentMethod: 'Card',
        explanation: 'Taze meyve ve sebze'),
    Expense(
        title: 'Dinner',
        amount: 30.0,
        expenseType: 'Yemek',
        paymentMethod: 'Cash',
        explanation: 'Lahmacun'),
  ];

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
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return Card(
            child: ListTile(
              title: Wrap(
                children: [
                  Container(
                      width: 240,
                      child: Card(
                        child: Text(expense.title),
                      )),
                ],
              ),
              subtitle: Wrap(
                children: [
                  Container(
                      width: 240,
                      height: 50,
                      child: Card(
                        child: Text(expense.explanation),
                      )),
                  Card(
                      child: Text(
                          '\$${expense.amount.toStringAsFixed(2)} - ${expense.paymentMethod} - ${expense.expenseType}'))
                ],
              ),
              leading: Text(DateFormat('yyyy-MM-dd \n kk:mm')
                  .format(DateTime.now())
                  .toString()),
              trailing: Wrap(
                children: [
                  new IconButton(
                    icon: new Icon(Icons.update_rounded),
                    onPressed: () {
                      _addExpense(context, expenses[index], true, index);
                    },
                  ),
                  new IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: () {
                      _removeExpense(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _addExpense(context, null, false, -1);
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

  void _addExpense(
      BuildContext context, Expense? expense, bool isUpdated, int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(
        exp: expense,
      ),
    );

    if (result != null && isUpdated == false) {
      // Eklemek için
      setState(() {
        expenses.add(result);
        total += expenses.last.amount;
      });
    } else if (result != null && isUpdated == true) {
      // Update için
      setState(() {
        total -= expenses[index].amount;
        expenses.removeAt(index);
        expenses.add(result);
        total += expenses.last.amount;
      });
    }
  }

  void _removeExpense(int index) {
    setState(() {
      total -= expenses[index].amount;
      expenses.removeAt(index);
    });
  }
}

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key, this.exp});

  final Expense? exp;

  @override
  _AddExpenseDialogState createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
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
    if (widget.exp != null) {
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
          onPressed: () {
            final title = _titleController.text;
            final amount = double.tryParse(_amountController.text);
            final expType = expenseType;
            final payMethod = paymentMethod;
            final expl = _explanationController.text;

            if (title.isNotEmpty && amount != null && expType != null) {
              Navigator.of(context).pop(Expense(
                  title: title,
                  amount: amount,
                  expenseType: expType,
                  paymentMethod: payMethod,
                  explanation: expl));
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
