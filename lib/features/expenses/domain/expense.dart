enum ExpenseCategory { meals, grocery }

class Expense {
  const Expense({
    this.id,
    required this.date,
    required this.amountCents,
    required this.category,
    this.notes,
  });

  final int? id;
  final DateTime date;
  final int amountCents;
  final ExpenseCategory category;
  final String? notes;
}

/// Parses a user-typed amount ("12", "12,5", "12,50") into cents, using ","
/// as decimal separator. Returns null when it is not a positive amount with
/// at most 2 digits after the comma.
int? parseAmountCents(String input) {
  final match = RegExp(r'^(\d+)(?:,(\d{1,2}))?$').firstMatch(input.trim());
  if (match == null) return null;
  final cents =
      int.parse(match.group(1)!) * 100 +
      int.parse((match.group(2) ?? '').padRight(2, '0'));
  return cents > 0 ? cents : null;
}

/// Formats cents with 2 decimals and "," as decimal separator.
String formatCents(int cents) =>
    '${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')} €';
