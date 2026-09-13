/// Transparent calculation for a shared purchase paid from the main user's wallet.
class SharedPurchaseSettlement {
  const SharedPurchaseSettlement({
    required this.totalIqd,
    required this.activeMembers,
    required this.payerIsMember,
    required this.payerOwnShareIqd,
    required this.othersOwePayerIqd,
  });

  final int totalIqd;
  final int activeMembers;
  final bool payerIsMember;
  final int payerOwnShareIqd;
  final int othersOwePayerIqd;
}

abstract final class SharedPurchaseCalculator {
  /// Uses integer division and allocates any remainder to the payer's own share.
  /// This avoids inventing fractional IQD and always preserves the total.
  static SharedPurchaseSettlement equalShares({
    required int totalIqd,
    required int activeMembers,
    required bool payerIsMember,
  }) {
    if (totalIqd <= 0) throw ArgumentError.value(totalIqd, 'totalIqd', 'Must be positive');
    if (activeMembers <= 0) throw ArgumentError.value(activeMembers, 'activeMembers', 'Must be positive');
    final baseShare = totalIqd ~/ activeMembers;
    final remainder = totalIqd % activeMembers;
    final payerOwnShare = payerIsMember ? baseShare + remainder : 0;
    return SharedPurchaseSettlement(
      totalIqd: totalIqd,
      activeMembers: activeMembers,
      payerIsMember: payerIsMember,
      payerOwnShareIqd: payerOwnShare,
      othersOwePayerIqd: totalIqd - payerOwnShare,
    );
  }
}
