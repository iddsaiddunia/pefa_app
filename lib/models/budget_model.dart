class Budget {
  final int? id;
  final int userId;
  final String category;
  final double amount;
  final int duration; // Assuming this is an int now
  final double amountUsed;
  final DateTime? createdAt;

  Budget({
    this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.duration,
    required this.amountUsed,
    this.createdAt,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      userId: json['user'],
      category: json['category'],
      amount: json['amount'] != null
          ? (json['amount'] is String
              ? double.parse(json['amount'])
              : json['amount'].toDouble())
          : 0.0,
      duration: json['duration'],
      amountUsed: json['amount_used'] != null
          ? (json['amount_used'] is String
              ? double.parse(json['amount_used'])
              : json['amount_used'].toDouble())
          : 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'category': category,
      'amount': amount,
      'duration': duration,
      'amount_used': amountUsed,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
