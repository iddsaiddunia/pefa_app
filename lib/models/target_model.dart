class Target {
  int id;
  int userId;
  double targetedAmount;
  double amountSaved;
  String targetName;
  String description;
  String targetStatus;
  DateTime targetDate;
  DateTime createdAt;

  Target({
    required this.id,
    required this.userId,
    required this.targetedAmount,
    required this.amountSaved,
    required this.targetName,
    required this.description,
    required this.targetStatus,
    required this.targetDate,
    required this.createdAt,
  });

  factory Target.fromJson(Map<String, dynamic> json) {
    return Target(
      id: json['id'],
      userId: json['user'],
      targetedAmount: json['targeted_amount'] != null
          ? double.parse(json['targeted_amount'].toString())
          : 0.0,
      amountSaved: json['amount_saved'] != null
          ? double.parse(json['amount_saved'].toString())
          : 0.0,
      targetName: json['target_name'],
      description: json['description'],
      targetStatus: json['target_status'],
      targetDate: DateTime.parse(json['target_date']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'targeted_amount': targetedAmount,
      'amount_saved': amountSaved,
      'target_name': targetName,
      'description': description,
      'target_status': targetStatus,
      'target_date': targetDate,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
