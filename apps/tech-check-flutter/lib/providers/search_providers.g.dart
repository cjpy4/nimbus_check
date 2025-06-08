// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchHistoryHash() => r'd784a0b3eacf14d4a84854faf55f6adaf804b0c4';

/// See also [searchHistory].
@ProviderFor(searchHistory)
final searchHistoryProvider =
    AutoDisposeStreamProvider<List<Map<String, dynamic>>>.internal(
      searchHistory,
      name: r'searchHistoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchHistoryRef =
    AutoDisposeStreamProviderRef<List<Map<String, dynamic>>>;
String _$currentSearchHash() => r'08a7d63265d4fb77c772c7eef6d939980386c917';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [currentSearch].
@ProviderFor(currentSearch)
const currentSearchProvider = CurrentSearchFamily();

/// See also [currentSearch].
class CurrentSearchFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [currentSearch].
  const CurrentSearchFamily();

  /// See also [currentSearch].
  CurrentSearchProvider call(dynamic docId) {
    return CurrentSearchProvider(docId);
  }

  @override
  CurrentSearchProvider getProviderOverride(
    covariant CurrentSearchProvider provider,
  ) {
    return call(provider.docId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'currentSearchProvider';
}

/// See also [currentSearch].
class CurrentSearchProvider
    extends AutoDisposeStreamProvider<Map<String, dynamic>> {
  /// See also [currentSearch].
  CurrentSearchProvider(dynamic docId)
    : this._internal(
        (ref) => currentSearch(ref as CurrentSearchRef, docId),
        from: currentSearchProvider,
        name: r'currentSearchProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$currentSearchHash,
        dependencies: CurrentSearchFamily._dependencies,
        allTransitiveDependencies:
            CurrentSearchFamily._allTransitiveDependencies,
        docId: docId,
      );

  CurrentSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.docId,
  }) : super.internal();

  final dynamic docId;

  @override
  Override overrideWith(
    Stream<Map<String, dynamic>> Function(CurrentSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentSearchProvider._internal(
        (ref) => create(ref as CurrentSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        docId: docId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Map<String, dynamic>> createElement() {
    return _CurrentSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentSearchProvider && other.docId == docId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, docId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentSearchRef on AutoDisposeStreamProviderRef<Map<String, dynamic>> {
  /// The parameter `docId` of this provider.
  dynamic get docId;
}

class _CurrentSearchProviderElement
    extends AutoDisposeStreamProviderElement<Map<String, dynamic>>
    with CurrentSearchRef {
  _CurrentSearchProviderElement(super.provider);

  @override
  dynamic get docId => (origin as CurrentSearchProvider).docId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
