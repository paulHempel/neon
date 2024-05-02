import 'package:built_collection/built_collection.dart';
import 'package:dynamite/src/builder/resolve_enum.dart';
import 'package:dynamite/src/builder/resolve_object.dart';
import 'package:dynamite/src/builder/resolve_ofs.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/models/json_schema.dart' as json_schema;
import 'package:dynamite/src/models/type_result.dart';

/// Resolves the [schema] into a `TypeResult`.
///
/// Resolved types are always added to the [state].
TypeResult resolveType(
  State state,
  json_schema.JsonSchema schema, {
  bool nullable = false,
}) {
  final result = _resolveType(
    state,
    schema,
    nullable: nullable,
  );

  state.resolvedTypes.add(result);
  return result;
}

TypeResult _resolveType(
  State state,
  json_schema.JsonSchema schema, {
  bool nullable = false,
}) {
  switch (schema) {
    case json_schema.JsonSchema($enum: != null):
      final subResult = resolveType(
        state,
        schema.rebuild((b) {
          b.$enum = null;
        }),
        nullable: nullable,
      );

      return resolveEnum(
        state,
        schema,
        subResult,
        nullable: nullable,
      );

    case json_schema.JsonSchema(allOf: != null):
      return resolveObject(
        state,
        schema,
        nullable: nullable,
      );

    case json_schema.GenericSchema(ref: null, allOf: null, anyOf: null, oneOf: null):
      return TypeResultBase(
        'JsonObject',
        nullable: nullable,
      );

    case json_schema.JsonSchema(ref: != null):
      final subResult = resolveType(
        state,
        schema.resolveRef(state.rootJson),
        nullable: nullable,
      );

      return subResult.asTypeDef;

    case json_schema.JsonSchema(anyOf: != null) || json_schema.JsonSchema(oneOf: != null):
      return resolveSomeOf(
        state,
        schema,
        nullable: nullable,
      );

    case json_schema.StringSchema(isContentString: true):
      final subResult = resolveType(
        state,
        schema.contentSchema!.rebuild((b) {
          b.identifier = schema.identifier;
        }),
      );

      return TypeResultObject(
        'ContentString',
        generics: BuiltList([subResult]),
        nullable: nullable,
      );

    case json_schema.BooleanSchema():
      return TypeResultBase(
        'bool',
        nullable: nullable,
      );

    case json_schema.IntegerSchema():
      return TypeResultBase(
        'int',
        nullable: nullable,
      );

    case json_schema.NumberSchema(format: 'float' || 'double'):
      return TypeResultBase(
        'double',
        nullable: nullable,
      );

    case json_schema.NumberSchema():
      return TypeResultBase(
        'num',
        nullable: nullable,
      );

    case json_schema.StringSchema(format: 'binary'):
      return TypeResultBase(
        'Uint8List',
        nullable: nullable,
      );

    case json_schema.StringSchema():
      return TypeResultBase(
        'String',
        nullable: nullable,
      );

    case json_schema.ArraySchema():
      final TypeResult subResult;
      if (schema.maxItems == 0) {
        subResult = TypeResultBase('Never');
      } else if (schema.items != null) {
        subResult = resolveType(
          state,
          schema.items!.rebuild((b) {
            b.identifier = schema.identifier;
          }),
        );
      } else {
        subResult = TypeResultBase('JsonObject');
      }

      return TypeResultList(
        schema.uniqueItems ? 'BuiltSet' : 'BuiltList',
        subResult,
        builderName: schema.uniqueItems ? 'SetBuilder' : 'ListBuilder',
        nullable: nullable,
      );

    case json_schema.ObjectSchema(properties: null):
      if (schema.additionalProperties == null) {
        return TypeResultBase(
          'JsonObject',
          nullable: nullable,
        );
      } else {
        final subResult = resolveType(
          state,
          schema.additionalProperties!.rebuild((b) {
            b.identifier = schema.identifier;
          }),
        );
        return TypeResultMap(
          'BuiltMap',
          subResult,
          nullable: nullable,
        );
      }

    case json_schema.ObjectSchema(:final properties) when properties != null && properties.isEmpty:
      return TypeResultMap(
        'BuiltMap',
        TypeResultBase('JsonObject'),
        nullable: nullable,
      );

    case json_schema.ObjectSchema():
      return resolveObject(
        state,
        schema,
        nullable: nullable,
      );

    default:
      throw Exception('Can not convert OpenAPI type "$schema" to a Dart type');
  }
}
