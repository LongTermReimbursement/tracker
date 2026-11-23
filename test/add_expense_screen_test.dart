import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tracker/app.dart';
import 'package:tracker/features/expenses/data/expense_repository.dart';
import 'package:tracker/features/expenses/domain/expense.dart';
import 'package:tracker/features/expenses/presentation/expenses_providers.dart';

// Drift streams need real async, which testWidgets' fake clock does not give.
class _FakeRepository implements ExpenseRepository {
  final _items = <Expense>[];
  final _controller = StreamController<List<Expense>>.broadcast();

  @override
  Stream<List<Expense>> watchAll() async* {
    yield List.of(_items);
    yield* _controller.stream;
  }

  @override
  Future<int> add(Expense expense) async {
    final id = _items.length + 1;
    _items.insert(
      0,
      Expense(
        id: id,
        date: expense.date,
        amountCents: expense.amountCents,
        category: expense.category,
        merchant: expense.merchant,
        notes: expense.notes,
      ),
    );
    _controller.add(List.of(_items));
    return id;
  }

  @override
  Future<void> delete(int id) async {
    _items.removeWhere((e) => e.id == id);
    _controller.add(List.of(_items));
  }

  @override
  Future<void> update(Expense expense) async {
    final i = _items.indexWhere((e) => e.id == expense.id);
    if (i >= 0) _items[i] = expense;
    _controller.add(List.of(_items));
  }
}

void main() {
  testWidgets('adds an expense and shows it in the list', (tester) async {
    final repo = _FakeRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          expenseRepositoryProvider.overrideWithValue(repo),
          attachmentsProvider.overrideWith((ref, id) => Stream.value([])),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No expenses'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the amount'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '12,50');
    await tester.enterText(find.byType(TextFormField).at(1), 'Trattoria');
    await tester.enterText(find.byType(TextFormField).last, 'Lunch');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('12,50'), findsOneWidget);
    expect(find.text('Trattoria'), findsOneWidget);
    expect(find.textContaining('Lunch'), findsOneWidget);

    await tester.tap(find.text('Trattoria'));
    await tester.pumpAndSettle();
    expect(find.text('Expense Details'), findsOneWidget);
    expect(find.text('12,50 €'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
  });
}
