// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_reader_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentPassageHash() => r'4d5d275cf45d6a7bfaaf91be885228cdf66d5590';

/// See also [currentPassage].
@ProviderFor(currentPassage)
final currentPassageProvider = AutoDisposeFutureProvider<BiblePassage>.internal(
  currentPassage,
  name: r'currentPassageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentPassageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentPassageRef = AutoDisposeFutureProviderRef<BiblePassage>;
String _$reflectedVersesHash() => r'3d4943d08978d231b696a3ac3b536c0316b4ae42';

/// Provider for verse references that have journal entries attached
/// Returns a Set<String> of verse reference strings (e.g., "John 1:1")
///
/// Copied from [reflectedVerses].
@ProviderFor(reflectedVerses)
final reflectedVersesProvider = AutoDisposeStreamProvider<Set<String>>.internal(
  reflectedVerses,
  name: r'reflectedVersesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reflectedVersesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReflectedVersesRef = AutoDisposeStreamProviderRef<Set<String>>;
String _$bibleReaderStateHash() => r'e1afef4566c7cddac1244658838e6312a3696dd4';

/// See also [BibleReaderState].
@ProviderFor(BibleReaderState)
final bibleReaderStateProvider = AutoDisposeNotifierProvider<BibleReaderState,
    BibleReaderStateModel>.internal(
  BibleReaderState.new,
  name: r'bibleReaderStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bibleReaderStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BibleReaderState = AutoDisposeNotifier<BibleReaderStateModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
