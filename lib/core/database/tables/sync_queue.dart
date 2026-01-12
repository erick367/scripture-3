import 'package:drift/drift.dart';

enum SyncOperation {
  insert,
  update,
  delete
}

enum SyncStatus {
  pending,
  inProgress,
  failed,
  completed
}

/// Table to track pending sync operations (Outbox Pattern)
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // Operation Details
  IntColumn get operation => intEnum<SyncOperation>()();
  TextColumn get entityTable => text()(); // e.g. 'journal_entries'
  IntColumn get entityId => integer()(); // Local ID of the entity
  
  // Sync Status
  IntColumn get status => intEnum<SyncStatus>().withDefault(const Constant(0))(); // Default: pending
  IntColumn get retries => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  
  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
}
