import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/expense.dart';
import 'add_expense_screen.dart';
import 'attachments_section.dart';
import 'expenses_providers.dart';

class ExpenseDetailsScreen extends ConsumerWidget {
  const ExpenseDetailsScreen(this.expense, {super.key});

  final Expense expense;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteTooltip),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(attachmentRepositoryProvider).deleteAllFor(expense.id!);
      await ref.read(expenseRepositoryProvider).delete(expense.id!);
      messenger.showSnackBar(SnackBar(content: Text(l10n.expenseDeleted)));
      navigator.pop();
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.actionFailed)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.detailsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: l10n.deleteTooltip,
            onPressed: () => _delete(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: l10n.editTooltip,
            onPressed: () async {
              final navigator = Navigator.of(context);
              final saved = await navigator.push<bool>(
                MaterialPageRoute(
                  builder: (_) => AddExpenseScreen(expense: expense),
                ),
              );
              if (saved == true) navigator.pop();
            },
          ),
        ],
      ),
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
          const SizedBox(height: 8),
          AttachmentsSection(expense.id!),
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
