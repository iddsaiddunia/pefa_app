class Transaction {
  int id;
  int user;
  double amount;
  String transactionType;
  String? category;
  int? target;  
  int? loan;  
  String? description;
  DateTime date;

  Transaction({
    required this.id,
    required this.user,
    required this.amount,
    required this.transactionType,
    this.category,
    this.target,  // Include target field in constructor
    this.loan,  // Include target field in constructor
    this.description,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      user: json['user'],
      amount: double.parse(json['amount'].toString()), 
      transactionType: json['transaction_type'],
      category: json['category'],
      target: json['target'],  
      loan: json['loan'],  
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'amount': amount.toString(),
      'transaction_type': transactionType,
      'category': category,
      'target': target, 
      'loan': loan,  
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}

