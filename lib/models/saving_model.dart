// saving_model.dart
class Saving {
  int? id;
  int user;
  double amount;
  DateTime createdAt;

  Saving({
    required this.id,
    required this.user,
    required this.amount,
    required this.createdAt,
  });

  factory Saving.fromJson(Map<String, dynamic> json) {
    return Saving(
      id: json['id'],
      user: json['user'],
      amount: (json['amount'] is String)
          ? double.parse(json['amount'])
          : json['amount'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user,
        'amount': amount,
        'created_at': createdAt.toIso8601String(), // Convert DateTime to ISO 8601 string
      };
}
