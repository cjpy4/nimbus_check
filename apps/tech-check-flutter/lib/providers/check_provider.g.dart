// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkHash() => r'30cfbbbb02cbf2f824f9576b3711d271808dfac2';

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

/// See also [check].
@ProviderFor(check)
const checkProvider = CheckFamily();

/// See also [check].
class CheckFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [check].
  const CheckFamily();

  /// See also [check].
  CheckProvider call(String imei, ServiceType service) {
    return CheckProvider(imei, service);
  }

  @override
  CheckProvider getProviderOverride(covariant CheckProvider provider) {
    return call(provider.imei, provider.service);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'checkProvider';
}

/// See also [check].
class CheckProvider extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [check].
  CheckProvider(String imei, ServiceType service)
    : this._internal(
        (ref) => check(ref as CheckRef, imei, service),
        from: checkProvider,
        name: r'checkProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$checkHash,
        dependencies: CheckFamily._dependencies,
        allTransitiveDependencies: CheckFamily._allTransitiveDependencies,
        imei: imei,
        service: service,
      );

  CheckProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.imei,
    required this.service,
  }) : super.internal();

  final String imei;
  final ServiceType service;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(CheckRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CheckProvider._internal(
        (ref) => create(ref as CheckRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        imei: imei,
        service: service,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _CheckProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckProvider &&
        other.imei == imei &&
        other.service == service;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, imei.hashCode);
    hash = _SystemHash.combine(hash, service.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CheckRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `imei` of this provider.
  String get imei;

  /// The parameter `service` of this provider.
  ServiceType get service;
}

class _CheckProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with CheckRef {
  _CheckProviderElement(super.provider);

  @override
  String get imei => (origin as CheckProvider).imei;
  @override
  ServiceType get service => (origin as CheckProvider).service;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
