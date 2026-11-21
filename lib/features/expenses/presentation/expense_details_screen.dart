import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/expense.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  const ExpenseDetailsScreen(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            formatCents(expense.amountCents),
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 24),
          _Field(
            l10n.dateLabel,
            DateFormat.yMMMMd(locale).format(expense.date),
          ),
          _Field(l10n.categoryLabel, l10n.categoryLabelFor(expense.category)),
          _Field(l10n.merchantField, expense.merchant),
          _Field(l10n.notesField, expense.notes),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(value ?? '—', style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
