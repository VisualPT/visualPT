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


/** This is an auto generated class representing the SkeletalSequence type in your schema. */
class SkeletalSequence extends amplify_core.Model {
  static const classType = const _SkeletalSequenceModelType();
  final String id;
  final int? _frame_num;
  final String? _nose;
  final String? _left_eye;
  final String? _right_eye;
  final String? _left_ear;
  final String? _right_ear;
  final String? _left_shoulder;
  final String? _right_shoulder;
  final String? _left_elbow;
  final String? _right_elbow;
  final String? _left_wrist;
  final String? _right_wrist;
  final String? _left_hip;
  final String? _right_hip;
  final String? _left_knee;
  final String? _right_knee;
  final String? _left_ankle;
  final String? _right_ankle;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SkeletalSequenceModelIdentifier get modelIdentifier {
      return SkeletalSequenceModelIdentifier(
        id: id
      );
  }
  
  int get frame_num {
    try {
      return _frame_num!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get nose {
    return _nose;
  }
  
  String? get left_eye {
    return _left_eye;
  }
  
  String? get right_eye {
    return _right_eye;
  }
  
  String? get left_ear {
    return _left_ear;
  }
  
  String? get right_ear {
    return _right_ear;
  }
  
  String? get left_shoulder {
    return _left_shoulder;
  }
  
  String? get right_shoulder {
    return _right_shoulder;
  }
  
  String? get left_elbow {
    return _left_elbow;
  }
  
  String? get right_elbow {
    return _right_elbow;
  }
  
  String? get left_wrist {
    return _left_wrist;
  }
  
  String? get right_wrist {
    return _right_wrist;
  }
  
  String? get left_hip {
    return _left_hip;
  }
  
  String? get right_hip {
    return _right_hip;
  }
  
  String? get left_knee {
    return _left_knee;
  }
  
  String? get right_knee {
    return _right_knee;
  }
  
  String? get left_ankle {
    return _left_ankle;
  }
  
  String? get right_ankle {
    return _right_ankle;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const SkeletalSequence._internal({required this.id, required frame_num, nose, left_eye, right_eye, left_ear, right_ear, left_shoulder, right_shoulder, left_elbow, right_elbow, left_wrist, right_wrist, left_hip, right_hip, left_knee, right_knee, left_ankle, right_ankle, createdAt, updatedAt}): _frame_num = frame_num, _nose = nose, _left_eye = left_eye, _right_eye = right_eye, _left_ear = left_ear, _right_ear = right_ear, _left_shoulder = left_shoulder, _right_shoulder = right_shoulder, _left_elbow = left_elbow, _right_elbow = right_elbow, _left_wrist = left_wrist, _right_wrist = right_wrist, _left_hip = left_hip, _right_hip = right_hip, _left_knee = left_knee, _right_knee = right_knee, _left_ankle = left_ankle, _right_ankle = right_ankle, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SkeletalSequence({String? id, required int frame_num, String? nose, String? left_eye, String? right_eye, String? left_ear, String? right_ear, String? left_shoulder, String? right_shoulder, String? left_elbow, String? right_elbow, String? left_wrist, String? right_wrist, String? left_hip, String? right_hip, String? left_knee, String? right_knee, String? left_ankle, String? right_ankle}) {
    return SkeletalSequence._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      frame_num: frame_num,
      nose: nose,
      left_eye: left_eye,
      right_eye: right_eye,
      left_ear: left_ear,
      right_ear: right_ear,
      left_shoulder: left_shoulder,
      right_shoulder: right_shoulder,
      left_elbow: left_elbow,
      right_elbow: right_elbow,
      left_wrist: left_wrist,
      right_wrist: right_wrist,
      left_hip: left_hip,
      right_hip: right_hip,
      left_knee: left_knee,
      right_knee: right_knee,
      left_ankle: left_ankle,
      right_ankle: right_ankle);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SkeletalSequence &&
      id == other.id &&
      _frame_num == other._frame_num &&
      _nose == other._nose &&
      _left_eye == other._left_eye &&
      _right_eye == other._right_eye &&
      _left_ear == other._left_ear &&
      _right_ear == other._right_ear &&
      _left_shoulder == other._left_shoulder &&
      _right_shoulder == other._right_shoulder &&
      _left_elbow == other._left_elbow &&
      _right_elbow == other._right_elbow &&
      _left_wrist == other._left_wrist &&
      _right_wrist == other._right_wrist &&
      _left_hip == other._left_hip &&
      _right_hip == other._right_hip &&
      _left_knee == other._left_knee &&
      _right_knee == other._right_knee &&
      _left_ankle == other._left_ankle &&
      _right_ankle == other._right_ankle;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SkeletalSequence {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("frame_num=" + (_frame_num != null ? _frame_num!.toString() : "null") + ", ");
    buffer.write("nose=" + "$_nose" + ", ");
    buffer.write("left_eye=" + "$_left_eye" + ", ");
    buffer.write("right_eye=" + "$_right_eye" + ", ");
    buffer.write("left_ear=" + "$_left_ear" + ", ");
    buffer.write("right_ear=" + "$_right_ear" + ", ");
    buffer.write("left_shoulder=" + "$_left_shoulder" + ", ");
    buffer.write("right_shoulder=" + "$_right_shoulder" + ", ");
    buffer.write("left_elbow=" + "$_left_elbow" + ", ");
    buffer.write("right_elbow=" + "$_right_elbow" + ", ");
    buffer.write("left_wrist=" + "$_left_wrist" + ", ");
    buffer.write("right_wrist=" + "$_right_wrist" + ", ");
    buffer.write("left_hip=" + "$_left_hip" + ", ");
    buffer.write("right_hip=" + "$_right_hip" + ", ");
    buffer.write("left_knee=" + "$_left_knee" + ", ");
    buffer.write("right_knee=" + "$_right_knee" + ", ");
    buffer.write("left_ankle=" + "$_left_ankle" + ", ");
    buffer.write("right_ankle=" + "$_right_ankle" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SkeletalSequence copyWith({int? frame_num, String? nose, String? left_eye, String? right_eye, String? left_ear, String? right_ear, String? left_shoulder, String? right_shoulder, String? left_elbow, String? right_elbow, String? left_wrist, String? right_wrist, String? left_hip, String? right_hip, String? left_knee, String? right_knee, String? left_ankle, String? right_ankle}) {
    return SkeletalSequence._internal(
      id: id,
      frame_num: frame_num ?? this.frame_num,
      nose: nose ?? this.nose,
      left_eye: left_eye ?? this.left_eye,
      right_eye: right_eye ?? this.right_eye,
      left_ear: left_ear ?? this.left_ear,
      right_ear: right_ear ?? this.right_ear,
      left_shoulder: left_shoulder ?? this.left_shoulder,
      right_shoulder: right_shoulder ?? this.right_shoulder,
      left_elbow: left_elbow ?? this.left_elbow,
      right_elbow: right_elbow ?? this.right_elbow,
      left_wrist: left_wrist ?? this.left_wrist,
      right_wrist: right_wrist ?? this.right_wrist,
      left_hip: left_hip ?? this.left_hip,
      right_hip: right_hip ?? this.right_hip,
      left_knee: left_knee ?? this.left_knee,
      right_knee: right_knee ?? this.right_knee,
      left_ankle: left_ankle ?? this.left_ankle,
      right_ankle: right_ankle ?? this.right_ankle);
  }
  
  SkeletalSequence copyWithModelFieldValues({
    ModelFieldValue<int>? frame_num,
    ModelFieldValue<String?>? nose,
    ModelFieldValue<String?>? left_eye,
    ModelFieldValue<String?>? right_eye,
    ModelFieldValue<String?>? left_ear,
    ModelFieldValue<String?>? right_ear,
    ModelFieldValue<String?>? left_shoulder,
    ModelFieldValue<String?>? right_shoulder,
    ModelFieldValue<String?>? left_elbow,
    ModelFieldValue<String?>? right_elbow,
    ModelFieldValue<String?>? left_wrist,
    ModelFieldValue<String?>? right_wrist,
    ModelFieldValue<String?>? left_hip,
    ModelFieldValue<String?>? right_hip,
    ModelFieldValue<String?>? left_knee,
    ModelFieldValue<String?>? right_knee,
    ModelFieldValue<String?>? left_ankle,
    ModelFieldValue<String?>? right_ankle
  }) {
    return SkeletalSequence._internal(
      id: id,
      frame_num: frame_num == null ? this.frame_num : frame_num.value,
      nose: nose == null ? this.nose : nose.value,
      left_eye: left_eye == null ? this.left_eye : left_eye.value,
      right_eye: right_eye == null ? this.right_eye : right_eye.value,
      left_ear: left_ear == null ? this.left_ear : left_ear.value,
      right_ear: right_ear == null ? this.right_ear : right_ear.value,
      left_shoulder: left_shoulder == null ? this.left_shoulder : left_shoulder.value,
      right_shoulder: right_shoulder == null ? this.right_shoulder : right_shoulder.value,
      left_elbow: left_elbow == null ? this.left_elbow : left_elbow.value,
      right_elbow: right_elbow == null ? this.right_elbow : right_elbow.value,
      left_wrist: left_wrist == null ? this.left_wrist : left_wrist.value,
      right_wrist: right_wrist == null ? this.right_wrist : right_wrist.value,
      left_hip: left_hip == null ? this.left_hip : left_hip.value,
      right_hip: right_hip == null ? this.right_hip : right_hip.value,
      left_knee: left_knee == null ? this.left_knee : left_knee.value,
      right_knee: right_knee == null ? this.right_knee : right_knee.value,
      left_ankle: left_ankle == null ? this.left_ankle : left_ankle.value,
      right_ankle: right_ankle == null ? this.right_ankle : right_ankle.value
    );
  }
  
  SkeletalSequence.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _frame_num = (json['frame_num'] as num?)?.toInt(),
      _nose = json['nose'],
      _left_eye = json['left_eye'],
      _right_eye = json['right_eye'],
      _left_ear = json['left_ear'],
      _right_ear = json['right_ear'],
      _left_shoulder = json['left_shoulder'],
      _right_shoulder = json['right_shoulder'],
      _left_elbow = json['left_elbow'],
      _right_elbow = json['right_elbow'],
      _left_wrist = json['left_wrist'],
      _right_wrist = json['right_wrist'],
      _left_hip = json['left_hip'],
      _right_hip = json['right_hip'],
      _left_knee = json['left_knee'],
      _right_knee = json['right_knee'],
      _left_ankle = json['left_ankle'],
      _right_ankle = json['right_ankle'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'frame_num': _frame_num, 'nose': _nose, 'left_eye': _left_eye, 'right_eye': _right_eye, 'left_ear': _left_ear, 'right_ear': _right_ear, 'left_shoulder': _left_shoulder, 'right_shoulder': _right_shoulder, 'left_elbow': _left_elbow, 'right_elbow': _right_elbow, 'left_wrist': _left_wrist, 'right_wrist': _right_wrist, 'left_hip': _left_hip, 'right_hip': _right_hip, 'left_knee': _left_knee, 'right_knee': _right_knee, 'left_ankle': _left_ankle, 'right_ankle': _right_ankle, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'frame_num': _frame_num,
    'nose': _nose,
    'left_eye': _left_eye,
    'right_eye': _right_eye,
    'left_ear': _left_ear,
    'right_ear': _right_ear,
    'left_shoulder': _left_shoulder,
    'right_shoulder': _right_shoulder,
    'left_elbow': _left_elbow,
    'right_elbow': _right_elbow,
    'left_wrist': _left_wrist,
    'right_wrist': _right_wrist,
    'left_hip': _left_hip,
    'right_hip': _right_hip,
    'left_knee': _left_knee,
    'right_knee': _right_knee,
    'left_ankle': _left_ankle,
    'right_ankle': _right_ankle,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SkeletalSequenceModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SkeletalSequenceModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final FRAME_NUM = amplify_core.QueryField(fieldName: "frame_num");
  static final NOSE = amplify_core.QueryField(fieldName: "nose");
  static final LEFT_EYE = amplify_core.QueryField(fieldName: "left_eye");
  static final RIGHT_EYE = amplify_core.QueryField(fieldName: "right_eye");
  static final LEFT_EAR = amplify_core.QueryField(fieldName: "left_ear");
  static final RIGHT_EAR = amplify_core.QueryField(fieldName: "right_ear");
  static final LEFT_SHOULDER = amplify_core.QueryField(fieldName: "left_shoulder");
  static final RIGHT_SHOULDER = amplify_core.QueryField(fieldName: "right_shoulder");
  static final LEFT_ELBOW = amplify_core.QueryField(fieldName: "left_elbow");
  static final RIGHT_ELBOW = amplify_core.QueryField(fieldName: "right_elbow");
  static final LEFT_WRIST = amplify_core.QueryField(fieldName: "left_wrist");
  static final RIGHT_WRIST = amplify_core.QueryField(fieldName: "right_wrist");
  static final LEFT_HIP = amplify_core.QueryField(fieldName: "left_hip");
  static final RIGHT_HIP = amplify_core.QueryField(fieldName: "right_hip");
  static final LEFT_KNEE = amplify_core.QueryField(fieldName: "left_knee");
  static final RIGHT_KNEE = amplify_core.QueryField(fieldName: "right_knee");
  static final LEFT_ANKLE = amplify_core.QueryField(fieldName: "left_ankle");
  static final RIGHT_ANKLE = amplify_core.QueryField(fieldName: "right_ankle");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SkeletalSequence";
    modelSchemaDefinition.pluralName = "SkeletalSequences";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.FRAME_NUM,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.NOSE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.LEFT_EYE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.RIGHT_EYE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.LEFT_EAR,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.RIGHT_EAR,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.LEFT_SHOULDER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.RIGHT_SHOULDER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.LEFT_ELBOW,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.RIGHT_ELBOW,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.LEFT_WRIST,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.RIGHT_WRIST,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.LEFT_HIP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.RIGHT_HIP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.LEFT_KNEE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.RIGHT_KNEE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.LEFT_ANKLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: SkeletalSequence.RIGHT_ANKLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _SkeletalSequenceModelType extends amplify_core.ModelType<SkeletalSequence> {
  const _SkeletalSequenceModelType();
  
  @override
  SkeletalSequence fromJson(Map<String, dynamic> jsonData) {
    return SkeletalSequence.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'SkeletalSequence';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SkeletalSequence] in your schema.
 */
class SkeletalSequenceModelIdentifier implements amplify_core.ModelIdentifier<SkeletalSequence> {
  final String id;

  /** Create an instance of SkeletalSequenceModelIdentifier using [id] the primary key. */
  const SkeletalSequenceModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'SkeletalSequenceModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SkeletalSequenceModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}