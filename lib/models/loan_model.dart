class Loan {
  int id;
  int user;
  String loanType;
  String actorName;
  double amount;
  double amountPayed;
  double? interest;
  DateTime loanDueDate;
  String? description;
  DateTime createdAt;

  Loan({
    required this.id,
    required this.user,
    required this.loanType,
    required this.actorName,
    required this.amount,
    required this.amountPayed,
    this.interest,
    required this.loanDueDate,
    this.description,
    required this.createdAt,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      user: json['user'],
      loanType: json['loan_type'],
      actorName: json['actor_name'],
      amount: double.parse(json['amount']),
      amountPayed:
          json['amountPayed'] != null ? double.parse(json['amountPayed']) : 0.0,
      interest: json['interest'] != null ? double.parse(json['interest']) : 0.0,
      loanDueDate: DateTime.parse(json['loan_due_date']),
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'loan_type': loanType,
      'actor_name': actorName,
      'amount': amount,
      'amountPayed': amountPayed,
      'interest': interest,
      'loan_due_date': loanDueDate,
      'description': description,
      'created_at': createdAt,
    };
  }
}
