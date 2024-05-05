/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the Segment type in your schema. */
class Segment {
  final int? _duration_seconds;
  final String? _file;

  int get duration_seconds {
    try {
      return _duration_seconds!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get file {
    try {
      return _file!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const Segment._internal({required duration_seconds, required file}): _duration_seconds = duration_seconds, _file = file;
  
  factory Segment({required int duration_seconds, required String file}) {
    return Segment._internal(
      duration_seconds: duration_seconds,
      file: file);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Segment &&
      _duration_seconds == other._duration_seconds &&
      _file == other._file;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Segment {");
    buffer.write("duration_seconds=" + (_duration_seconds != null ? _duration_seconds!.toString() : "null") + ", ");
    buffer.write("file=" + "$_file");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Segment copyWith({int? duration_seconds, String? file}) {
    return Segment._internal(
      duration_seconds: duration_seconds ?? this.duration_seconds,
      file: file ?? this.file);
  }
  
  Segment copyWithModelFieldValues({
    ModelFieldValue<int>? duration_seconds,
    ModelFieldValue<String>? file
  }) {
    return Segment._internal(
      duration_seconds: duration_seconds == null ? this.duration_seconds : duration_seconds.value,
      file: file == null ? this.file : file.value
    );
  }
  
  Segment.fromJson(Map<String, dynamic> json)  
    : _duration_seconds = (json['duration_seconds'] as num?)?.toInt(),
      _file = json['file'];
  
  Map<String, dynamic> toJson() => {
    'duration_seconds': _duration_seconds, 'file': _file
  };
  
  Map<String, Object?> toMap() => {
    'duration_seconds': _duration_seconds,
    'file': _file
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Segment";
    modelSchemaDefinition.pluralName = "Segments";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'duration_seconds',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'file',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}