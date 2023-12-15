class Expense {
  String id;
  final String title;
  final double amount;
  final String expenseType;
  final String paymentMethod;
  final String explanation;
  final DateTime date;
  final String userToken;

  Expense(
      {required this.id,
      required this.title,
      required this.amount,
      required this.expenseType,
      required this.paymentMethod,
      required this.explanation,
      required this.date,
      required this.userToken});

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date,
      'expenseType': expenseType,
      'explanation': explanation,
      'id': id,
      'paymentMethod': paymentMethod,
      'title': title,
      'userToken': userToken.substring(0, 102),
    };
  }

  Expense.fromMap(Map<String, dynamic> map, String id)
      : id = map['id'],
        title = map['title'],
        amount = map['amount'],
        expenseType = map['expenseType'],
        paymentMethod = map['paymentMethod'],
        explanation = map['explanation'],
        userToken = map['userToken'],
        date = map['date'].toDate();
}
