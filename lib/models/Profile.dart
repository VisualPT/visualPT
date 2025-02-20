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

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Profile type in your schema. */
class Profile extends amplify_core.Model {
  static const classType = const _ProfileModelType();
  final String id;
  final String? _email;
  final String? _firstName;
  final String? _lastName;
  final amplify_core.TemporalDate? _dob;
  final Gender? _gender;
  final double? _height;
  final List<Assessment>? _assessments;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ProfileModelIdentifier get modelIdentifier {
      return ProfileModelIdentifier(
        id: id
      );
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get firstName {
    try {
      return _firstName!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get lastName {
    try {
      return _lastName!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDate get dob {
    try {
      return _dob!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Gender get gender {
    try {
      return _gender!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get height {
    try {
      return _height!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Assessment>? get assessments {
    return _assessments;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Profile._internal({required this.id, required email, required firstName, required lastName, required dob, required gender, required height, assessments, createdAt, updatedAt}): _email = email, _firstName = firstName, _lastName = lastName, _dob = dob, _gender = gender, _height = height, _assessments = assessments, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Profile({String? id, required String email, required String firstName, required String lastName, required amplify_core.TemporalDate dob, required Gender gender, required double height, List<Assessment>? assessments}) {
    return Profile._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      dob: dob,
      gender: gender,
      height: height,
      assessments: assessments != null ? List<Assessment>.unmodifiable(assessments) : assessments);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Profile &&
      id == other.id &&
      _email == other._email &&
      _firstName == other._firstName &&
      _lastName == other._lastName &&
      _dob == other._dob &&
      _gender == other._gender &&
      _height == other._height &&
      DeepCollectionEquality().equals(_assessments, other._assessments);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Profile {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("firstName=" + "$_firstName" + ", ");
    buffer.write("lastName=" + "$_lastName" + ", ");
    buffer.write("dob=" + (_dob != null ? _dob!.format() : "null") + ", ");
    buffer.write("gender=" + (_gender != null ? amplify_core.enumToString(_gender)! : "null") + ", ");
    buffer.write("height=" + (_height != null ? _height!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Profile copyWith({String? email, String? firstName, String? lastName, amplify_core.TemporalDate? dob, Gender? gender, double? height, List<Assessment>? assessments}) {
    return Profile._internal(
      id: id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      assessments: assessments ?? this.assessments);
  }
  
  Profile copyWithModelFieldValues({
    ModelFieldValue<String>? email,
    ModelFieldValue<String>? firstName,
    ModelFieldValue<String>? lastName,
    ModelFieldValue<amplify_core.TemporalDate>? dob,
    ModelFieldValue<Gender>? gender,
    ModelFieldValue<double>? height,
    ModelFieldValue<List<Assessment>?>? assessments
  }) {
    return Profile._internal(
      id: id,
      email: email == null ? this.email : email.value,
      firstName: firstName == null ? this.firstName : firstName.value,
      lastName: lastName == null ? this.lastName : lastName.value,
      dob: dob == null ? this.dob : dob.value,
      gender: gender == null ? this.gender : gender.value,
      height: height == null ? this.height : height.value,
      assessments: assessments == null ? this.assessments : assessments.value
    );
  }
  
  Profile.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _email = json['email'],
      _firstName = json['firstName'],
      _lastName = json['lastName'],
      _dob = json['dob'] != null ? amplify_core.TemporalDate.fromString(json['dob']) : null,
      _gender = amplify_core.enumFromString<Gender>(json['gender'], Gender.values),
      _height = (json['height'] as num?)?.toDouble(),
      _assessments = json['assessments']  is Map
        ? (json['assessments']['items'] is List
          ? (json['assessments']['items'] as List)
              .where((e) => e != null)
              .map((e) => Assessment.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['assessments'] is List
          ? (json['assessments'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Assessment.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'email': _email, 'firstName': _firstName, 'lastName': _lastName, 'dob': _dob?.format(), 'gender': amplify_core.enumToString(_gender), 'height': _height, 'assessments': _assessments?.map((Assessment? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'email': _email,
    'firstName': _firstName,
    'lastName': _lastName,
    'dob': _dob,
    'gender': _gender,
    'height': _height,
    'assessments': _assessments,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ProfileModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ProfileModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final FIRSTNAME = amplify_core.QueryField(fieldName: "firstName");
  static final LASTNAME = amplify_core.QueryField(fieldName: "lastName");
  static final DOB = amplify_core.QueryField(fieldName: "dob");
  static final GENDER = amplify_core.QueryField(fieldName: "gender");
  static final HEIGHT = amplify_core.QueryField(fieldName: "height");
  static final ASSESSMENTS = amplify_core.QueryField(
    fieldName: "assessments",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Assessment'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Profile";
    modelSchemaDefinition.pluralName = "Profiles";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groups: [ "admin" ],
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["email"], name: "profilesByEmail")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Profile.EMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Profile.FIRSTNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Profile.LASTNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Profile.DOB,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Profile.GENDER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Profile.HEIGHT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Profile.ASSESSMENTS,
      isRequired: false,
      ofModelName: 'Assessment',
      associatedKey: Assessment.PROFILE
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

class _ProfileModelType extends amplify_core.ModelType<Profile> {
  const _ProfileModelType();
  
  @override
  Profile fromJson(Map<String, dynamic> jsonData) {
    return Profile.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Profile';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Profile] in your schema.
 */
class ProfileModelIdentifier implements amplify_core.ModelIdentifier<Profile> {
  final String id;

  /** Create an instance of ProfileModelIdentifier using [id] the primary key. */
  const ProfileModelIdentifier({
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
  String toString() => 'ProfileModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ProfileModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}