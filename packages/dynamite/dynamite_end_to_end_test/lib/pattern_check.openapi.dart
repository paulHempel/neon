// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case, unused_element

/// Pattern check test Version: 0.0.1.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i4;
import 'package:dynamite_runtime/built_value.dart' as _i3;
import 'package:dynamite_runtime/utils.dart' as _i1;
import 'package:meta/meta.dart' as _i2;

part 'pattern_check.openapi.g.dart';

@BuiltValue(instantiable: false)
abstract interface class $TestObjectInterface {
  @BuiltValueField(wireName: 'only-numbers')
  String? get onlyNumbers;
  @BuiltValueField(wireName: 'min-length')
  String? get minLength;
  @BuiltValueField(wireName: 'max-length')
  String? get maxLength;
  @BuiltValueField(wireName: 'string-multiple-checks')
  String? get stringMultipleChecks;
  @BuiltValueField(wireName: 'min-items')
  BuiltList<int>? get minItems;
  @BuiltValueField(wireName: 'max-items')
  BuiltList<int>? get maxItems;
  @BuiltValueField(wireName: 'array-unique')
  BuiltList<int>? get arrayUnique;
  @BuiltValueField(wireName: 'array-multiple-checks')
  BuiltList<int>? get arrayMultipleChecks;
  num? get multipleOf;
  num? get maximum;
  num? get exclusiveMaximum;
  num? get minimum;
  num? get exclusiveMinimum;
  @BuiltValueField(wireName: 'number-multiple-checks')
  num? get numberMultipleChecks;
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($TestObjectInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($TestObjectInterfaceBuilder b) {
    _i1.checkString(
      b.onlyNumbers,
      'onlyNumbers',
      pattern: RegExp(r'^[0-9]*$'),
    );
    _i1.checkString(
      b.minLength,
      'minLength',
      minLength: 3,
    );
    _i1.checkString(
      b.maxLength,
      'maxLength',
      maxLength: 20,
    );
    _i1.checkString(
      b.stringMultipleChecks,
      'stringMultipleChecks',
      pattern: RegExp(r'^[0-9]*$'),
      minLength: 3,
      maxLength: 20,
    );
    _i1.checkIterable(
      b.minItems,
      'minItems',
      minItems: 3,
    );
    _i1.checkIterable(
      b.maxItems,
      'maxItems',
      maxItems: 20,
    );
    _i1.checkIterable(
      b.arrayUnique,
      'arrayUnique',
      uniqueItems: true,
    );
    _i1.checkIterable(
      b.arrayMultipleChecks,
      'arrayMultipleChecks',
      uniqueItems: true,
      minItems: 3,
      maxItems: 20,
    );
    _i1.checkNumber(
      b.multipleOf,
      'multipleOf',
      multipleOf: 0,
    );
    _i1.checkNumber(
      b.maximum,
      'maximum',
      maximum: 0,
    );
    _i1.checkNumber(
      b.exclusiveMaximum,
      'exclusiveMaximum',
      exclusiveMaximum: 0,
    );
    _i1.checkNumber(
      b.minimum,
      'minimum',
      minimum: 0,
    );
    _i1.checkNumber(
      b.exclusiveMinimum,
      'exclusiveMinimum',
      exclusiveMinimum: 0,
    );
    _i1.checkNumber(
      b.numberMultipleChecks,
      'numberMultipleChecks',
      multipleOf: 1,
      maximum: 0,
      exclusiveMaximum: 0.1,
      minimum: 0,
      exclusiveMinimum: -0.1,
    );
  }
}

abstract class TestObject implements $TestObjectInterface, Built<TestObject, TestObjectBuilder> {
  /// Creates a new TestObject object using the builder pattern.
  factory TestObject([void Function(TestObjectBuilder)? b]) = _$TestObject;

  const TestObject._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory TestObject.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for TestObject.
  static Serializer<TestObject> get serializer => _$testObjectSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TestObjectBuilder b) {
    $TestObjectInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(TestObjectBuilder b) {
    $TestObjectInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
abstract interface class $TestObjectUnspecifiedInterface {
  JsonObject? get value;
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($TestObjectUnspecifiedInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($TestObjectUnspecifiedInterfaceBuilder b) {
    _i1.checkString(
      b.value,
      'value',
      pattern: RegExp(r'^[0-9]*$'),
      minLength: 3,
      maxLength: 20,
    );
    _i1.checkIterable(
      b.value,
      'value',
      minItems: 3,
      maxItems: 20,
    );
    _i1.checkNumber(
      b.value,
      'value',
      multipleOf: 1,
      maximum: 0,
      exclusiveMaximum: 0,
      minimum: 0,
      exclusiveMinimum: 0,
    );
  }
}

abstract class TestObjectUnspecified
    implements $TestObjectUnspecifiedInterface, Built<TestObjectUnspecified, TestObjectUnspecifiedBuilder> {
  /// Creates a new TestObjectUnspecified object using the builder pattern.
  factory TestObjectUnspecified([void Function(TestObjectUnspecifiedBuilder)? b]) = _$TestObjectUnspecified;

  const TestObjectUnspecified._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory TestObjectUnspecified.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for TestObjectUnspecified.
  static Serializer<TestObjectUnspecified> get serializer => _$testObjectUnspecifiedSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TestObjectUnspecifiedBuilder b) {
    $TestObjectUnspecifiedInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(TestObjectUnspecifiedBuilder b) {
    $TestObjectUnspecifiedInterface._validate(b);
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
      ..addBuilderFactory(const FullType(TestObject), TestObjectBuilder.new)
      ..add(TestObject.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(int)]), ListBuilder<int>.new)
      ..addBuilderFactory(const FullType(TestObjectUnspecified), TestObjectUnspecifiedBuilder.new)
      ..add(TestObjectUnspecified.serializer))
    .build();

/// Serializer for all values in this library.
///
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.
@_i2.visibleForTesting
final Serializers $jsonSerializers = _$jsonSerializers;
final Serializers _$jsonSerializers = (_$serializers.toBuilder()
      ..add(_i3.DynamiteDoubleSerializer())
      ..addPlugin(_i4.StandardJsonPlugin())
      ..addPlugin(const _i3.HeaderPlugin())
      ..addPlugin(const _i3.ContentStringPlugin()))
    .build();
// coverage:ignore-end
