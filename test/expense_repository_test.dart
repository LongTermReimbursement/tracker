import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracker/core/database/app_database.dart';
import 'package:tracker/features/expenses/data/expense_repository.dart';
import 'package:tracker/features/expenses/domain/expense.dart';

void main() {
  late AppDatabase db;
  late ExpenseRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ExpenseRepository(db);
  });

  tearDown(() => db.close());

  test('add stores an expense, newest purchase date first', () async {
    await repo.add(
      Expense(
        date: DateTime(2026, 1, 1),
        amountCents: 1250,
        category: ExpenseCategory.meals,
        merchant: ' Trattoria ',
        notes: '  lunch  ',
      ),
    );
    await repo.add(
      Expense(
        date: DateTime(2026, 2, 1),
        amountCents: 3000,
        category: ExpenseCategory.grocery,
        merchant: '  ',
        notes: '   ',
      ),
    );

    final list = await repo.watchAll().first;

    expect(list.map((e) => e.amountCents), [3000, 1250]);
    expect(list.map((e) => e.category), [
      ExpenseCategory.grocery,
      ExpenseCategory.meals,
    ]);
    expect(list.map((e) => e.merchant), [null, 'Trattoria']);
    expect(list.map((e) => e.notes), [null, 'lunch']);
  });

  test('parseAmountCents accepts a comma with at most 2 decimals', () {
    expect(parseAmountCents('12'), 1200);
    expect(parseAmountCents('12,5'), 1250);
    expect(parseAmountCents('12,05'), 1205);
    expect(parseAmountCents('12.50'), isNull);
    expect(parseAmountCents('1,234'), isNull);
    expect(parseAmountCents('12,'), isNull);
    expect(parseAmountCents('0'), isNull);
    expect(parseAmountCents('abc'), isNull);
  });

  test('formatCents always shows 2 decimals with a comma', () {
    expect(formatCents(1250), '12,50 €');
    expect(formatCents(300), '3,00 €');
    expect(formatCents(5), '0,05 €');
  });
}
