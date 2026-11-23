import 'package:drift/drift.dart';

@DataClassName('AttachmentRow')
class Attachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get expenseId => integer()();
  // File name inside the app's attachments directory.
  TextColumn get fileName => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
