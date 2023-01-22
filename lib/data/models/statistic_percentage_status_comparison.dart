
class StatisticPercentageStatusComparison {
  double numberOfAccomplishedPercentage;
  double numberOfAccomplishedInAdvancePercentage;
  double numberOfPendingPercentage;
  double numberOfNotAccomplishedUntilTargetDatePercentage;

  int numberOfAccomplishedQuantity;
  int numberOfAccomplishedInAdvanceQuantity;
  int numberOfNotAccomplishedUntilTargetDateQuantity;
  int numberOfPendingQuantity;

  StatisticPercentageStatusComparison({required this.numberOfAccomplishedPercentage,
        required this.numberOfAccomplishedInAdvancePercentage, required this.numberOfPendingPercentage,
        required this.numberOfNotAccomplishedUntilTargetDatePercentage,
        required this.numberOfAccomplishedQuantity, required this.numberOfAccomplishedInAdvanceQuantity,
        required this.numberOfNotAccomplishedUntilTargetDateQuantity, required this.numberOfPendingQuantity
  });
}