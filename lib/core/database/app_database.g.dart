// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _verseReferenceMeta =
      const VerificationMeta('verseReference');
  @override
  late final GeneratedColumn<String> verseReference = GeneratedColumn<String>(
      'verse_reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emotionTagMeta =
      const VerificationMeta('emotionTag');
  @override
  late final GeneratedColumn<String> emotionTag = GeneratedColumn<String>(
      'emotion_tag', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aiAccessEnabledMeta =
      const VerificationMeta('aiAccessEnabled');
  @override
  late final GeneratedColumn<bool> aiAccessEnabled = GeneratedColumn<bool>(
      'ai_access_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("ai_access_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lookForwardNotesMeta =
      const VerificationMeta('lookForwardNotes');
  @override
  late final GeneratedColumn<String> lookForwardNotes = GeneratedColumn<String>(
      'look_forward_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        verseReference,
        content,
        emotionTag,
        aiAccessEnabled,
        createdAt,
        updatedAt,
        lookForwardNotes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(Insertable<JournalEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('verse_reference')) {
      context.handle(
          _verseReferenceMeta,
          verseReference.isAcceptableOrUnknown(
              data['verse_reference']!, _verseReferenceMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('emotion_tag')) {
      context.handle(
          _emotionTagMeta,
          emotionTag.isAcceptableOrUnknown(
              data['emotion_tag']!, _emotionTagMeta));
    }
    if (data.containsKey('ai_access_enabled')) {
      context.handle(
          _aiAccessEnabledMeta,
          aiAccessEnabled.isAcceptableOrUnknown(
              data['ai_access_enabled']!, _aiAccessEnabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('look_forward_notes')) {
      context.handle(
          _lookForwardNotesMeta,
          lookForwardNotes.isAcceptableOrUnknown(
              data['look_forward_notes']!, _lookForwardNotesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      verseReference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verse_reference']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      emotionTag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emotion_tag']),
      aiAccessEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}ai_access_enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lookForwardNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}look_forward_notes']),
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  /// Auto-increment primary key
  final int id;

  /// Optional Bible verse reference (e.g., "John 3:16")
  final String? verseReference;

  /// The actual journal entry content (will be encrypted at rest)
  final String content;

  /// User-selected emotion tag (e.g., "Grateful", "Hopeful")
  final String? emotionTag;

  /// Whether this entry should be used for AI context (memory)
  final bool aiAccessEnabled;

  /// When the entry was created
  final DateTime createdAt;

  /// When the entry was last updated
  final DateTime updatedAt;

  /// JSON array of Look Forward notes (action items from mentorship sessions)
  /// Format: [{"createdAt":"ISO8601","question":"...","note":"...","theme":"..."}]
  final String? lookForwardNotes;
  const JournalEntry(
      {required this.id,
      this.verseReference,
      required this.content,
      this.emotionTag,
      required this.aiAccessEnabled,
      required this.createdAt,
      required this.updatedAt,
      this.lookForwardNotes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || verseReference != null) {
      map['verse_reference'] = Variable<String>(verseReference);
    }
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || emotionTag != null) {
      map['emotion_tag'] = Variable<String>(emotionTag);
    }
    map['ai_access_enabled'] = Variable<bool>(aiAccessEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lookForwardNotes != null) {
      map['look_forward_notes'] = Variable<String>(lookForwardNotes);
    }
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      verseReference: verseReference == null && nullToAbsent
          ? const Value.absent()
          : Value(verseReference),
      content: Value(content),
      emotionTag: emotionTag == null && nullToAbsent
          ? const Value.absent()
          : Value(emotionTag),
      aiAccessEnabled: Value(aiAccessEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lookForwardNotes: lookForwardNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(lookForwardNotes),
    );
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      verseReference: serializer.fromJson<String?>(json['verseReference']),
      content: serializer.fromJson<String>(json['content']),
      emotionTag: serializer.fromJson<String?>(json['emotionTag']),
      aiAccessEnabled: serializer.fromJson<bool>(json['aiAccessEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lookForwardNotes: serializer.fromJson<String?>(json['lookForwardNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'verseReference': serializer.toJson<String?>(verseReference),
      'content': serializer.toJson<String>(content),
      'emotionTag': serializer.toJson<String?>(emotionTag),
      'aiAccessEnabled': serializer.toJson<bool>(aiAccessEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lookForwardNotes': serializer.toJson<String?>(lookForwardNotes),
    };
  }

  JournalEntry copyWith(
          {int? id,
          Value<String?> verseReference = const Value.absent(),
          String? content,
          Value<String?> emotionTag = const Value.absent(),
          bool? aiAccessEnabled,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<String?> lookForwardNotes = const Value.absent()}) =>
      JournalEntry(
        id: id ?? this.id,
        verseReference:
            verseReference.present ? verseReference.value : this.verseReference,
        content: content ?? this.content,
        emotionTag: emotionTag.present ? emotionTag.value : this.emotionTag,
        aiAccessEnabled: aiAccessEnabled ?? this.aiAccessEnabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lookForwardNotes: lookForwardNotes.present
            ? lookForwardNotes.value
            : this.lookForwardNotes,
      );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      verseReference: data.verseReference.present
          ? data.verseReference.value
          : this.verseReference,
      content: data.content.present ? data.content.value : this.content,
      emotionTag:
          data.emotionTag.present ? data.emotionTag.value : this.emotionTag,
      aiAccessEnabled: data.aiAccessEnabled.present
          ? data.aiAccessEnabled.value
          : this.aiAccessEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lookForwardNotes: data.lookForwardNotes.present
          ? data.lookForwardNotes.value
          : this.lookForwardNotes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('verseReference: $verseReference, ')
          ..write('content: $content, ')
          ..write('emotionTag: $emotionTag, ')
          ..write('aiAccessEnabled: $aiAccessEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lookForwardNotes: $lookForwardNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, verseReference, content, emotionTag,
      aiAccessEnabled, createdAt, updatedAt, lookForwardNotes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.verseReference == this.verseReference &&
          other.content == this.content &&
          other.emotionTag == this.emotionTag &&
          other.aiAccessEnabled == this.aiAccessEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lookForwardNotes == this.lookForwardNotes);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String?> verseReference;
  final Value<String> content;
  final Value<String?> emotionTag;
  final Value<bool> aiAccessEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> lookForwardNotes;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.verseReference = const Value.absent(),
    this.content = const Value.absent(),
    this.emotionTag = const Value.absent(),
    this.aiAccessEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lookForwardNotes = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.verseReference = const Value.absent(),
    required String content,
    this.emotionTag = const Value.absent(),
    this.aiAccessEnabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lookForwardNotes = const Value.absent(),
  })  : content = Value(content),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? verseReference,
    Expression<String>? content,
    Expression<String>? emotionTag,
    Expression<bool>? aiAccessEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? lookForwardNotes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (verseReference != null) 'verse_reference': verseReference,
      if (content != null) 'content': content,
      if (emotionTag != null) 'emotion_tag': emotionTag,
      if (aiAccessEnabled != null) 'ai_access_enabled': aiAccessEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lookForwardNotes != null) 'look_forward_notes': lookForwardNotes,
    });
  }

  JournalEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? verseReference,
      Value<String>? content,
      Value<String?>? emotionTag,
      Value<bool>? aiAccessEnabled,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String?>? lookForwardNotes}) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      verseReference: verseReference ?? this.verseReference,
      content: content ?? this.content,
      emotionTag: emotionTag ?? this.emotionTag,
      aiAccessEnabled: aiAccessEnabled ?? this.aiAccessEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lookForwardNotes: lookForwardNotes ?? this.lookForwardNotes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (verseReference.present) {
      map['verse_reference'] = Variable<String>(verseReference.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (emotionTag.present) {
      map['emotion_tag'] = Variable<String>(emotionTag.value);
    }
    if (aiAccessEnabled.present) {
      map['ai_access_enabled'] = Variable<bool>(aiAccessEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lookForwardNotes.present) {
      map['look_forward_notes'] = Variable<String>(lookForwardNotes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('verseReference: $verseReference, ')
          ..write('content: $content, ')
          ..write('emotionTag: $emotionTag, ')
          ..write('aiAccessEnabled: $aiAccessEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lookForwardNotes: $lookForwardNotes')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<SyncOperation, int> operation =
      GeneratedColumn<int>('operation', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<SyncOperation>($SyncQueueTable.$converteroperation);
  static const VerificationMeta _entityTableMeta =
      const VerificationMeta('entityTable');
  @override
  late final GeneratedColumn<String> entityTable = GeneratedColumn<String>(
      'entity_table', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<SyncStatus>($SyncQueueTable.$converterstatus);
  static const VerificationMeta _retriesMeta =
      const VerificationMeta('retries');
  @override
  late final GeneratedColumn<int> retries = GeneratedColumn<int>(
      'retries', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastAttemptAtMeta =
      const VerificationMeta('lastAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>('last_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        operation,
        entityTable,
        entityId,
        status,
        retries,
        lastError,
        createdAt,
        lastAttemptAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_table')) {
      context.handle(
          _entityTableMeta,
          entityTable.isAcceptableOrUnknown(
              data['entity_table']!, _entityTableMeta));
    } else if (isInserting) {
      context.missing(_entityTableMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('retries')) {
      context.handle(_retriesMeta,
          retries.isAcceptableOrUnknown(data['retries']!, _retriesMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
          _lastAttemptAtMeta,
          lastAttemptAt.isAcceptableOrUnknown(
              data['last_attempt_at']!, _lastAttemptAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      operation: $SyncQueueTable.$converteroperation.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}operation'])!),
      entityTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_table'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_id'])!,
      status: $SyncQueueTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      retries: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retries'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_attempt_at']),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncOperation, int, int> $converteroperation =
      const EnumIndexConverter<SyncOperation>(SyncOperation.values);
  static JsonTypeConverter2<SyncStatus, int, int> $converterstatus =
      const EnumIndexConverter<SyncStatus>(SyncStatus.values);
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final SyncOperation operation;
  final String entityTable;
  final int entityId;
  final SyncStatus status;
  final int retries;
  final String? lastError;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  const SyncQueueData(
      {required this.id,
      required this.operation,
      required this.entityTable,
      required this.entityId,
      required this.status,
      required this.retries,
      this.lastError,
      required this.createdAt,
      this.lastAttemptAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['operation'] =
          Variable<int>($SyncQueueTable.$converteroperation.toSql(operation));
    }
    map['entity_table'] = Variable<String>(entityTable);
    map['entity_id'] = Variable<int>(entityId);
    {
      map['status'] =
          Variable<int>($SyncQueueTable.$converterstatus.toSql(status));
    }
    map['retries'] = Variable<int>(retries);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      operation: Value(operation),
      entityTable: Value(entityTable),
      entityId: Value(entityId),
      status: Value(status),
      retries: Value(retries),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      operation: $SyncQueueTable.$converteroperation
          .fromJson(serializer.fromJson<int>(json['operation'])),
      entityTable: serializer.fromJson<String>(json['entityTable']),
      entityId: serializer.fromJson<int>(json['entityId']),
      status: $SyncQueueTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      retries: serializer.fromJson<int>(json['retries']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operation': serializer
          .toJson<int>($SyncQueueTable.$converteroperation.toJson(operation)),
      'entityTable': serializer.toJson<String>(entityTable),
      'entityId': serializer.toJson<int>(entityId),
      'status': serializer
          .toJson<int>($SyncQueueTable.$converterstatus.toJson(status)),
      'retries': serializer.toJson<int>(retries),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
    };
  }

  SyncQueueData copyWith(
          {int? id,
          SyncOperation? operation,
          String? entityTable,
          int? entityId,
          SyncStatus? status,
          int? retries,
          Value<String?> lastError = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> lastAttemptAt = const Value.absent()}) =>
      SyncQueueData(
        id: id ?? this.id,
        operation: operation ?? this.operation,
        entityTable: entityTable ?? this.entityTable,
        entityId: entityId ?? this.entityId,
        status: status ?? this.status,
        retries: retries ?? this.retries,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
        lastAttemptAt:
            lastAttemptAt.present ? lastAttemptAt.value : this.lastAttemptAt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      entityTable:
          data.entityTable.present ? data.entityTable.value : this.entityTable,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      status: data.status.present ? data.status.value : this.status,
      retries: data.retries.present ? data.retries.value : this.retries,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('status: $status, ')
          ..write('retries: $retries, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, operation, entityTable, entityId, status,
      retries, lastError, createdAt, lastAttemptAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.entityTable == this.entityTable &&
          other.entityId == this.entityId &&
          other.status == this.status &&
          other.retries == this.retries &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.lastAttemptAt == this.lastAttemptAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<SyncOperation> operation;
  final Value<String> entityTable;
  final Value<int> entityId;
  final Value<SyncStatus> status;
  final Value<int> retries;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAttemptAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.entityTable = const Value.absent(),
    this.entityId = const Value.absent(),
    this.status = const Value.absent(),
    this.retries = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required SyncOperation operation,
    required String entityTable,
    required int entityId,
    this.status = const Value.absent(),
    this.retries = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
  })  : operation = Value(operation),
        entityTable = Value(entityTable),
        entityId = Value(entityId);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<int>? operation,
    Expression<String>? entityTable,
    Expression<int>? entityId,
    Expression<int>? status,
    Expression<int>? retries,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAttemptAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (entityTable != null) 'entity_table': entityTable,
      if (entityId != null) 'entity_id': entityId,
      if (status != null) 'status': status,
      if (retries != null) 'retries': retries,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<SyncOperation>? operation,
      Value<String>? entityTable,
      Value<int>? entityId,
      Value<SyncStatus>? status,
      Value<int>? retries,
      Value<String?>? lastError,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastAttemptAt}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      entityTable: entityTable ?? this.entityTable,
      entityId: entityId ?? this.entityId,
      status: status ?? this.status,
      retries: retries ?? this.retries,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<int>(
          $SyncQueueTable.$converteroperation.toSql(operation.value));
    }
    if (entityTable.present) {
      map['entity_table'] = Variable<String>(entityTable.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (status.present) {
      map['status'] =
          Variable<int>($SyncQueueTable.$converterstatus.toSql(status.value));
    }
    if (retries.present) {
      map['retries'] = Variable<int>(retries.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('status: $status, ')
          ..write('retries: $retries, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesSearchTable extends JournalEntriesSearch
    with TableInfo<$JournalEntriesSearchTable, JournalSearchEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesSearchTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _docIdMeta = const VerificationMeta('docId');
  @override
  late final GeneratedColumn<int> docId = GeneratedColumn<int>(
      'doc_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES journal_entries(id)');
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [docId, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries_search';
  @override
  VerificationContext validateIntegrity(Insertable<JournalSearchEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('doc_id')) {
      context.handle(
          _docIdMeta, docId.isAcceptableOrUnknown(data['doc_id']!, _docIdMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {docId};
  @override
  JournalSearchEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalSearchEntry(
      docId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}doc_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
    );
  }

  @override
  $JournalEntriesSearchTable createAlias(String alias) {
    return $JournalEntriesSearchTable(attachedDatabase, alias);
  }
}

class JournalSearchEntry extends DataClass
    implements Insertable<JournalSearchEntry> {
  final int docId;
  final String content;
  const JournalSearchEntry({required this.docId, required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['doc_id'] = Variable<int>(docId);
    map['content'] = Variable<String>(content);
    return map;
  }

  JournalEntriesSearchCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesSearchCompanion(
      docId: Value(docId),
      content: Value(content),
    );
  }

  factory JournalSearchEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalSearchEntry(
      docId: serializer.fromJson<int>(json['docId']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'docId': serializer.toJson<int>(docId),
      'content': serializer.toJson<String>(content),
    };
  }

  JournalSearchEntry copyWith({int? docId, String? content}) =>
      JournalSearchEntry(
        docId: docId ?? this.docId,
        content: content ?? this.content,
      );
  JournalSearchEntry copyWithCompanion(JournalEntriesSearchCompanion data) {
    return JournalSearchEntry(
      docId: data.docId.present ? data.docId.value : this.docId,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalSearchEntry(')
          ..write('docId: $docId, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(docId, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalSearchEntry &&
          other.docId == this.docId &&
          other.content == this.content);
}

class JournalEntriesSearchCompanion
    extends UpdateCompanion<JournalSearchEntry> {
  final Value<int> docId;
  final Value<String> content;
  const JournalEntriesSearchCompanion({
    this.docId = const Value.absent(),
    this.content = const Value.absent(),
  });
  JournalEntriesSearchCompanion.insert({
    this.docId = const Value.absent(),
    required String content,
  }) : content = Value(content);
  static Insertable<JournalSearchEntry> custom({
    Expression<int>? docId,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (docId != null) 'doc_id': docId,
      if (content != null) 'content': content,
    });
  }

  JournalEntriesSearchCompanion copyWith(
      {Value<int>? docId, Value<String>? content}) {
    return JournalEntriesSearchCompanion(
      docId: docId ?? this.docId,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (docId.present) {
      map['doc_id'] = Variable<int>(docId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesSearchCompanion(')
          ..write('docId: $docId, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class $AiInteractionsTable extends AiInteractions
    with TableInfo<$AiInteractionsTable, AiInteraction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiInteractionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _verseReferenceMeta =
      const VerificationMeta('verseReference');
  @override
  late final GeneratedColumn<String> verseReference = GeneratedColumn<String>(
      'verse_reference', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _aiResponseMeta =
      const VerificationMeta('aiResponse');
  @override
  late final GeneratedColumn<String> aiResponse = GeneratedColumn<String>(
      'ai_response', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, verseReference, aiResponse, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_interactions';
  @override
  VerificationContext validateIntegrity(Insertable<AiInteraction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('verse_reference')) {
      context.handle(
          _verseReferenceMeta,
          verseReference.isAcceptableOrUnknown(
              data['verse_reference']!, _verseReferenceMeta));
    } else if (isInserting) {
      context.missing(_verseReferenceMeta);
    }
    if (data.containsKey('ai_response')) {
      context.handle(
          _aiResponseMeta,
          aiResponse.isAcceptableOrUnknown(
              data['ai_response']!, _aiResponseMeta));
    } else if (isInserting) {
      context.missing(_aiResponseMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiInteraction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiInteraction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      verseReference: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}verse_reference'])!,
      aiResponse: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ai_response'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AiInteractionsTable createAlias(String alias) {
    return $AiInteractionsTable(attachedDatabase, alias);
  }
}

class AiInteraction extends DataClass implements Insertable<AiInteraction> {
  final int id;
  final String verseReference;
  final String aiResponse;
  final DateTime createdAt;
  const AiInteraction(
      {required this.id,
      required this.verseReference,
      required this.aiResponse,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['verse_reference'] = Variable<String>(verseReference);
    map['ai_response'] = Variable<String>(aiResponse);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AiInteractionsCompanion toCompanion(bool nullToAbsent) {
    return AiInteractionsCompanion(
      id: Value(id),
      verseReference: Value(verseReference),
      aiResponse: Value(aiResponse),
      createdAt: Value(createdAt),
    );
  }

  factory AiInteraction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiInteraction(
      id: serializer.fromJson<int>(json['id']),
      verseReference: serializer.fromJson<String>(json['verseReference']),
      aiResponse: serializer.fromJson<String>(json['aiResponse']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'verseReference': serializer.toJson<String>(verseReference),
      'aiResponse': serializer.toJson<String>(aiResponse),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AiInteraction copyWith(
          {int? id,
          String? verseReference,
          String? aiResponse,
          DateTime? createdAt}) =>
      AiInteraction(
        id: id ?? this.id,
        verseReference: verseReference ?? this.verseReference,
        aiResponse: aiResponse ?? this.aiResponse,
        createdAt: createdAt ?? this.createdAt,
      );
  AiInteraction copyWithCompanion(AiInteractionsCompanion data) {
    return AiInteraction(
      id: data.id.present ? data.id.value : this.id,
      verseReference: data.verseReference.present
          ? data.verseReference.value
          : this.verseReference,
      aiResponse:
          data.aiResponse.present ? data.aiResponse.value : this.aiResponse,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiInteraction(')
          ..write('id: $id, ')
          ..write('verseReference: $verseReference, ')
          ..write('aiResponse: $aiResponse, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, verseReference, aiResponse, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiInteraction &&
          other.id == this.id &&
          other.verseReference == this.verseReference &&
          other.aiResponse == this.aiResponse &&
          other.createdAt == this.createdAt);
}

class AiInteractionsCompanion extends UpdateCompanion<AiInteraction> {
  final Value<int> id;
  final Value<String> verseReference;
  final Value<String> aiResponse;
  final Value<DateTime> createdAt;
  const AiInteractionsCompanion({
    this.id = const Value.absent(),
    this.verseReference = const Value.absent(),
    this.aiResponse = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AiInteractionsCompanion.insert({
    this.id = const Value.absent(),
    required String verseReference,
    required String aiResponse,
    required DateTime createdAt,
  })  : verseReference = Value(verseReference),
        aiResponse = Value(aiResponse),
        createdAt = Value(createdAt);
  static Insertable<AiInteraction> custom({
    Expression<int>? id,
    Expression<String>? verseReference,
    Expression<String>? aiResponse,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (verseReference != null) 'verse_reference': verseReference,
      if (aiResponse != null) 'ai_response': aiResponse,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AiInteractionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? verseReference,
      Value<String>? aiResponse,
      Value<DateTime>? createdAt}) {
    return AiInteractionsCompanion(
      id: id ?? this.id,
      verseReference: verseReference ?? this.verseReference,
      aiResponse: aiResponse ?? this.aiResponse,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (verseReference.present) {
      map['verse_reference'] = Variable<String>(verseReference.value);
    }
    if (aiResponse.present) {
      map['ai_response'] = Variable<String>(aiResponse.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiInteractionsCompanion(')
          ..write('id: $id, ')
          ..write('verseReference: $verseReference, ')
          ..write('aiResponse: $aiResponse, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $VersesTable extends Verses with TableInfo<$VersesTable, Verse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VersesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
      'book', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterMeta =
      const VerificationMeta('chapter');
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
      'chapter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
      'verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isBundledMeta =
      const VerificationMeta('isBundled');
  @override
  late final GeneratedColumn<bool> isBundled = GeneratedColumn<bool>(
      'is_bundled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_bundled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastFetchedMeta =
      const VerificationMeta('lastFetched');
  @override
  late final GeneratedColumn<DateTime> lastFetched = GeneratedColumn<DateTime>(
      'last_fetched', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, version, book, chapter, verse, content, isBundled, lastFetched];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verses';
  @override
  VerificationContext validateIntegrity(Insertable<Verse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('book')) {
      context.handle(
          _bookMeta, book.isAcceptableOrUnknown(data['book']!, _bookMeta));
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(_chapterMeta,
          chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta));
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
          _verseMeta, verse.isAcceptableOrUnknown(data['verse']!, _verseMeta));
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_bundled')) {
      context.handle(_isBundledMeta,
          isBundled.isAcceptableOrUnknown(data['is_bundled']!, _isBundledMeta));
    }
    if (data.containsKey('last_fetched')) {
      context.handle(
          _lastFetchedMeta,
          lastFetched.isAcceptableOrUnknown(
              data['last_fetched']!, _lastFetchedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {version, book, chapter, verse},
      ];
  @override
  Verse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verse(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      book: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book'])!,
      chapter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter'])!,
      verse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verse'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      isBundled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bundled'])!,
      lastFetched: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_fetched']),
    );
  }

  @override
  $VersesTable createAlias(String alias) {
    return $VersesTable(attachedDatabase, alias);
  }
}

class Verse extends DataClass implements Insertable<Verse> {
  final int id;

  /// Translation code (e.g., 'WEB', 'KJV', 'BSB', 'RV1909', 'GNBUK')
  final String version;

  /// Book name (e.g., 'Genesis', 'John')
  final String book;

  /// Chapter number (1-indexed)
  final int chapter;

  /// Verse number (1-indexed)
  final int verse;

  /// Verse text content (renamed from 'text' to avoid Drift naming conflict)
  final String content;

  /// True if bundled with app, false if fetched from API
  final bool isBundled;

  /// Timestamp when fetched from API (null for bundled)
  /// Used for 30-day expiry check on copyrighted content
  final DateTime? lastFetched;
  const Verse(
      {required this.id,
      required this.version,
      required this.book,
      required this.chapter,
      required this.verse,
      required this.content,
      required this.isBundled,
      this.lastFetched});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['version'] = Variable<String>(version);
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['content'] = Variable<String>(content);
    map['is_bundled'] = Variable<bool>(isBundled);
    if (!nullToAbsent || lastFetched != null) {
      map['last_fetched'] = Variable<DateTime>(lastFetched);
    }
    return map;
  }

  VersesCompanion toCompanion(bool nullToAbsent) {
    return VersesCompanion(
      id: Value(id),
      version: Value(version),
      book: Value(book),
      chapter: Value(chapter),
      verse: Value(verse),
      content: Value(content),
      isBundled: Value(isBundled),
      lastFetched: lastFetched == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFetched),
    );
  }

  factory Verse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verse(
      id: serializer.fromJson<int>(json['id']),
      version: serializer.fromJson<String>(json['version']),
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      content: serializer.fromJson<String>(json['content']),
      isBundled: serializer.fromJson<bool>(json['isBundled']),
      lastFetched: serializer.fromJson<DateTime?>(json['lastFetched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'version': serializer.toJson<String>(version),
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'content': serializer.toJson<String>(content),
      'isBundled': serializer.toJson<bool>(isBundled),
      'lastFetched': serializer.toJson<DateTime?>(lastFetched),
    };
  }

  Verse copyWith(
          {int? id,
          String? version,
          String? book,
          int? chapter,
          int? verse,
          String? content,
          bool? isBundled,
          Value<DateTime?> lastFetched = const Value.absent()}) =>
      Verse(
        id: id ?? this.id,
        version: version ?? this.version,
        book: book ?? this.book,
        chapter: chapter ?? this.chapter,
        verse: verse ?? this.verse,
        content: content ?? this.content,
        isBundled: isBundled ?? this.isBundled,
        lastFetched: lastFetched.present ? lastFetched.value : this.lastFetched,
      );
  Verse copyWithCompanion(VersesCompanion data) {
    return Verse(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      content: data.content.present ? data.content.value : this.content,
      isBundled: data.isBundled.present ? data.isBundled.value : this.isBundled,
      lastFetched:
          data.lastFetched.present ? data.lastFetched.value : this.lastFetched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verse(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('content: $content, ')
          ..write('isBundled: $isBundled, ')
          ..write('lastFetched: $lastFetched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, version, book, chapter, verse, content, isBundled, lastFetched);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verse &&
          other.id == this.id &&
          other.version == this.version &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.content == this.content &&
          other.isBundled == this.isBundled &&
          other.lastFetched == this.lastFetched);
}

class VersesCompanion extends UpdateCompanion<Verse> {
  final Value<int> id;
  final Value<String> version;
  final Value<String> book;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> content;
  final Value<bool> isBundled;
  final Value<DateTime?> lastFetched;
  const VersesCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.content = const Value.absent(),
    this.isBundled = const Value.absent(),
    this.lastFetched = const Value.absent(),
  });
  VersesCompanion.insert({
    this.id = const Value.absent(),
    required String version,
    required String book,
    required int chapter,
    required int verse,
    required String content,
    this.isBundled = const Value.absent(),
    this.lastFetched = const Value.absent(),
  })  : version = Value(version),
        book = Value(book),
        chapter = Value(chapter),
        verse = Value(verse),
        content = Value(content);
  static Insertable<Verse> custom({
    Expression<int>? id,
    Expression<String>? version,
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? content,
    Expression<bool>? isBundled,
    Expression<DateTime>? lastFetched,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (content != null) 'content': content,
      if (isBundled != null) 'is_bundled': isBundled,
      if (lastFetched != null) 'last_fetched': lastFetched,
    });
  }

  VersesCompanion copyWith(
      {Value<int>? id,
      Value<String>? version,
      Value<String>? book,
      Value<int>? chapter,
      Value<int>? verse,
      Value<String>? content,
      Value<bool>? isBundled,
      Value<DateTime?>? lastFetched}) {
    return VersesCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      content: content ?? this.content,
      isBundled: isBundled ?? this.isBundled,
      lastFetched: lastFetched ?? this.lastFetched,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isBundled.present) {
      map['is_bundled'] = Variable<bool>(isBundled.value);
    }
    if (lastFetched.present) {
      map['last_fetched'] = Variable<DateTime>(lastFetched.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersesCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('content: $content, ')
          ..write('isBundled: $isBundled, ')
          ..write('lastFetched: $lastFetched')
          ..write(')'))
        .toString();
  }
}

class $ApiCacheTable extends ApiCache
    with TableInfo<$ApiCacheTable, ApiCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApiCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cacheKeyMeta =
      const VerificationMeta('cacheKey');
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
      'cache_key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, cacheKey, content, fetchedAt, metadata];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'api_cache';
  @override
  VerificationContext validateIntegrity(Insertable<ApiCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cache_key')) {
      context.handle(_cacheKeyMeta,
          cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta));
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ApiCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApiCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cacheKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cache_key'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
    );
  }

  @override
  $ApiCacheTable createAlias(String alias) {
    return $ApiCacheTable(attachedDatabase, alias);
  }
}

class ApiCacheData extends DataClass implements Insertable<ApiCacheData> {
  final int id;

  /// Unique cache key format: 'VERSION:BOOK.CHAPTER.VERSE' (e.g., 'GNBUK:GEN.1.1')
  final String cacheKey;

  /// Cached content (verse text or passage)
  final String content;

  /// When this content was fetched from API
  final DateTime fetchedAt;

  /// Optional: API response metadata (JSON)
  final String? metadata;
  const ApiCacheData(
      {required this.id,
      required this.cacheKey,
      required this.content,
      required this.fetchedAt,
      this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cache_key'] = Variable<String>(cacheKey);
    map['content'] = Variable<String>(content);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  ApiCacheCompanion toCompanion(bool nullToAbsent) {
    return ApiCacheCompanion(
      id: Value(id),
      cacheKey: Value(cacheKey),
      content: Value(content),
      fetchedAt: Value(fetchedAt),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory ApiCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApiCacheData(
      id: serializer.fromJson<int>(json['id']),
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      content: serializer.fromJson<String>(json['content']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cacheKey': serializer.toJson<String>(cacheKey),
      'content': serializer.toJson<String>(content),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  ApiCacheData copyWith(
          {int? id,
          String? cacheKey,
          String? content,
          DateTime? fetchedAt,
          Value<String?> metadata = const Value.absent()}) =>
      ApiCacheData(
        id: id ?? this.id,
        cacheKey: cacheKey ?? this.cacheKey,
        content: content ?? this.content,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        metadata: metadata.present ? metadata.value : this.metadata,
      );
  ApiCacheData copyWithCompanion(ApiCacheCompanion data) {
    return ApiCacheData(
      id: data.id.present ? data.id.value : this.id,
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      content: data.content.present ? data.content.value : this.content,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApiCacheData(')
          ..write('id: $id, ')
          ..write('cacheKey: $cacheKey, ')
          ..write('content: $content, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cacheKey, content, fetchedAt, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApiCacheData &&
          other.id == this.id &&
          other.cacheKey == this.cacheKey &&
          other.content == this.content &&
          other.fetchedAt == this.fetchedAt &&
          other.metadata == this.metadata);
}

class ApiCacheCompanion extends UpdateCompanion<ApiCacheData> {
  final Value<int> id;
  final Value<String> cacheKey;
  final Value<String> content;
  final Value<DateTime> fetchedAt;
  final Value<String?> metadata;
  const ApiCacheCompanion({
    this.id = const Value.absent(),
    this.cacheKey = const Value.absent(),
    this.content = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.metadata = const Value.absent(),
  });
  ApiCacheCompanion.insert({
    this.id = const Value.absent(),
    required String cacheKey,
    required String content,
    required DateTime fetchedAt,
    this.metadata = const Value.absent(),
  })  : cacheKey = Value(cacheKey),
        content = Value(content),
        fetchedAt = Value(fetchedAt);
  static Insertable<ApiCacheData> custom({
    Expression<int>? id,
    Expression<String>? cacheKey,
    Expression<String>? content,
    Expression<DateTime>? fetchedAt,
    Expression<String>? metadata,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cacheKey != null) 'cache_key': cacheKey,
      if (content != null) 'content': content,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (metadata != null) 'metadata': metadata,
    });
  }

  ApiCacheCompanion copyWith(
      {Value<int>? id,
      Value<String>? cacheKey,
      Value<String>? content,
      Value<DateTime>? fetchedAt,
      Value<String?>? metadata}) {
    return ApiCacheCompanion(
      id: id ?? this.id,
      cacheKey: cacheKey ?? this.cacheKey,
      content: content ?? this.content,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApiCacheCompanion(')
          ..write('id: $id, ')
          ..write('cacheKey: $cacheKey, ')
          ..write('content: $content, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $JournalEntriesSearchTable journalEntriesSearch =
      $JournalEntriesSearchTable(this);
  late final $AiInteractionsTable aiInteractions = $AiInteractionsTable(this);
  late final $VersesTable verses = $VersesTable(this);
  late final $ApiCacheTable apiCache = $ApiCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        journalEntries,
        syncQueue,
        journalEntriesSearch,
        aiInteractions,
        verses,
        apiCache
      ];
}

typedef $$JournalEntriesTableCreateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  Value<String?> verseReference,
  required String content,
  Value<String?> emotionTag,
  Value<bool> aiAccessEnabled,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> lookForwardNotes,
});
typedef $$JournalEntriesTableUpdateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  Value<String?> verseReference,
  Value<String> content,
  Value<String?> emotionTag,
  Value<bool> aiAccessEnabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> lookForwardNotes,
});

final class $$JournalEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry> {
  $$JournalEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JournalEntriesSearchTable,
      List<JournalSearchEntry>> _journalEntriesSearchRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.journalEntriesSearch,
          aliasName: $_aliasNameGenerator(
              db.journalEntries.id, db.journalEntriesSearch.docId));

  $$JournalEntriesSearchTableProcessedTableManager
      get journalEntriesSearchRefs {
    final manager =
        $$JournalEntriesSearchTableTableManager($_db, $_db.journalEntriesSearch)
            .filter((f) => f.docId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_journalEntriesSearchRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verseReference => $composableBuilder(
      column: $table.verseReference,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emotionTag => $composableBuilder(
      column: $table.emotionTag, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get aiAccessEnabled => $composableBuilder(
      column: $table.aiAccessEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lookForwardNotes => $composableBuilder(
      column: $table.lookForwardNotes,
      builder: (column) => ColumnFilters(column));

  Expression<bool> journalEntriesSearchRefs(
      Expression<bool> Function($$JournalEntriesSearchTableFilterComposer f)
          f) {
    final $$JournalEntriesSearchTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.journalEntriesSearch,
        getReferencedColumn: (t) => t.docId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntriesSearchTableFilterComposer(
              $db: $db,
              $table: $db.journalEntriesSearch,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verseReference => $composableBuilder(
      column: $table.verseReference,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emotionTag => $composableBuilder(
      column: $table.emotionTag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get aiAccessEnabled => $composableBuilder(
      column: $table.aiAccessEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lookForwardNotes => $composableBuilder(
      column: $table.lookForwardNotes,
      builder: (column) => ColumnOrderings(column));
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get verseReference => $composableBuilder(
      column: $table.verseReference, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get emotionTag => $composableBuilder(
      column: $table.emotionTag, builder: (column) => column);

  GeneratedColumn<bool> get aiAccessEnabled => $composableBuilder(
      column: $table.aiAccessEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get lookForwardNotes => $composableBuilder(
      column: $table.lookForwardNotes, builder: (column) => column);

  Expression<T> journalEntriesSearchRefs<T extends Object>(
      Expression<T> Function($$JournalEntriesSearchTableAnnotationComposer a)
          f) {
    final $$JournalEntriesSearchTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.journalEntriesSearch,
            getReferencedColumn: (t) => t.docId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JournalEntriesSearchTableAnnotationComposer(
                  $db: $db,
                  $table: $db.journalEntriesSearch,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$JournalEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntry,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (JournalEntry, $$JournalEntriesTableReferences),
    JournalEntry,
    PrefetchHooks Function({bool journalEntriesSearchRefs})> {
  $$JournalEntriesTableTableManager(
      _$AppDatabase db, $JournalEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> verseReference = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> emotionTag = const Value.absent(),
            Value<bool> aiAccessEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String?> lookForwardNotes = const Value.absent(),
          }) =>
              JournalEntriesCompanion(
            id: id,
            verseReference: verseReference,
            content: content,
            emotionTag: emotionTag,
            aiAccessEnabled: aiAccessEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lookForwardNotes: lookForwardNotes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> verseReference = const Value.absent(),
            required String content,
            Value<String?> emotionTag = const Value.absent(),
            Value<bool> aiAccessEnabled = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String?> lookForwardNotes = const Value.absent(),
          }) =>
              JournalEntriesCompanion.insert(
            id: id,
            verseReference: verseReference,
            content: content,
            emotionTag: emotionTag,
            aiAccessEnabled: aiAccessEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lookForwardNotes: lookForwardNotes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$JournalEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({journalEntriesSearchRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (journalEntriesSearchRefs) db.journalEntriesSearch
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journalEntriesSearchRefs)
                    await $_getPrefetchedData<JournalEntry,
                            $JournalEntriesTable, JournalSearchEntry>(
                        currentTable: table,
                        referencedTable: $$JournalEntriesTableReferences
                            ._journalEntriesSearchRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$JournalEntriesTableReferences(db, table, p0)
                                .journalEntriesSearchRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.docId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$JournalEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntry,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (JournalEntry, $$JournalEntriesTableReferences),
    JournalEntry,
    PrefetchHooks Function({bool journalEntriesSearchRefs})>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required SyncOperation operation,
  required String entityTable,
  required int entityId,
  Value<SyncStatus> status,
  Value<int> retries,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime?> lastAttemptAt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<SyncOperation> operation,
  Value<String> entityTable,
  Value<int> entityId,
  Value<SyncStatus> status,
  Value<int> retries,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime?> lastAttemptAt,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SyncOperation, SyncOperation, int>
      get operation => $composableBuilder(
          column: $table.operation,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get entityTable => $composableBuilder(
      column: $table.entityTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, int> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get retries => $composableBuilder(
      column: $table.retries, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityTable => $composableBuilder(
      column: $table.entityTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retries => $composableBuilder(
      column: $table.retries, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncOperation, int> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get entityTable => $composableBuilder(
      column: $table.entityTable, builder: (column) => column);

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retries =>
      $composableBuilder(column: $table.retries, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<SyncOperation> operation = const Value.absent(),
            Value<String> entityTable = const Value.absent(),
            Value<int> entityId = const Value.absent(),
            Value<SyncStatus> status = const Value.absent(),
            Value<int> retries = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            operation: operation,
            entityTable: entityTable,
            entityId: entityId,
            status: status,
            retries: retries,
            lastError: lastError,
            createdAt: createdAt,
            lastAttemptAt: lastAttemptAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required SyncOperation operation,
            required String entityTable,
            required int entityId,
            Value<SyncStatus> status = const Value.absent(),
            Value<int> retries = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            operation: operation,
            entityTable: entityTable,
            entityId: entityId,
            status: status,
            retries: retries,
            lastError: lastError,
            createdAt: createdAt,
            lastAttemptAt: lastAttemptAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;
typedef $$JournalEntriesSearchTableCreateCompanionBuilder
    = JournalEntriesSearchCompanion Function({
  Value<int> docId,
  required String content,
});
typedef $$JournalEntriesSearchTableUpdateCompanionBuilder
    = JournalEntriesSearchCompanion Function({
  Value<int> docId,
  Value<String> content,
});

final class $$JournalEntriesSearchTableReferences extends BaseReferences<
    _$AppDatabase, $JournalEntriesSearchTable, JournalSearchEntry> {
  $$JournalEntriesSearchTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $JournalEntriesTable _docIdTable(_$AppDatabase db) =>
      db.journalEntries.createAlias($_aliasNameGenerator(
          db.journalEntriesSearch.docId, db.journalEntries.id));

  $$JournalEntriesTableProcessedTableManager get docId {
    final $_column = $_itemColumn<int>('doc_id')!;

    final manager = $$JournalEntriesTableTableManager($_db, $_db.journalEntries)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_docIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$JournalEntriesSearchTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesSearchTable> {
  $$JournalEntriesSearchTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  $$JournalEntriesTableFilterComposer get docId {
    final $$JournalEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.docId,
        referencedTable: $db.journalEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntriesTableFilterComposer(
              $db: $db,
              $table: $db.journalEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JournalEntriesSearchTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesSearchTable> {
  $$JournalEntriesSearchTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  $$JournalEntriesTableOrderingComposer get docId {
    final $$JournalEntriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.docId,
        referencedTable: $db.journalEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntriesTableOrderingComposer(
              $db: $db,
              $table: $db.journalEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JournalEntriesSearchTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesSearchTable> {
  $$JournalEntriesSearchTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  $$JournalEntriesTableAnnotationComposer get docId {
    final $$JournalEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.docId,
        referencedTable: $db.journalEntries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JournalEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.journalEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JournalEntriesSearchTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JournalEntriesSearchTable,
    JournalSearchEntry,
    $$JournalEntriesSearchTableFilterComposer,
    $$JournalEntriesSearchTableOrderingComposer,
    $$JournalEntriesSearchTableAnnotationComposer,
    $$JournalEntriesSearchTableCreateCompanionBuilder,
    $$JournalEntriesSearchTableUpdateCompanionBuilder,
    (JournalSearchEntry, $$JournalEntriesSearchTableReferences),
    JournalSearchEntry,
    PrefetchHooks Function({bool docId})> {
  $$JournalEntriesSearchTableTableManager(
      _$AppDatabase db, $JournalEntriesSearchTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesSearchTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesSearchTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesSearchTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> docId = const Value.absent(),
            Value<String> content = const Value.absent(),
          }) =>
              JournalEntriesSearchCompanion(
            docId: docId,
            content: content,
          ),
          createCompanionCallback: ({
            Value<int> docId = const Value.absent(),
            required String content,
          }) =>
              JournalEntriesSearchCompanion.insert(
            docId: docId,
            content: content,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$JournalEntriesSearchTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({docId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (docId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.docId,
                    referencedTable:
                        $$JournalEntriesSearchTableReferences._docIdTable(db),
                    referencedColumn: $$JournalEntriesSearchTableReferences
                        ._docIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$JournalEntriesSearchTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $JournalEntriesSearchTable,
        JournalSearchEntry,
        $$JournalEntriesSearchTableFilterComposer,
        $$JournalEntriesSearchTableOrderingComposer,
        $$JournalEntriesSearchTableAnnotationComposer,
        $$JournalEntriesSearchTableCreateCompanionBuilder,
        $$JournalEntriesSearchTableUpdateCompanionBuilder,
        (JournalSearchEntry, $$JournalEntriesSearchTableReferences),
        JournalSearchEntry,
        PrefetchHooks Function({bool docId})>;
typedef $$AiInteractionsTableCreateCompanionBuilder = AiInteractionsCompanion
    Function({
  Value<int> id,
  required String verseReference,
  required String aiResponse,
  required DateTime createdAt,
});
typedef $$AiInteractionsTableUpdateCompanionBuilder = AiInteractionsCompanion
    Function({
  Value<int> id,
  Value<String> verseReference,
  Value<String> aiResponse,
  Value<DateTime> createdAt,
});

class $$AiInteractionsTableFilterComposer
    extends Composer<_$AppDatabase, $AiInteractionsTable> {
  $$AiInteractionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verseReference => $composableBuilder(
      column: $table.verseReference,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get aiResponse => $composableBuilder(
      column: $table.aiResponse, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AiInteractionsTableOrderingComposer
    extends Composer<_$AppDatabase, $AiInteractionsTable> {
  $$AiInteractionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verseReference => $composableBuilder(
      column: $table.verseReference,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get aiResponse => $composableBuilder(
      column: $table.aiResponse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AiInteractionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiInteractionsTable> {
  $$AiInteractionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get verseReference => $composableBuilder(
      column: $table.verseReference, builder: (column) => column);

  GeneratedColumn<String> get aiResponse => $composableBuilder(
      column: $table.aiResponse, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AiInteractionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AiInteractionsTable,
    AiInteraction,
    $$AiInteractionsTableFilterComposer,
    $$AiInteractionsTableOrderingComposer,
    $$AiInteractionsTableAnnotationComposer,
    $$AiInteractionsTableCreateCompanionBuilder,
    $$AiInteractionsTableUpdateCompanionBuilder,
    (
      AiInteraction,
      BaseReferences<_$AppDatabase, $AiInteractionsTable, AiInteraction>
    ),
    AiInteraction,
    PrefetchHooks Function()> {
  $$AiInteractionsTableTableManager(
      _$AppDatabase db, $AiInteractionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiInteractionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiInteractionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiInteractionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> verseReference = const Value.absent(),
            Value<String> aiResponse = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AiInteractionsCompanion(
            id: id,
            verseReference: verseReference,
            aiResponse: aiResponse,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String verseReference,
            required String aiResponse,
            required DateTime createdAt,
          }) =>
              AiInteractionsCompanion.insert(
            id: id,
            verseReference: verseReference,
            aiResponse: aiResponse,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AiInteractionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AiInteractionsTable,
    AiInteraction,
    $$AiInteractionsTableFilterComposer,
    $$AiInteractionsTableOrderingComposer,
    $$AiInteractionsTableAnnotationComposer,
    $$AiInteractionsTableCreateCompanionBuilder,
    $$AiInteractionsTableUpdateCompanionBuilder,
    (
      AiInteraction,
      BaseReferences<_$AppDatabase, $AiInteractionsTable, AiInteraction>
    ),
    AiInteraction,
    PrefetchHooks Function()>;
typedef $$VersesTableCreateCompanionBuilder = VersesCompanion Function({
  Value<int> id,
  required String version,
  required String book,
  required int chapter,
  required int verse,
  required String content,
  Value<bool> isBundled,
  Value<DateTime?> lastFetched,
});
typedef $$VersesTableUpdateCompanionBuilder = VersesCompanion Function({
  Value<int> id,
  Value<String> version,
  Value<String> book,
  Value<int> chapter,
  Value<int> verse,
  Value<String> content,
  Value<bool> isBundled,
  Value<DateTime?> lastFetched,
});

class $$VersesTableFilterComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get book => $composableBuilder(
      column: $table.book, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBundled => $composableBuilder(
      column: $table.isBundled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastFetched => $composableBuilder(
      column: $table.lastFetched, builder: (column) => ColumnFilters(column));
}

class $$VersesTableOrderingComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get book => $composableBuilder(
      column: $table.book, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBundled => $composableBuilder(
      column: $table.isBundled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastFetched => $composableBuilder(
      column: $table.lastFetched, builder: (column) => ColumnOrderings(column));
}

class $$VersesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isBundled =>
      $composableBuilder(column: $table.isBundled, builder: (column) => column);

  GeneratedColumn<DateTime> get lastFetched => $composableBuilder(
      column: $table.lastFetched, builder: (column) => column);
}

class $$VersesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VersesTable,
    Verse,
    $$VersesTableFilterComposer,
    $$VersesTableOrderingComposer,
    $$VersesTableAnnotationComposer,
    $$VersesTableCreateCompanionBuilder,
    $$VersesTableUpdateCompanionBuilder,
    (Verse, BaseReferences<_$AppDatabase, $VersesTable, Verse>),
    Verse,
    PrefetchHooks Function()> {
  $$VersesTableTableManager(_$AppDatabase db, $VersesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> version = const Value.absent(),
            Value<String> book = const Value.absent(),
            Value<int> chapter = const Value.absent(),
            Value<int> verse = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<bool> isBundled = const Value.absent(),
            Value<DateTime?> lastFetched = const Value.absent(),
          }) =>
              VersesCompanion(
            id: id,
            version: version,
            book: book,
            chapter: chapter,
            verse: verse,
            content: content,
            isBundled: isBundled,
            lastFetched: lastFetched,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String version,
            required String book,
            required int chapter,
            required int verse,
            required String content,
            Value<bool> isBundled = const Value.absent(),
            Value<DateTime?> lastFetched = const Value.absent(),
          }) =>
              VersesCompanion.insert(
            id: id,
            version: version,
            book: book,
            chapter: chapter,
            verse: verse,
            content: content,
            isBundled: isBundled,
            lastFetched: lastFetched,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VersesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VersesTable,
    Verse,
    $$VersesTableFilterComposer,
    $$VersesTableOrderingComposer,
    $$VersesTableAnnotationComposer,
    $$VersesTableCreateCompanionBuilder,
    $$VersesTableUpdateCompanionBuilder,
    (Verse, BaseReferences<_$AppDatabase, $VersesTable, Verse>),
    Verse,
    PrefetchHooks Function()>;
typedef $$ApiCacheTableCreateCompanionBuilder = ApiCacheCompanion Function({
  Value<int> id,
  required String cacheKey,
  required String content,
  required DateTime fetchedAt,
  Value<String?> metadata,
});
typedef $$ApiCacheTableUpdateCompanionBuilder = ApiCacheCompanion Function({
  Value<int> id,
  Value<String> cacheKey,
  Value<String> content,
  Value<DateTime> fetchedAt,
  Value<String?> metadata,
});

class $$ApiCacheTableFilterComposer
    extends Composer<_$AppDatabase, $ApiCacheTable> {
  $$ApiCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cacheKey => $composableBuilder(
      column: $table.cacheKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));
}

class $$ApiCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $ApiCacheTable> {
  $$ApiCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cacheKey => $composableBuilder(
      column: $table.cacheKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));
}

class $$ApiCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApiCacheTable> {
  $$ApiCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$ApiCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ApiCacheTable,
    ApiCacheData,
    $$ApiCacheTableFilterComposer,
    $$ApiCacheTableOrderingComposer,
    $$ApiCacheTableAnnotationComposer,
    $$ApiCacheTableCreateCompanionBuilder,
    $$ApiCacheTableUpdateCompanionBuilder,
    (ApiCacheData, BaseReferences<_$AppDatabase, $ApiCacheTable, ApiCacheData>),
    ApiCacheData,
    PrefetchHooks Function()> {
  $$ApiCacheTableTableManager(_$AppDatabase db, $ApiCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApiCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApiCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApiCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> cacheKey = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
          }) =>
              ApiCacheCompanion(
            id: id,
            cacheKey: cacheKey,
            content: content,
            fetchedAt: fetchedAt,
            metadata: metadata,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String cacheKey,
            required String content,
            required DateTime fetchedAt,
            Value<String?> metadata = const Value.absent(),
          }) =>
              ApiCacheCompanion.insert(
            id: id,
            cacheKey: cacheKey,
            content: content,
            fetchedAt: fetchedAt,
            metadata: metadata,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ApiCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ApiCacheTable,
    ApiCacheData,
    $$ApiCacheTableFilterComposer,
    $$ApiCacheTableOrderingComposer,
    $$ApiCacheTableAnnotationComposer,
    $$ApiCacheTableCreateCompanionBuilder,
    $$ApiCacheTableUpdateCompanionBuilder,
    (ApiCacheData, BaseReferences<_$AppDatabase, $ApiCacheTable, ApiCacheData>),
    ApiCacheData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$JournalEntriesSearchTableTableManager get journalEntriesSearch =>
      $$JournalEntriesSearchTableTableManager(_db, _db.journalEntriesSearch);
  $$AiInteractionsTableTableManager get aiInteractions =>
      $$AiInteractionsTableTableManager(_db, _db.aiInteractions);
  $$VersesTableTableManager get verses =>
      $$VersesTableTableManager(_db, _db.verses);
  $$ApiCacheTableTableManager get apiCache =>
      $$ApiCacheTableTableManager(_db, _db.apiCache);
}
