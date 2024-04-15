// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const JsonSchemaType _$jsonSchemaTypeBoolean = JsonSchemaType._('boolean');
const JsonSchemaType _$jsonSchemaTypeInteger = JsonSchemaType._('integer');
const JsonSchemaType _$jsonSchemaTypeNumber = JsonSchemaType._('number');
const JsonSchemaType _$jsonSchemaTypeString = JsonSchemaType._('string');
const JsonSchemaType _$jsonSchemaTypeArray = JsonSchemaType._('array');
const JsonSchemaType _$jsonSchemaTypeObject = JsonSchemaType._('object');

JsonSchemaType _$jsonSchemaType(String name) {
  switch (name) {
    case 'boolean':
      return _$jsonSchemaTypeBoolean;
    case 'integer':
      return _$jsonSchemaTypeInteger;
    case 'number':
      return _$jsonSchemaTypeNumber;
    case 'string':
      return _$jsonSchemaTypeString;
    case 'array':
      return _$jsonSchemaTypeArray;
    case 'object':
      return _$jsonSchemaTypeObject;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<JsonSchemaType> _$jsonSchemaTypeValues = BuiltSet<JsonSchemaType>(const <JsonSchemaType>[
  _$jsonSchemaTypeBoolean,
  _$jsonSchemaTypeInteger,
  _$jsonSchemaTypeNumber,
  _$jsonSchemaTypeString,
  _$jsonSchemaTypeArray,
  _$jsonSchemaTypeObject,
]);

Serializer<JsonSchema> _$jsonSchemaSerializer = _$JsonSchemaSerializer();
Serializer<JsonSchemaType> _$jsonSchemaTypeSerializer = _$JsonSchemaTypeSerializer();

class _$JsonSchemaSerializer implements StructuredSerializer<JsonSchema> {
  @override
  final Iterable<Type> types = const [JsonSchema, _$JsonSchema];
  @override
  final String wireName = 'JsonSchema';

  @override
  Iterable<Object?> serialize(Serializers serializers, JsonSchema object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'deprecated',
      serializers.serialize(object.deprecated, specifiedType: const FullType(bool)),
      'required',
      serializers.serialize(object.required, specifiedType: const FullType(BuiltList, [FullType(String)])),
      'nullable',
      serializers.serialize(object.nullable, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('\$id')
        ..add(serializers.serialize(value, specifiedType: const FullType(Uri)));
    }
    value = object.ref;
    if (value != null) {
      result
        ..add('\$ref')
        ..add(serializers.serialize(value, specifiedType: const FullType(Uri)));
    }
    value = object.oneOf;
    if (value != null) {
      result
        ..add('oneOf')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(JsonSchema)])));
    }
    value = object.anyOf;
    if (value != null) {
      result
        ..add('anyOf')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(JsonSchema)])));
    }
    value = object.allOf;
    if (value != null) {
      result
        ..add('allOf')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(JsonSchema)])));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.type;
    if (value != null) {
      result
        ..add('type')
        ..add(serializers.serialize(value, specifiedType: const FullType(JsonSchemaType)));
    }
    value = object.format;
    if (value != null) {
      result
        ..add('format')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.rawDefault;
    if (value != null) {
      result
        ..add('default')
        ..add(serializers.serialize(value, specifiedType: const FullType(JsonObject)));
    }
    value = object.$enum;
    if (value != null) {
      result
        ..add('enum')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(JsonObject)])));
    }
    value = object.properties;
    if (value != null) {
      result
        ..add('properties')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(JsonSchema)])));
    }
    value = object.items;
    if (value != null) {
      result
        ..add('items')
        ..add(serializers.serialize(value, specifiedType: const FullType(JsonSchema)));
    }
    value = object.additionalProperties;
    if (value != null) {
      result
        ..add('additionalProperties')
        ..add(serializers.serialize(value, specifiedType: const FullType(JsonSchema)));
    }
    value = object.contentMediaType;
    if (value != null) {
      result
        ..add('contentMediaType')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.contentSchema;
    if (value != null) {
      result
        ..add('contentSchema')
        ..add(serializers.serialize(value, specifiedType: const FullType(JsonSchema)));
    }
    value = object.discriminator;
    if (value != null) {
      result
        ..add('discriminator')
        ..add(serializers.serialize(value, specifiedType: const FullType(Discriminator)));
    }
    value = object.pattern;
    if (value != null) {
      result
        ..add('pattern')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.minLength;
    if (value != null) {
      result
        ..add('minLength')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.maxLength;
    if (value != null) {
      result
        ..add('maxLength')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.minItems;
    if (value != null) {
      result
        ..add('minItems')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.maxItems;
    if (value != null) {
      result
        ..add('maxItems')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  JsonSchema deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = JsonSchemaBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '\$id':
          result.id = serializers.deserialize(value, specifiedType: const FullType(Uri)) as Uri?;
          break;
        case '\$ref':
          result.ref = serializers.deserialize(value, specifiedType: const FullType(Uri)) as Uri?;
          break;
        case 'oneOf':
          result.oneOf.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(JsonSchema)]))! as BuiltList<Object?>);
          break;
        case 'anyOf':
          result.anyOf.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(JsonSchema)]))! as BuiltList<Object?>);
          break;
        case 'allOf':
          result.allOf.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(JsonSchema)]))! as BuiltList<Object?>);
          break;
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'deprecated':
          result.deprecated = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'type':
          result.type =
              serializers.deserialize(value, specifiedType: const FullType(JsonSchemaType)) as JsonSchemaType?;
          break;
        case 'format':
          result.format = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'default':
          result.rawDefault = serializers.deserialize(value, specifiedType: const FullType(JsonObject)) as JsonObject?;
          break;
        case 'enum':
          result.$enum.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(JsonObject)]))! as BuiltList<Object?>);
          break;
        case 'properties':
          result.properties.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(JsonSchema)]))!);
          break;
        case 'required':
          result.required.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(String)]))! as BuiltList<Object?>);
          break;
        case 'items':
          result.items
              .replace(serializers.deserialize(value, specifiedType: const FullType(JsonSchema))! as JsonSchema);
          break;
        case 'additionalProperties':
          result.additionalProperties
              .replace(serializers.deserialize(value, specifiedType: const FullType(JsonSchema))! as JsonSchema);
          break;
        case 'contentMediaType':
          result.contentMediaType = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'contentSchema':
          result.contentSchema
              .replace(serializers.deserialize(value, specifiedType: const FullType(JsonSchema))! as JsonSchema);
          break;
        case 'discriminator':
          result.discriminator
              .replace(serializers.deserialize(value, specifiedType: const FullType(Discriminator))! as Discriminator);
          break;
        case 'pattern':
          result.pattern = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'minLength':
          result.minLength = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'maxLength':
          result.maxLength = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'minItems':
          result.minItems = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'maxItems':
          result.maxItems = serializers.deserialize(value, specifiedType: const FullType(int)) as int?;
          break;
        case 'nullable':
          result.nullable = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$JsonSchemaTypeSerializer implements PrimitiveSerializer<JsonSchemaType> {
  @override
  final Iterable<Type> types = const <Type>[JsonSchemaType];
  @override
  final String wireName = 'JsonSchemaType';

  @override
  Object serialize(Serializers serializers, JsonSchemaType object, {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  JsonSchemaType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      JsonSchemaType.valueOf(serialized as String);
}

class _$JsonSchema extends JsonSchema {
  @override
  final Uri? id;
  @override
  final Uri? ref;
  @override
  final BuiltList<JsonSchema>? oneOf;
  @override
  final BuiltList<JsonSchema>? anyOf;
  @override
  final BuiltList<JsonSchema>? allOf;
  @override
  final String? description;
  @override
  final bool deprecated;
  @override
  final JsonSchemaType? type;
  @override
  final String? format;
  @override
  final JsonObject? rawDefault;
  @override
  final BuiltList<JsonObject>? $enum;
  @override
  final BuiltMap<String, JsonSchema>? properties;
  @override
  final BuiltList<String> required;
  @override
  final JsonSchema? items;
  @override
  final JsonSchema? additionalProperties;
  @override
  final String? contentMediaType;
  @override
  final JsonSchema? contentSchema;
  @override
  final Discriminator? discriminator;
  @override
  final String? pattern;
  @override
  final int? minLength;
  @override
  final int? maxLength;
  @override
  final int? minItems;
  @override
  final int? maxItems;
  @override
  final bool nullable;
  String? __$default;
  bool ___$default = false;
  String? __defaultDescription;
  bool ___defaultDescription = false;
  bool? __isContentString;
  String? __formattedDescription;
  bool ___formattedDescription = false;

  factory _$JsonSchema([void Function(JsonSchemaBuilder)? updates]) => (JsonSchemaBuilder()..update(updates))._build();

  _$JsonSchema._(
      {this.id,
      this.ref,
      this.oneOf,
      this.anyOf,
      this.allOf,
      this.description,
      required this.deprecated,
      this.type,
      this.format,
      this.rawDefault,
      this.$enum,
      this.properties,
      required this.required,
      this.items,
      this.additionalProperties,
      this.contentMediaType,
      this.contentSchema,
      this.discriminator,
      this.pattern,
      this.minLength,
      this.maxLength,
      this.minItems,
      this.maxItems,
      required this.nullable})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(deprecated, r'JsonSchema', 'deprecated');
    BuiltValueNullFieldError.checkNotNull(required, r'JsonSchema', 'required');
    BuiltValueNullFieldError.checkNotNull(nullable, r'JsonSchema', 'nullable');
  }

  @override
  String? get $default {
    if (!___$default) {
      __$default = super.$default;
      ___$default = true;
    }
    return __$default;
  }

  @override
  String? get defaultDescription {
    if (!___defaultDescription) {
      __defaultDescription = super.defaultDescription;
      ___defaultDescription = true;
    }
    return __defaultDescription;
  }

  @override
  bool get isContentString => __isContentString ??= super.isContentString;

  @override
  String? get formattedDescription {
    if (!___formattedDescription) {
      __formattedDescription = super.formattedDescription;
      ___formattedDescription = true;
    }
    return __formattedDescription;
  }

  @override
  JsonSchema rebuild(void Function(JsonSchemaBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  JsonSchemaBuilder toBuilder() => JsonSchemaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JsonSchema &&
        id == other.id &&
        ref == other.ref &&
        oneOf == other.oneOf &&
        anyOf == other.anyOf &&
        allOf == other.allOf &&
        deprecated == other.deprecated &&
        type == other.type &&
        format == other.format &&
        rawDefault == other.rawDefault &&
        $enum == other.$enum &&
        properties == other.properties &&
        required == other.required &&
        items == other.items &&
        additionalProperties == other.additionalProperties &&
        contentMediaType == other.contentMediaType &&
        contentSchema == other.contentSchema &&
        discriminator == other.discriminator &&
        pattern == other.pattern &&
        minLength == other.minLength &&
        maxLength == other.maxLength &&
        minItems == other.minItems &&
        maxItems == other.maxItems &&
        nullable == other.nullable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ref.hashCode);
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jc(_$hash, allOf.hashCode);
    _$hash = $jc(_$hash, deprecated.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, format.hashCode);
    _$hash = $jc(_$hash, rawDefault.hashCode);
    _$hash = $jc(_$hash, $enum.hashCode);
    _$hash = $jc(_$hash, properties.hashCode);
    _$hash = $jc(_$hash, required.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, additionalProperties.hashCode);
    _$hash = $jc(_$hash, contentMediaType.hashCode);
    _$hash = $jc(_$hash, contentSchema.hashCode);
    _$hash = $jc(_$hash, discriminator.hashCode);
    _$hash = $jc(_$hash, pattern.hashCode);
    _$hash = $jc(_$hash, minLength.hashCode);
    _$hash = $jc(_$hash, maxLength.hashCode);
    _$hash = $jc(_$hash, minItems.hashCode);
    _$hash = $jc(_$hash, maxItems.hashCode);
    _$hash = $jc(_$hash, nullable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JsonSchema')
          ..add('id', id)
          ..add('ref', ref)
          ..add('oneOf', oneOf)
          ..add('anyOf', anyOf)
          ..add('allOf', allOf)
          ..add('description', description)
          ..add('deprecated', deprecated)
          ..add('type', type)
          ..add('format', format)
          ..add('rawDefault', rawDefault)
          ..add('\$enum', $enum)
          ..add('properties', properties)
          ..add('required', required)
          ..add('items', items)
          ..add('additionalProperties', additionalProperties)
          ..add('contentMediaType', contentMediaType)
          ..add('contentSchema', contentSchema)
          ..add('discriminator', discriminator)
          ..add('pattern', pattern)
          ..add('minLength', minLength)
          ..add('maxLength', maxLength)
          ..add('minItems', minItems)
          ..add('maxItems', maxItems)
          ..add('nullable', nullable))
        .toString();
  }
}

class JsonSchemaBuilder implements Builder<JsonSchema, JsonSchemaBuilder> {
  _$JsonSchema? _$v;

  Uri? _id;
  Uri? get id => _$this._id;
  set id(Uri? id) => _$this._id = id;

  Uri? _ref;
  Uri? get ref => _$this._ref;
  set ref(Uri? ref) => _$this._ref = ref;

  ListBuilder<JsonSchema>? _oneOf;
  ListBuilder<JsonSchema> get oneOf => _$this._oneOf ??= ListBuilder<JsonSchema>();
  set oneOf(ListBuilder<JsonSchema>? oneOf) => _$this._oneOf = oneOf;

  ListBuilder<JsonSchema>? _anyOf;
  ListBuilder<JsonSchema> get anyOf => _$this._anyOf ??= ListBuilder<JsonSchema>();
  set anyOf(ListBuilder<JsonSchema>? anyOf) => _$this._anyOf = anyOf;

  ListBuilder<JsonSchema>? _allOf;
  ListBuilder<JsonSchema> get allOf => _$this._allOf ??= ListBuilder<JsonSchema>();
  set allOf(ListBuilder<JsonSchema>? allOf) => _$this._allOf = allOf;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _deprecated;
  bool? get deprecated => _$this._deprecated;
  set deprecated(bool? deprecated) => _$this._deprecated = deprecated;

  JsonSchemaType? _type;
  JsonSchemaType? get type => _$this._type;
  set type(JsonSchemaType? type) => _$this._type = type;

  String? _format;
  String? get format => _$this._format;
  set format(String? format) => _$this._format = format;

  JsonObject? _rawDefault;
  JsonObject? get rawDefault => _$this._rawDefault;
  set rawDefault(JsonObject? rawDefault) => _$this._rawDefault = rawDefault;

  ListBuilder<JsonObject>? _$enum;
  ListBuilder<JsonObject> get $enum => _$this._$enum ??= ListBuilder<JsonObject>();
  set $enum(ListBuilder<JsonObject>? $enum) => _$this._$enum = $enum;

  MapBuilder<String, JsonSchema>? _properties;
  MapBuilder<String, JsonSchema> get properties => _$this._properties ??= MapBuilder<String, JsonSchema>();
  set properties(MapBuilder<String, JsonSchema>? properties) => _$this._properties = properties;

  ListBuilder<String>? _required;
  ListBuilder<String> get required => _$this._required ??= ListBuilder<String>();
  set required(ListBuilder<String>? required) => _$this._required = required;

  JsonSchemaBuilder? _items;
  JsonSchemaBuilder get items => _$this._items ??= JsonSchemaBuilder();
  set items(JsonSchemaBuilder? items) => _$this._items = items;

  JsonSchemaBuilder? _additionalProperties;
  JsonSchemaBuilder get additionalProperties => _$this._additionalProperties ??= JsonSchemaBuilder();
  set additionalProperties(JsonSchemaBuilder? additionalProperties) =>
      _$this._additionalProperties = additionalProperties;

  String? _contentMediaType;
  String? get contentMediaType => _$this._contentMediaType;
  set contentMediaType(String? contentMediaType) => _$this._contentMediaType = contentMediaType;

  JsonSchemaBuilder? _contentSchema;
  JsonSchemaBuilder get contentSchema => _$this._contentSchema ??= JsonSchemaBuilder();
  set contentSchema(JsonSchemaBuilder? contentSchema) => _$this._contentSchema = contentSchema;

  DiscriminatorBuilder? _discriminator;
  DiscriminatorBuilder get discriminator => _$this._discriminator ??= DiscriminatorBuilder();
  set discriminator(DiscriminatorBuilder? discriminator) => _$this._discriminator = discriminator;

  String? _pattern;
  String? get pattern => _$this._pattern;
  set pattern(String? pattern) => _$this._pattern = pattern;

  int? _minLength;
  int? get minLength => _$this._minLength;
  set minLength(int? minLength) => _$this._minLength = minLength;

  int? _maxLength;
  int? get maxLength => _$this._maxLength;
  set maxLength(int? maxLength) => _$this._maxLength = maxLength;

  int? _minItems;
  int? get minItems => _$this._minItems;
  set minItems(int? minItems) => _$this._minItems = minItems;

  int? _maxItems;
  int? get maxItems => _$this._maxItems;
  set maxItems(int? maxItems) => _$this._maxItems = maxItems;

  bool? _nullable;
  bool? get nullable => _$this._nullable;
  set nullable(bool? nullable) => _$this._nullable = nullable;

  JsonSchemaBuilder();

  JsonSchemaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _ref = $v.ref;
      _oneOf = $v.oneOf?.toBuilder();
      _anyOf = $v.anyOf?.toBuilder();
      _allOf = $v.allOf?.toBuilder();
      _description = $v.description;
      _deprecated = $v.deprecated;
      _type = $v.type;
      _format = $v.format;
      _rawDefault = $v.rawDefault;
      _$enum = $v.$enum?.toBuilder();
      _properties = $v.properties?.toBuilder();
      _required = $v.required.toBuilder();
      _items = $v.items?.toBuilder();
      _additionalProperties = $v.additionalProperties?.toBuilder();
      _contentMediaType = $v.contentMediaType;
      _contentSchema = $v.contentSchema?.toBuilder();
      _discriminator = $v.discriminator?.toBuilder();
      _pattern = $v.pattern;
      _minLength = $v.minLength;
      _maxLength = $v.maxLength;
      _minItems = $v.minItems;
      _maxItems = $v.maxItems;
      _nullable = $v.nullable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JsonSchema other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$JsonSchema;
  }

  @override
  void update(void Function(JsonSchemaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JsonSchema build() => _build();

  _$JsonSchema _build() {
    JsonSchema._defaults(this);
    _$JsonSchema _$result;
    try {
      _$result = _$v ??
          _$JsonSchema._(
              id: id,
              ref: ref,
              oneOf: _oneOf?.build(),
              anyOf: _anyOf?.build(),
              allOf: _allOf?.build(),
              description: description,
              deprecated: BuiltValueNullFieldError.checkNotNull(deprecated, r'JsonSchema', 'deprecated'),
              type: type,
              format: format,
              rawDefault: rawDefault,
              $enum: _$enum?.build(),
              properties: _properties?.build(),
              required: required.build(),
              items: _items?.build(),
              additionalProperties: _additionalProperties?.build(),
              contentMediaType: contentMediaType,
              contentSchema: _contentSchema?.build(),
              discriminator: _discriminator?.build(),
              pattern: pattern,
              minLength: minLength,
              maxLength: maxLength,
              minItems: minItems,
              maxItems: maxItems,
              nullable: BuiltValueNullFieldError.checkNotNull(nullable, r'JsonSchema', 'nullable'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'oneOf';
        _oneOf?.build();
        _$failedField = 'anyOf';
        _anyOf?.build();
        _$failedField = 'allOf';
        _allOf?.build();

        _$failedField = '\$enum';
        _$enum?.build();
        _$failedField = 'properties';
        _properties?.build();
        _$failedField = 'required';
        required.build();
        _$failedField = 'items';
        _items?.build();
        _$failedField = 'additionalProperties';
        _additionalProperties?.build();

        _$failedField = 'contentSchema';
        _contentSchema?.build();
        _$failedField = 'discriminator';
        _discriminator?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'JsonSchema', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
