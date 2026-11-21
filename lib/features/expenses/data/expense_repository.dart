import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/expense.dart';

class ExpenseRepository {
  ExpenseRepository(this._db);

  final AppDatabase _db;

  Stream<List<Expense>> watchAll() {
    final query = _db.select(_db.expenses)
      ..orderBy([
        (t) => OrderingTerm.desc(t.date),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return query.watch().map((rows) => rows.map(_toExpense).toList());
  }

  Future<void> add(Expense expense) {
    final notes = expense.notes?.trim();
    return _db
        .into(_db.expenses)
        .insert(
          ExpensesCompanion.insert(
            date: expense.date,
            amountCents: expense.amountCents,
            category: expense.category.name,
            notes: Value(notes == null || notes.isEmpty ? null : notes),
          ),
        );
  }

  Expense _toExpense(ExpenseRow r) => Expense(
    id: r.id,
    date: r.date,
    amountCents: r.amountCents,
    category: ExpenseCategory.values.byName(r.category),
    notes: r.notes,
  );
}
