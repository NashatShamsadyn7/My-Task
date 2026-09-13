enum LedgerAccount { personalWallet, apartmentFund, memberReceivable, memberPayable }

enum LedgerDirection { credit, debit }

enum LedgerKind {
  openingBalance,
  income,
  personalExpense,
  apartmentContribution,
  apartmentPurchase,
  reimbursement,
  adjustment,
  debtSettlement,
  reversal,
}

/// Immutable accounting record. Amounts are whole Iraqi dinars to avoid rounding errors.
class LedgerEntry {
  const LedgerEntry({
    required this.id,
    required this.account,
    required this.direction,
    required this.kind,
    required this.amountIqd,
    required this.occurredAt,
    required this.createdAt,
    this.relatedEntityId,
    this.counterpartyId,
    this.note,
  }) : assert(amountIqd > 0);

  final String id;
  final LedgerAccount account;
  final LedgerDirection direction;
  final LedgerKind kind;
  final int amountIqd;
  final DateTime occurredAt;
  final DateTime createdAt;
  final String? relatedEntityId;
  final String? counterpartyId;
  final String? note;
}
