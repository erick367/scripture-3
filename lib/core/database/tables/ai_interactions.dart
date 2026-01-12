import 'package:drift/drift.dart';

class AiInteractions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get verseReference => text()();
  TextColumn get aiResponse => text()(); // Raw XML insight
  DateTimeColumn get createdAt => dateTime()();
}
