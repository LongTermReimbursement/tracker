import 'package:drift/drift.dart';

@DataClassName('ExpenseRow')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  // Total in cents, to avoid floating point errors.
  IntColumn get amountCents => integer()();
  // ExpenseCategory.name
  TextColumn get category => text()();
  TextColumn get merchant => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
