import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/features/wallet/domain/shared_purchase_settlement.dart';

void main() {
  group('SharedPurchaseCalculator', () {
    test('Nashat pays 10,000 IQD for five active members', () {
      final result = SharedPurchaseCalculator.equalShares(
        totalIqd: 10000,
        activeMembers: 5,
        payerIsMember: true,
      );

      expect(result.payerOwnShareIqd, 2000);
      expect(result.othersOwePayerIqd, 8000);
      expect(result.payerOwnShareIqd + result.othersOwePayerIqd, 10000);
    });

    test('retains the total when IQD cannot split evenly', () {
      final result = SharedPurchaseCalculator.equalShares(
        totalIqd: 10001,
        activeMembers: 5,
        payerIsMember: true,
      );

      expect(result.payerOwnShareIqd, 2001);
      expect(result.othersOwePayerIqd, 8000);
    });
  });
}
