import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/database_provider.dart';
import '../data/attachment_repository.dart';
import '../data/expense_repository.dart';
import '../domain/attachment.dart';
import '../domain/expense.dart';

final attachmentRepositoryProvider = Provider<AttachmentRepository>(
  (ref) => AttachmentRepository(ref.watch(databaseProvider), () async {
    final docs = await getApplicationDocumentsDirectory();
    return Directory(p.join(docs.path, 'attachments'));
  }),
);

final attachmentsProvider = StreamProvider.family<List<Attachment>, int>(
  (ref, expenseId) =>
      ref.watch(attachmentRepositoryProvider).watchFor(expenseId),
);

final expenseRepositoryProvider = Provider<ExpenseRepository>(
  (ref) => ExpenseRepository(ref.watch(databaseProvider)),
);

final expensesProvider = StreamProvider<List<Expense>>(
  (ref) => ref.watch(expenseRepositoryProvider).watchAll(),
);
