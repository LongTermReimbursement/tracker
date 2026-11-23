import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../domain/expense.dart';
import 'expenses_providers.dart';
import 'attachments_section.dart';
import 'pending_attachments.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key, this.expense});

  /// When set, the screen edits this expense instead of creating a new one.
  final Expense? expense;

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _amount = TextEditingController(
    text: widget.expense == null
        ? null
        : formatCents(widget.expense!.amountCents).replaceAll(' €', ''),
  );
  late final _merchant = TextEditingController(text: widget.expense?.merchant);
  late final _notes = TextEditingController(text: widget.expense?.notes);
  late DateTime _date =
      widget.expense?.date ?? DateUtils.dateOnly(DateTime.now());
  late ExpenseCategory _category =
      widget.expense?.category ?? ExpenseCategory.meals;
  bool _saving = false;
  List<String> _pendingAttachments = [];

  @override
  void dispose() {
    _amount.dispose();
    _merchant.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    setState(() => _saving = true);
    try {
      final expense = Expense(
        id: widget.expense?.id,
        date: _date,
        amountCents: parseAmountCents(_amount.text)!,
        category: _category,
        merchant: _merchant.text,
        notes: _notes.text,
      );
      final repository = ref.read(expenseRepositoryProvider);
      if (widget.expense == null) {
        final id = await repository.add(expense);
        final attachments = ref.read(attachmentRepositoryProvider);
        for (final path in _pendingAttachments) {
          await attachments.add(id, path);
        }
      } else {
        await repository.update(expense);
      }
      messenger.showSnackBar(SnackBar(content: Text(l10n.expenseSaved)));
      navigator.pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(l10n.actionFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense == null ? l10n.addExpenseTitle : l10n.editExpenseTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.dateLabel,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(DateFormat.yMMMd(locale).format(_date)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
              ],
              decoration: InputDecoration(
                labelText: l10n.amountLabel,
                prefixText: '€ ',
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.amountRequired;
                }
                return parseAmountCents(value) == null
                    ? l10n.amountInvalid
                    : null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ExpenseCategory>(
              initialValue: _category,
              decoration: InputDecoration(
                labelText: l10n.categoryLabel,
                border: const OutlineInputBorder(),
              ),
              items: [
                for (final c in ExpenseCategory.values)
                  DropdownMenuItem(
                    value: c,
                    child: Text(l10n.categoryLabelFor(c)),
                  ),
              ],
              onChanged: (c) => setState(() => _category = c ?? _category),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _merchant,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.merchantLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.notesLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.expense == null)
              PendingAttachments(
                paths: _pendingAttachments,
                onChanged: (paths) =>
                    setState(() => _pendingAttachments = paths),
              )
            else
              AttachmentsSection(widget.expense!.id!),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
