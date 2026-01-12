// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'68c9ad772c198d1a34d2dcccc0a6a35f43092fd5';

/// Provides the app database instance
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = AutoDisposeProviderRef<AppDatabase>;
String _$journalRepositoryHash() => r'3baac219df16177887f6da53d956a50eb039f4c9';

/// Provides the journal repository
///
/// Copied from [journalRepository].
@ProviderFor(journalRepository)
final journalRepositoryProvider =
    AutoDisposeProvider<JournalRepository>.internal(
  journalRepository,
  name: r'journalRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JournalRepositoryRef = AutoDisposeProviderRef<JournalRepository>;
String _$journalEntriesHash() => r'827f93d4ba74de581183f1e3480f3118aaf6dd81';

/// Stream of all journal entries (reactive)
///
/// Copied from [journalEntries].
@ProviderFor(journalEntries)
final journalEntriesProvider =
    AutoDisposeStreamProvider<List<JournalEntry>>.internal(
  journalEntries,
  name: r'journalEntriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalEntriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JournalEntriesRef = AutoDisposeStreamProviderRef<List<JournalEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
