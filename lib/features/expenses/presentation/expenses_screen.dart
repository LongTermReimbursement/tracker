import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/expense.dart';
import 'add_expense_screen.dart';
import 'expenses_providers.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.expensesTitle)),
      body: expenses.when(
        data:
            (list) =>
                list.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          context.l10n.expensesEmpty,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                    : ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, i) => _ExpenseTile(list[i]),
                    ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(context.l10n.expensesLoadError)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AddExpenseScreen()),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile(this.expense);

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat.yMMMd(locale).format(expense.date);
    final notes = expense.notes;
    return ListTile(
      leading: Icon(switch (expense.category) {
        ExpenseCategory.meals => Icons.restaurant,
        ExpenseCategory.grocery => Icons.shopping_basket,
      }),
      title: Text(l10n.categoryLabelFor(expense.category)),
      subtitle: Text(
        notes == null ? date : '$date\n$notes',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: notes != null,
      trailing: Text(
        formatCents(expense.amountCents),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
