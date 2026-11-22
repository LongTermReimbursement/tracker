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
    return _db
        .into(_db.expenses)
        .insert(
          ExpensesCompanion.insert(
            date: expense.date,
            amountCents: expense.amountCents,
            category: expense.category.name,
            merchant: Value(_blankToNull(expense.merchant)),
            notes: Value(_blankToNull(expense.notes)),
          ),
        );
  }

  Future<void> update(Expense expense) {
    return (_db.update(
      _db.expenses,
    )..where((t) => t.id.equals(expense.id!))).write(
      ExpensesCompanion(
        date: Value(expense.date),
        amountCents: Value(expense.amountCents),
        category: Value(expense.category.name),
        merchant: Value(_blankToNull(expense.merchant)),
        notes: Value(_blankToNull(expense.notes)),
      ),
    );
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.expenses)..where((t) => t.id.equals(id))).go();
  }

  String? _blankToNull(String? text) {
    final trimmed = text?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  Expense _toExpense(ExpenseRow r) => Expense(
    id: r.id,
    date: r.date,
    amountCents: r.amountCents,
    category: ExpenseCategory.values.byName(r.category),
    merchant: r.merchant,
    notes: r.notes,
  );
}
