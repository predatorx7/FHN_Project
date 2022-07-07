import 'camelcase.dart';
import '../cache/x.dart';

const classKeyName = r'__$class';

void main() {
  final y = generateJsonSerializableDataClass(
    x[classKeyName],
    x,
  );
  print(y);
}

String generateJsonSerializableDataClass(
  String serializableClassName,
  Map<String, dynamic> data,
) {
  final fieldDeclarations = StringBuffer();
  final constructorParameterDeclarations = StringBuffer('\n');

  void addFieldDeclaration(MapEntry<String, dynamic> fieldEntry) {
    final code = generateFieldDeclaration(fieldEntry.key, fieldEntry.value);
    fieldDeclarations.writeln(code);
  }

  void addConstructorParameterDeclarations(
    MapEntry<String, dynamic> fieldEntry,
  ) {
    final code = generateConstructorParameterDeclaration(fieldEntry.key);
    constructorParameterDeclarations.writeln('$code,');
  }

  for (final fieldEntry in data.entries) {
    if (fieldEntry.key == classKeyName) {
      continue;
    }
    addFieldDeclaration(fieldEntry);
    addConstructorParameterDeclarations(fieldEntry);
  }

  final code = generateSerializableClassCode(
    serializableClassName,
    fieldDeclarations.toString(),
    constructorParameterDeclarations.toString(),
  );

  return "import 'package:json_annotation/json_annotation.dart';\n\n$code";
}

String generateConstructorParameterDeclaration(String fieldKeyName) {
  final parameterName = lowerCamelCase(fieldKeyName);
  return '''  this.$parameterName''';
}

String guessDataType(Object? value,
    [bool changeUnknownWithDynamicJson = true]) {
  if (value is String) {
    return 'String';
  } else if (value is int || value is double) {
    return 'num';
  } else if (value is bool) {
    return 'bool';
  } else if (value is List) {
    return 'List<UNKNOWN_DATA_TYPE>';
  } else if (value == null) {
    return changeUnknownWithDynamicJson ? 'DynamicJson' : 'dynamic';
  } else {
    return 'UNKNOWN_DATA_TYPE';
  }
}

String typed(String dataType, [bool makeNullable = true]) {
  if (dataType.isEmpty) {
    return '';
  } else if (dataType == 'dynamic' || !makeNullable) {
    return ' $dataType';
  } else {
    return ' $dataType?';
  }
}

String generateFieldDeclaration(
  String fieldKeyName,
  Object? fieldValue,
) {
  final fieldVariableName = lowerCamelCase(fieldKeyName);
  final fieldDataType = typed(guessDataType(fieldValue));

  return '''  @JsonKey(name: '$fieldKeyName')
  final$fieldDataType $fieldVariableName;''';
}

String generateSerializableClassCode(
  String serializableClassName,
  String fieldDeclarations,
  String constructorParameterDeclarations,
) {
  return '''@JsonSerializable()
class $serializableClassName {
$fieldDeclarations

  const $serializableClassName($constructorParameterDeclarations);

  factory $serializableClassName.fromJson(Map<String, dynamic> json) =>
      _\$${serializableClassName}FromJson(json);

  Map<String, dynamic> toJson() => _\$${serializableClassName}ToJson(this);
}
''';
}
