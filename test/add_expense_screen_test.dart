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
  Future<void> add(Expense expense) async {
    _items.insert(0, expense);
    _controller.add(List.of(_items));
  }
}

void main() {
  testWidgets('adds an expense and shows it in the list', (tester) async {
    final repo = _FakeRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repo)],
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
    await tester.enterText(find.byType(TextFormField).last, 'Lunch');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('12,50'), findsOneWidget);
    expect(find.textContaining('Lunch'), findsOneWidget);
  });
}
