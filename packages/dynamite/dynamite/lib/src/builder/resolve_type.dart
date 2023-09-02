import 'package:code_builder/code_builder.dart';
import 'package:dynamite/src/builder/resolve_object.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/helpers/typeresult.dart';
import 'package:dynamite/src/models/open_api.dart';
import 'package:dynamite/src/models/schema.dart';
import 'package:dynamite/src/type_result/type_result.dart';

TypeResult resolveType(
  final OpenAPI spec,
  final String variablePrefix,
  final State state,
  final String identifier,
  final Schema schema, {
  final bool ignoreEnum = false,
  final bool nullable = false,
}) {
  TypeResult? result;
  if (schema.ref == null && schema.ofs == null && schema.type == null) {
    return TypeResultBase(
      'JsonObject',
      nullable: nullable,
    );
  }
  if (schema.ref != null) {
    final name = schema.ref!.split('/').last;
    result = resolveType(
      spec,
      variablePrefix,
      state,
      name,
      spec.components!.schemas![name]!,
      nullable: nullable,
    );
  } else if (schema.ofs != null) {
    result = TypeResultObject(
      '${state.classPrefix}$identifier',
      nullable: nullable,
    );
    if (state.resolvedTypes.add(result)) {
      final results = schema.ofs!
          .map(
            (final s) => resolveType(
              spec,
              variablePrefix,
              state,
              '$identifier${schema.ofs!.indexOf(s)}',
              s,
              nullable: !(schema.allOf?.contains(s) ?? false),
            ),
          )
          .toList();

      final fields = <String, String>{};
      for (final result in results) {
        final dartName = toDartName(result.name.replaceFirst(state.classPrefix, ''));
        fields[result.name] = toFieldName(dartName, result.name.replaceFirst(state.classPrefix, ''));
      }

      state.output.addAll([
        Class(
          (final b) {
            b
              ..name = '${state.classPrefix}$identifier'
              ..abstract = true
              ..implements.add(
                refer(
                  'Built<${state.classPrefix}$identifier, ${state.classPrefix}${identifier}Builder>',
                ),
              )
              ..constructors.addAll([
                Constructor(
                  (final b) => b
                    ..name = '_'
                    ..constant = true,
                ),
                Constructor(
                  (final b) => b
                    ..factory = true
                    ..lambda = true
                    ..optionalParameters.add(
                      Parameter(
                        (final b) => b
                          ..name = 'b'
                          ..type = refer('void Function(${state.classPrefix}${identifier}Builder)?'),
                      ),
                    )
                    ..redirect = refer('_\$${state.classPrefix}$identifier'),
                ),
              ])
              ..methods.addAll([
                Method(
                  (final b) {
                    b
                      ..name = 'data'
                      ..returns = refer('JsonObject')
                      ..type = MethodType.getter;
                  },
                ),
                for (final result in results) ...[
                  Method(
                    (final b) {
                      final s = schema.ofs![results.indexOf(result)];
                      b
                        ..name = fields[result.name]
                        ..returns = refer(result.nullableName)
                        ..type = MethodType.getter
                        ..docs.addAll(s.formattedDescription);
                    },
                  ),
                ],
                Method(
                  (final b) => b
                    ..static = true
                    ..name = 'fromJson'
                    ..lambda = true
                    ..returns = refer('${state.classPrefix}$identifier')
                    ..requiredParameters.add(
                      Parameter(
                        (final b) => b
                          ..name = 'json'
                          ..type = refer('Object'),
                      ),
                    )
                    ..body = const Code('_jsonSerializers.deserializeWith(serializer, json)!'),
                ),
                Method(
                  (final b) => b
                    ..name = 'toJson'
                    ..returns = refer('Map<String, dynamic>')
                    ..lambda = true
                    ..body = const Code('_jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>'),
                ),
                Method(
                  (final b) => b
                    ..name = 'serializer'
                    ..returns = refer('Serializer<${state.classPrefix}$identifier>')
                    ..lambda = true
                    ..static = true
                    ..annotations.add(refer('BuiltValueSerializer').call([], {'custom': refer('true')}))
                    ..body = Code('_\$${state.classPrefix}${identifier}Serializer()')
                    ..type = MethodType.getter,
                ),
              ]);
          },
        ),
        Class(
          (final b) => b
            ..name = '_\$${state.classPrefix}${identifier}Serializer'
            ..implements.add(refer('PrimitiveSerializer<${state.classPrefix}$identifier>'))
            ..fields.addAll([
              Field(
                (final b) => b
                  ..name = 'types'
                  ..modifier = FieldModifier.final$
                  ..type = refer('Iterable<Type>')
                  ..annotations.add(refer('override'))
                  ..assignment = Code('const [${state.classPrefix}$identifier, _\$${state.classPrefix}$identifier]'),
              ),
              Field(
                (final b) => b
                  ..name = 'wireName'
                  ..modifier = FieldModifier.final$
                  ..type = refer('String')
                  ..annotations.add(refer('override'))
                  ..assignment = Code("r'${state.classPrefix}$identifier'"),
              ),
            ])
            ..methods.addAll([
              Method((final b) {
                b
                  ..name = 'serialize'
                  ..returns = refer('Object')
                  ..annotations.add(refer('override'))
                  ..requiredParameters.addAll([
                    Parameter(
                      (final b) => b
                        ..name = 'serializers'
                        ..type = refer('Serializers'),
                    ),
                    Parameter(
                      (final b) => b
                        ..name = 'object'
                        ..type = refer('${state.classPrefix}$identifier'),
                    ),
                  ])
                  ..optionalParameters.add(
                    Parameter(
                      (final b) => b
                        ..name = 'specifiedType'
                        ..type = refer('FullType')
                        ..named = true
                        ..defaultTo = const Code('FullType.unspecified'),
                    ),
                  )
                  ..body = const Code('return object.data.value;');
              }),
              Method((final b) {
                b
                  ..name = 'deserialize'
                  ..returns = refer('${state.classPrefix}$identifier')
                  ..annotations.add(refer('override'))
                  ..requiredParameters.addAll([
                    Parameter(
                      (final b) => b
                        ..name = 'serializers'
                        ..type = refer('Serializers'),
                    ),
                    Parameter(
                      (final b) => b
                        ..name = 'data'
                        ..type = refer('Object'),
                    ),
                  ])
                  ..optionalParameters.add(
                    Parameter(
                      (final b) => b
                        ..name = 'specifiedType'
                        ..type = refer('FullType')
                        ..named = true
                        ..defaultTo = const Code('FullType.unspecified'),
                    ),
                  )
                  ..body = Code(
                    <String>[
                      'final result = new ${state.classPrefix}${identifier}Builder()',
                      '..data = JsonObject(data);',
                      if (schema.allOf != null) ...[
                        for (final result in results) ...[
                          if (result is TypeResultBase || result is TypeResultEnum) ...[
                            'result.${fields[result.name]!} = ${result.deserialize('data')};',
                          ] else ...[
                            'result.${fields[result.name]!}.replace(${result.deserialize('data')});',
                          ],
                        ],
                      ] else ...[
                        if (schema.discriminator != null) ...[
                          'if (data is! Iterable) {',
                          r"throw StateError('Expected an Iterable but got ${data.runtimeType}');",
                          '}',
                          '',
                          'String? discriminator;',
                          '',
                          'final iterator = data.iterator;',
                          'while (iterator.moveNext()) {',
                          'final key = iterator.current! as String;',
                          'iterator.moveNext();',
                          'final Object? value = iterator.current;',
                          "if (key == '${schema.discriminator!.propertyName}') {",
                          'discriminator = value! as String;',
                          'break;',
                          '}',
                          '}',
                        ],
                        for (final result in results) ...[
                          if (schema.discriminator != null) ...[
                            "if (discriminator == '${result.name.replaceFirst(state.classPrefix, '')}'",
                            if (schema.discriminator!.mapping != null && schema.discriminator!.mapping!.isNotEmpty) ...[
                              for (final key in schema.discriminator!.mapping!.entries
                                  .where(
                                    (final entry) =>
                                        entry.value.endsWith('/${result.name.replaceFirst(state.classPrefix, '')}'),
                                  )
                                  .map((final entry) => entry.key)) ...[
                                " ||  discriminator == '$key'",
                              ],
                              ') {',
                            ],
                          ],
                          'try {',
                          if (result is TypeResultBase || result is TypeResultEnum) ...[
                            'result._${fields[result.name]!} = ${result.deserialize('data')};',
                          ] else ...[
                            'result._${fields[result.name]!} = ${result.deserialize('data')}.toBuilder();',
                          ],
                          '} catch (_) {',
                          if (schema.discriminator != null) ...[
                            'rethrow;',
                          ],
                          '}',
                          if (schema.discriminator != null) ...[
                            '}',
                          ],
                        ],
                        if (schema.oneOf != null) ...[
                          "assert([${fields.values.map((final e) => 'result._$e').join(',')}].where((final x) => x != null).length >= 1, 'Need oneOf for \${result._data}');",
                        ],
                        if (schema.anyOf != null) ...[
                          "assert([${fields.values.map((final e) => 'result._$e').join(',')}].where((final x) => x != null).length >= 1, 'Need anyOf for \${result._data}');",
                        ],
                      ],
                      'return result.build();',
                    ].join(),
                  );
              }),
            ]),
        ),
      ]);
    }
  } else if (schema.isContentString) {
    final subResult = resolveType(
      spec,
      variablePrefix,
      state,
      identifier,
      schema.contentSchema!,
    );

    result = TypeResultObject(
      'ContentString',
      generics: [subResult],
      nullable: nullable,
    );
  } else {
    switch (schema.type) {
      case 'boolean':
        result = TypeResultBase(
          'bool',
          nullable: nullable,
        );
      case 'integer':
        result = TypeResultBase(
          'int',
          nullable: nullable,
        );
      case 'number':
        result = TypeResultBase(
          'num',
          nullable: nullable,
        );
      case 'string':
        switch (schema.format) {
          case 'binary':
            result = TypeResultBase(
              'Uint8List',
              nullable: nullable,
            );
        }

        result = TypeResultBase(
          'String',
          nullable: nullable,
        );
      case 'array':
        if (schema.items != null) {
          final subResult = resolveType(
            spec,
            variablePrefix,
            state,
            identifier,
            schema.items!,
          );
          result = TypeResultList(
            'BuiltList',
            subResult,
            nullable: nullable,
          );
        } else {
          result = TypeResultList(
            'BuiltList',
            TypeResultBase('JsonObject'),
            nullable: nullable,
          );
        }
      case 'object':
        if (schema.properties == null) {
          if (schema.additionalProperties == null) {
            result = TypeResultBase(
              'JsonObject',
              nullable: nullable,
            );
          } else if (schema.additionalProperties is EmptySchema) {
            result = TypeResultMap(
              'BuiltMap',
              TypeResultBase('JsonObject'),
              nullable: nullable,
            );
          } else {
            final subResult = resolveType(
              spec,
              variablePrefix,
              state,
              identifier,
              schema.additionalProperties!,
            );
            result = TypeResultMap(
              'BuiltMap',
              subResult,
              nullable: nullable,
            );
          }
        } else if (schema.properties!.isEmpty) {
          result = TypeResultMap(
            'BuiltMap',
            TypeResultBase('JsonObject'),
            nullable: nullable,
          );
        } else {
          result = resolveObject(
            spec,
            variablePrefix,
            state,
            identifier,
            schema,
            nullable: nullable,
          );
        }
    }
  }

  if (result != null) {
    if (!ignoreEnum && schema.enum_ != null) {
      if (state.resolvedTypes.add(TypeResultEnum('${state.classPrefix}$identifier', result))) {
        state.output.add(
          Class(
            (final b) => b
              ..name = '${state.classPrefix}$identifier'
              ..extend = refer('EnumClass')
              ..constructors.add(
                Constructor(
                  (final b) => b
                    ..name = '_'
                    ..constant = true
                    ..requiredParameters.add(
                      Parameter(
                        (final b) => b
                          ..name = 'name'
                          ..toSuper = true,
                      ),
                    ),
                ),
              )
              ..fields.addAll(
                schema.enum_!.map(
                  (final value) => Field(
                    (final b) {
                      final result = resolveType(
                        spec,
                        variablePrefix,
                        state,
                        '$identifier${toDartName(value.toString(), uppercaseFirstCharacter: true)}',
                        schema,
                        ignoreEnum: true,
                      );
                      b
                        ..name = toDartName(value.toString())
                        ..static = true
                        ..modifier = FieldModifier.constant
                        ..type = refer('${state.classPrefix}$identifier')
                        ..assignment = Code(
                          '_\$${toCamelCase('${state.classPrefix}$identifier')}${toDartName(value.toString(), uppercaseFirstCharacter: true)}',
                        );

                      if (toDartName(value.toString()) != value.toString()) {
                        if (result.name != 'String' && result.name != 'int') {
                          throw Exception(
                            'Sorry enum values are a bit broken. '
                            'See https://github.com/google/json_serializable.dart/issues/616. '
                            'Please remove the enum values on ${state.classPrefix}$identifier.',
                          );
                        }
                        b.annotations.add(
                          refer('BuiltValueEnumConst').call([], {
                            'wireName': refer(valueToEscapedValue(result, value.toString())),
                          }),
                        );
                      }
                    },
                  ),
                ),
              )
              ..methods.addAll([
                Method(
                  (final b) => b
                    ..name = 'values'
                    ..returns = refer('BuiltSet<${state.classPrefix}$identifier>')
                    ..lambda = true
                    ..static = true
                    ..body = Code('_\$${toCamelCase('${state.classPrefix}$identifier')}Values')
                    ..type = MethodType.getter,
                ),
                Method(
                  (final b) => b
                    ..name = 'valueOf'
                    ..returns = refer('${state.classPrefix}$identifier')
                    ..lambda = true
                    ..static = true
                    ..requiredParameters.add(
                      Parameter(
                        (final b) => b
                          ..name = 'name'
                          ..type = refer(result!.name),
                      ),
                    )
                    ..body = Code('_\$valueOf${state.classPrefix}$identifier(name)'),
                ),
                Method(
                  (final b) => b
                    ..name = 'serializer'
                    ..returns = refer('Serializer<${state.classPrefix}$identifier>')
                    ..lambda = true
                    ..static = true
                    ..body = Code("_\$${toCamelCase('${state.classPrefix}$identifier')}Serializer")
                    ..type = MethodType.getter,
                ),
              ]),
          ),
        );
      }
      result = TypeResultEnum(
        '${state.classPrefix}$identifier',
        result,
        nullable: nullable,
      );
    }

    state.resolvedTypes.add(result);
    return result;
  }

  throw Exception('Can not convert OpenAPI type "${schema.toJson()}" to a Dart type');
}
