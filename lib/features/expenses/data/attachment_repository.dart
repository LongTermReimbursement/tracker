import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../../core/database/app_database.dart';
import '../domain/attachment.dart';

class AttachmentRepository {
  AttachmentRepository(this._db, this._directory);

  final AppDatabase _db;
  final Future<Directory> Function() _directory;

  Stream<List<Attachment>> watchFor(int expenseId) async* {
    final dir = await _directory();
    final query = _db.select(_db.attachments)
      ..where((t) => t.expenseId.equals(expenseId))
      ..orderBy([(t) => OrderingTerm.asc(t.id)]);
    yield* query.watch().map(
      (rows) => [
        for (final r in rows)
          Attachment(
            id: r.id,
            expenseId: r.expenseId,
            path: p.join(dir.path, r.fileName),
          ),
      ],
    );
  }

  /// Copies [sourcePath] into the attachments directory and links it.
  Future<void> add(int expenseId, String sourcePath) async {
    final dir = await _directory();
    await dir.create(recursive: true);
    final fileName =
        '${DateTime.now().microsecondsSinceEpoch}${p.extension(sourcePath)}';
    await File(sourcePath).copy(p.join(dir.path, fileName));
    await _db
        .into(_db.attachments)
        .insert(
          AttachmentsCompanion.insert(expenseId: expenseId, fileName: fileName),
        );
  }

  Future<void> delete(Attachment attachment) async {
    await (_db.delete(
      _db.attachments,
    )..where((t) => t.id.equals(attachment.id))).go();
    await _deleteFile(attachment.path);
  }

  Future<void> deleteAllFor(int expenseId) async {
    final dir = await _directory();
    final rows = await (_db.select(
      _db.attachments,
    )..where((t) => t.expenseId.equals(expenseId))).get();
    await (_db.delete(
      _db.attachments,
    )..where((t) => t.expenseId.equals(expenseId))).go();
    for (final r in rows) {
      await _deleteFile(p.join(dir.path, r.fileName));
    }
  }

  Future<void> _deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}
