// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thumbnail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String $thumbnailHash() => r'd8511f69933202c0d7de7ebd9e35334583f9c9b4';

/// See also [thumbnail].
class ThumbnailProvider
    extends AutoDisposeFutureProvider<ImageWithAspectRatio> {
  ThumbnailProvider(
    this.request,
  ) : super(
          (ref) => thumbnail(
            ref,
            request,
          ),
          from: thumbnailProvider,
          name: r'thumbnailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $thumbnailHash,
        );

  final ThumbnailRequest request;

  @override
  bool operator ==(Object other) {
    return other is ThumbnailProvider && other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef ThumbnailRef = AutoDisposeFutureProviderRef<ImageWithAspectRatio>;

/// See also [thumbnail].
final thumbnailProvider = ThumbnailFamily();

class ThumbnailFamily extends Family<AsyncValue<ImageWithAspectRatio>> {
  ThumbnailFamily();

  ThumbnailProvider call(
    ThumbnailRequest request,
  ) {
    return ThumbnailProvider(
      request,
    );
  }

  @override
  AutoDisposeFutureProvider<ImageWithAspectRatio> getProviderOverride(
    covariant ThumbnailProvider provider,
  ) {
    return call(
      provider.request,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'thumbnailProvider';
}
