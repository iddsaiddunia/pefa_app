
enum TargetStatus {
  onprogress,
  completed,
  failed,
}

class Target{
  final String targetName;
  final double targetAmount;
  final DateTime targetDuration;
  final String targetDescription;
  final double currentAmount;
  final TargetStatus status ;

  Target({
    required this.targetName,
    required this.targetAmount,
    required this.targetDuration,
    required this.targetDescription,
    required this.currentAmount,
    required this.status,
});

}

List<Target> myTargets = [
  Target(targetName: "new Laptop", targetAmount: 8000000.0, targetDuration: DateTime(2024, 5, 25), targetDescription: "I want to buy new laptop for my new work", currentAmount: 200000.0, status: TargetStatus.onprogress),
  Target(targetName: "new House", targetAmount: 18000000.0, targetDuration: DateTime(2024, 11, 02), targetDescription: "planning to buy new house at kinondoni", currentAmount: 4500000.0, status: TargetStatus.onprogress),
];