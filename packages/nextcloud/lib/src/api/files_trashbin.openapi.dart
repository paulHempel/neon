// Use of this source code is governed by a agpl license. It can be obtained at `https://spdx.org/licenses/AGPL-3.0-only.html`.

// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, cascade_invocations
// ignore_for_file: discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case

/// files_trashbin Version: 0.0.1.
///
/// This application enables people to restore files that were deleted from the system.
///
/// Use of this source code is governed by a agpl license.
/// It can be obtained at `https://spdx.org/licenses/AGPL-3.0-only.html`.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i6;
import 'package:collection/collection.dart';
import 'package:dynamite_runtime/built_value.dart' as _i5;
import 'package:dynamite_runtime/http_client.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:meta/meta.dart' as _i2;
import 'package:uri/uri.dart' as _i4;

part 'files_trashbin.openapi.g.dart';

class $Client extends _i1.DynamiteClient {
  /// Creates a new `DynamiteClient` for untagged requests.
  $Client(
    super.baseURL, {
    super.httpClient,
    super.authentications,
  });

  /// Creates a new [$Client] from another [client].
  $Client.fromClient(_i1.DynamiteClient client)
      : super(
          client.baseURL,
          httpClient: client.httpClient,
          authentications: client.authentications,
        );

  late final $PreviewClient preview = $PreviewClient(this);
}

class $PreviewClient {
  /// Creates a new `DynamiteClient` for preview requests.
  $PreviewClient(this._rootClient);

  final $Client _rootClient;

  /// Builds a serializer to parse the response of [$getPreview_Request].
  @_i2.experimental
  _i1.DynamiteSerializer<Uint8List, void> $getPreview_Serializer() => _i1.DynamiteSerializer(
        bodyType: const FullType(Uint8List),
        headersType: null,
        serializers: _$jsonSerializers,
        validStatuses: const {200},
      );

  /// Get the preview for a file.
  ///
  /// Returns a `DynamiteRequest` backing the [getPreview] operation.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [fileId] ID of the file. Defaults to `-1`.
  ///   * [x] Width of the preview. Defaults to `32`.
  ///   * [y] Height of the preview. Defaults to `32`.
  ///   * [a] Whether to not crop the preview. Defaults to `0`.
  ///
  /// Status codes:
  ///   * 200: Preview returned
  ///   * 400: Getting preview is not possible
  ///   * 404: Preview not found
  ///
  /// See:
  ///  * [getPreview] for a method executing this request and parsing the response.
  ///  * [$getPreview_Serializer] for a converter to parse the `Response` from an executed this request.
  @_i2.experimental
  _i3.Request $getPreview_Request({
    int? fileId,
    int? x,
    int? y,
    PreviewGetPreviewA? a,
  }) {
    final _parameters = <String, Object?>{};
    var $fileId = _$jsonSerializers.serialize(fileId, specifiedType: const FullType(int));
    $fileId ??= -1;
    _parameters['fileId'] = $fileId;

    var $x = _$jsonSerializers.serialize(x, specifiedType: const FullType(int));
    $x ??= 32;
    _parameters['x'] = $x;

    var $y = _$jsonSerializers.serialize(y, specifiedType: const FullType(int));
    $y ??= 32;
    _parameters['y'] = $y;

    var $a = _$jsonSerializers.serialize(a, specifiedType: const FullType(PreviewGetPreviewA));
    $a ??= 0;
    _parameters['a'] = $a;

    final _path = _i4.UriTemplate('/index.php/apps/files_trashbin/preview{?fileId*,x*,y*,a*}').expand(_parameters);
    final _uri = Uri.parse('${_rootClient.baseURL}$_path');
    final _request = _i3.Request('get', _uri);
    _request.headers['Accept'] = '*/*';
// coverage:ignore-start
    final authentication = _rootClient.authentications?.firstWhereOrNull(
      (auth) => switch (auth) {
        _i1.DynamiteHttpBearerAuthentication() || _i1.DynamiteHttpBasicAuthentication() => true,
        _ => false,
      },
    );

    if (authentication != null) {
      _request.headers.addAll(
        authentication.headers,
      );
    } else {
      throw Exception('Missing authentication for bearer_auth or basic_auth');
    }

// coverage:ignore-end
    return _request;
  }

  /// Get the preview for a file.
  ///
  /// Returns a [Future] containing a `DynamiteResponse` with the status code, deserialized body and headers.
  /// Throws a `DynamiteApiException` if the API call does not return an expected status code.
  ///
  /// Parameters:
  ///   * [fileId] ID of the file. Defaults to `-1`.
  ///   * [x] Width of the preview. Defaults to `32`.
  ///   * [y] Height of the preview. Defaults to `32`.
  ///   * [a] Whether to not crop the preview. Defaults to `0`.
  ///
  /// Status codes:
  ///   * 200: Preview returned
  ///   * 400: Getting preview is not possible
  ///   * 404: Preview not found
  ///
  /// See:
  ///  * [$getPreview_Request] for the request send by this method.
  ///  * [$getPreview_Serializer] for a converter to parse the `Response` from an executed request.
  Future<_i1.DynamiteResponse<Uint8List, void>> getPreview({
    int? fileId,
    int? x,
    int? y,
    PreviewGetPreviewA? a,
  }) async {
    final _request = $getPreview_Request(
      fileId: fileId,
      x: x,
      y: y,
      a: a,
    );
    final _response = await _rootClient.httpClient.send(_request);

    final _serializer = $getPreview_Serializer();
    final _rawResponse = await _i1.ResponseConverter<Uint8List, void>(_serializer).convert(_response);
    return _i1.DynamiteResponse.fromRawResponse(_rawResponse);
  }
}

class PreviewGetPreviewA extends EnumClass {
  const PreviewGetPreviewA._(super.name);

  /// `0`
  @BuiltValueEnumConst(wireName: '0')
  static const PreviewGetPreviewA $0 = _$previewGetPreviewA$0;

  /// `1`
  @BuiltValueEnumConst(wireName: '1')
  static const PreviewGetPreviewA $1 = _$previewGetPreviewA$1;

  /// Returns a set with all values this enum contains.
  // coverage:ignore-start
  static BuiltSet<PreviewGetPreviewA> get values => _$previewGetPreviewAValues;
  // coverage:ignore-end

  /// Returns the enum value associated to the [name].
  static PreviewGetPreviewA valueOf(String name) => _$valueOfPreviewGetPreviewA(name);

  /// Returns the serialized value of this enum value.
  int get value => _$jsonSerializers.serializeWith(serializer, this)! as int;

  /// Serializer for PreviewGetPreviewA.
  @BuiltValueSerializer(custom: true)
  static Serializer<PreviewGetPreviewA> get serializer => const _$PreviewGetPreviewASerializer();
}

class _$PreviewGetPreviewASerializer implements PrimitiveSerializer<PreviewGetPreviewA> {
  const _$PreviewGetPreviewASerializer();

  static const Map<PreviewGetPreviewA, Object> _toWire = <PreviewGetPreviewA, Object>{
    PreviewGetPreviewA.$0: 0,
    PreviewGetPreviewA.$1: 1,
  };

  static const Map<Object, PreviewGetPreviewA> _fromWire = <Object, PreviewGetPreviewA>{
    0: PreviewGetPreviewA.$0,
    1: PreviewGetPreviewA.$1,
  };

  @override
  Iterable<Type> get types => const [PreviewGetPreviewA];

  @override
  String get wireName => 'PreviewGetPreviewA';

  @override
  Object serialize(
    Serializers serializers,
    PreviewGetPreviewA object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _toWire[object]!;

  @override
  PreviewGetPreviewA deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      _fromWire[serialized]!;
}

@BuiltValue(instantiable: false)
abstract interface class $Capabilities_FilesInterface {
  bool get undelete;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$Capabilities_FilesInterfaceBuilder].
  $Capabilities_FilesInterface rebuild(void Function($Capabilities_FilesInterfaceBuilder) updates);

  /// Converts the instance to a builder [$Capabilities_FilesInterfaceBuilder].
  $Capabilities_FilesInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($Capabilities_FilesInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($Capabilities_FilesInterfaceBuilder b) {}
}

abstract class Capabilities_Files
    implements $Capabilities_FilesInterface, Built<Capabilities_Files, Capabilities_FilesBuilder> {
  /// Creates a new Capabilities_Files object using the builder pattern.
  factory Capabilities_Files([void Function(Capabilities_FilesBuilder)? b]) = _$Capabilities_Files;

  // coverage:ignore-start
  const Capabilities_Files._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory Capabilities_Files.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for Capabilities_Files.
  static Serializer<Capabilities_Files> get serializer => _$capabilitiesFilesSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(Capabilities_FilesBuilder b) {
    $Capabilities_FilesInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(Capabilities_FilesBuilder b) {
    $Capabilities_FilesInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
abstract interface class $CapabilitiesInterface {
  Capabilities_Files get files;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$CapabilitiesInterfaceBuilder].
  $CapabilitiesInterface rebuild(void Function($CapabilitiesInterfaceBuilder) updates);

  /// Converts the instance to a builder [$CapabilitiesInterfaceBuilder].
  $CapabilitiesInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($CapabilitiesInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($CapabilitiesInterfaceBuilder b) {}
}

abstract class Capabilities implements $CapabilitiesInterface, Built<Capabilities, CapabilitiesBuilder> {
  /// Creates a new Capabilities object using the builder pattern.
  factory Capabilities([void Function(CapabilitiesBuilder)? b]) = _$Capabilities;

  // coverage:ignore-start
  const Capabilities._();
  // coverage:ignore-end

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  // coverage:ignore-start
  factory Capabilities.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;
  // coverage:ignore-end

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  // coverage:ignore-start
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;
  // coverage:ignore-end

  /// Serializer for Capabilities.
  static Serializer<Capabilities> get serializer => _$capabilitiesSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CapabilitiesBuilder b) {
    $CapabilitiesInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(CapabilitiesBuilder b) {
    $CapabilitiesInterface._validate(b);
  }
}

// coverage:ignore-start
/// Serializer for all values in this library.
///
/// Serializes values into the `built_value` wire format.
/// See: [$jsonSerializers] for serializing into json.
@_i2.visibleForTesting
final Serializers $serializers = _$serializers;
final Serializers _$serializers = (Serializers().toBuilder()
      ..add(PreviewGetPreviewA.serializer)
      ..addBuilderFactory(const FullType(Capabilities), CapabilitiesBuilder.new)
      ..add(Capabilities.serializer)
      ..addBuilderFactory(const FullType(Capabilities_Files), Capabilities_FilesBuilder.new)
      ..add(Capabilities_Files.serializer))
    .build();

/// Serializer for all values in this library.
///
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.
@_i2.visibleForTesting
final Serializers $jsonSerializers = _$jsonSerializers;
final Serializers _$jsonSerializers = (_$serializers.toBuilder()
      ..add(_i5.DynamiteDoubleSerializer())
      ..addPlugin(_i6.StandardJsonPlugin())
      ..addPlugin(const _i5.HeaderPlugin())
      ..addPlugin(const _i5.ContentStringPlugin()))
    .build();
// coverage:ignore-end
