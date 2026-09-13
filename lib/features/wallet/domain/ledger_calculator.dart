import 'ledger_entry.dart';

abstract final class LedgerCalculator {
  static int balanceFor(LedgerAccount account, Iterable<LedgerEntry> entries) {
    return entries.where((entry) => entry.account == account).fold(0, (balance, entry) {
      return entry.direction == LedgerDirection.credit
          ? balance + entry.amountIqd
          : balance - entry.amountIqd;
    });
  }
}
