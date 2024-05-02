import 'package:dynamite/src/builder/resolve_interface.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/built_value.dart';
import 'package:dynamite/src/models/json_schema.dart' as json_schema;
import 'package:dynamite/src/models/type_result.dart';

TypeResultObject resolveObject(
  State state,
  json_schema.JsonSchema schema, {
  bool nullable = false,
  bool isHeader = false,
}) {
  final result = TypeResultObject(
    schema.identifier!,
    nullable: nullable,
  );

  if (state.resolvedTypes.add(result)) {
    final $interface = buildInterface(
      state,
      schema,
      nullable: nullable,
      isHeader: isHeader,
    );

    final $class = buildBuiltClass(
      state,
      schema,
    );

    state.output.addAll([
      $interface,
      $class,
    ]);
  }
  return result;
}
