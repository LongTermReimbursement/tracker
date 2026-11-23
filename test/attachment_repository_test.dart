import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:tracker/core/database/app_database.dart';
import 'package:tracker/features/expenses/data/attachment_repository.dart';

void main() {
  late AppDatabase db;
  late Directory tmp;
  late AttachmentRepository repo;
  late File source;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tmp = await Directory.systemTemp.createTemp('attachments_test');
    repo = AttachmentRepository(
      db,
      () async => Directory(p.join(tmp.path, 'a')),
    );
    source = File(p.join(tmp.path, 'receipt.jpg'))..writeAsBytesSync([1, 2, 3]);
  });

  tearDown(() async {
    await db.close();
    await tmp.delete(recursive: true);
  });

  test('add copies the file and deleteAllFor removes it', () async {
    await repo.add(7, source.path);
    await repo.add(8, source.path);

    final items = await repo.watchFor(7).first;
    expect(items, hasLength(1));
    expect(File(items.single.path).existsSync(), isTrue);

    await repo.deleteAllFor(7);
    expect(await repo.watchFor(7).first, isEmpty);
    expect(File(items.single.path).existsSync(), isFalse);
    expect(await repo.watchFor(8).first, hasLength(1));
  });
}
