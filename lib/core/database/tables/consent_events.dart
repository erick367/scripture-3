import 'package:drift/drift.dart';

/// Table for storing consent events (privacy audit log)
@DataClassName('ConsentEventRow')
class ConsentEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get feature => text()();
  BoolColumn get granted => boolean()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();
}
