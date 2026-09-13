import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/features/wallet/domain/ledger_calculator.dart';
import 'package:talib_al_jamia/features/wallet/domain/ledger_entry.dart';

void main() {
  test('derives personal balance from immutable entries', () {
    final now = DateTime(2026, 9, 13);
    final entries = [
      LedgerEntry(
          id: 'opening',
          account: LedgerAccount.personalWallet,
          direction: LedgerDirection.credit,
          kind: LedgerKind.openingBalance,
          amountIqd: 125000,
          occurredAt: now,
          createdAt: now),
      LedgerEntry(
          id: 'purchase',
          account: LedgerAccount.personalWallet,
          direction: LedgerDirection.debit,
          kind: LedgerKind.apartmentPurchase,
          amountIqd: 12000,
          occurredAt: now,
          createdAt: now),
    ];
    expect(LedgerCalculator.balanceFor(LedgerAccount.personalWallet, entries),
        113000);
  });
}
