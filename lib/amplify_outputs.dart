const amplifyConfig = r'''{
  "auth": {
    "user_pool_id": "us-east-1_ucLGcxftE",
    "aws_region": "us-east-1",
    "user_pool_client_id": "1h1jkl8f33rp3n3pa2sda1gfbg",
    "identity_pool_id": "us-east-1:6cf4217e-1d2a-42f9-9051-fbc7c5f35e7a",
    "mfa_methods": [],
    "standard_required_attributes": [
      "email"
    ],
    "username_attributes": [
      "email"
    ],
    "user_verification_types": [
      "email"
    ],
    "groups": [
      {
        "admin": {
          "precedence": 0
        }
      }
    ],
    "mfa_configuration": "NONE",
    "password_policy": {
      "min_length": 8,
      "require_lowercase": true,
      "require_numbers": true,
      "require_symbols": true,
      "require_uppercase": true
    },
    "unauthenticated_identities_enabled": true
  },
  "data": {
    "url": "https://6o3r2yxyifdmxmmn2ys624x66q.appsync-api.us-east-1.amazonaws.com/graphql",
    "aws_region": "us-east-1",
    "default_authorization_type": "AMAZON_COGNITO_USER_POOLS",
    "authorization_types": [
      "AWS_IAM"
    ],
    "model_introspection": {
      "version": 1,
      "models": {
        "Norm": {
          "name": "Norm",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "type": {
              "name": "type",
              "isArray": false,
              "type": {
                "enum": "AssessmentType"
              },
              "isRequired": true,
              "attributes": []
            },
            "stageNumber": {
              "name": "stageNumber",
              "isArray": false,
              "type": "Int",
              "isRequired": true,
              "attributes": []
            },
            "ageRange": {
              "name": "ageRange",
              "isArray": false,
              "type": {
                "enum": "AgeRange"
              },
              "isRequired": true,
              "attributes": []
            },
            "gender": {
              "name": "gender",
              "isArray": false,
              "type": {
                "enum": "Gender"
              },
              "isRequired": true,
              "attributes": []
            },
            "scoreSum": {
              "name": "scoreSum",
              "isArray": false,
              "type": "Float",
              "isRequired": true,
              "attributes": []
            },
            "trialSum": {
              "name": "trialSum",
              "isArray": false,
              "type": "Int",
              "isRequired": true,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Norms",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Profile": {
          "name": "Profile",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "email": {
              "name": "email",
              "isArray": false,
              "type": "AWSEmail",
              "isRequired": true,
              "attributes": []
            },
            "firstName": {
              "name": "firstName",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "lastName": {
              "name": "lastName",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "dob": {
              "name": "dob",
              "isArray": false,
              "type": "AWSDate",
              "isRequired": true,
              "attributes": []
            },
            "gender": {
              "name": "gender",
              "isArray": false,
              "type": {
                "enum": "Gender"
              },
              "isRequired": true,
              "attributes": []
            },
            "height": {
              "name": "height",
              "isArray": false,
              "type": "Float",
              "isRequired": true,
              "attributes": []
            },
            "assessments": {
              "name": "assessments",
              "isArray": true,
              "type": {
                "model": "Assessment"
              },
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": true,
              "association": {
                "connectionType": "HAS_MANY",
                "associatedWith": [
                  "profileId"
                ]
              }
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Profiles",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "key",
              "properties": {
                "name": "profilesByEmail",
                "queryField": "listProfileByEmail",
                "fields": [
                  "email"
                ]
              }
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "provider": "userPools",
                    "ownerField": "owner",
                    "allow": "owner",
                    "identityClaim": "cognito:username",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  },
                  {
                    "groupClaim": "cognito:groups",
                    "provider": "userPools",
                    "allow": "groups",
                    "groups": [
                      "admin"
                    ],
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Assessment": {
          "name": "Assessment",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "type": {
              "name": "type",
              "isArray": false,
              "type": {
                "enum": "AssessmentType"
              },
              "isRequired": true,
              "attributes": []
            },
            "duration": {
              "name": "duration",
              "isArray": false,
              "type": "Float",
              "isRequired": true,
              "attributes": []
            },
            "pdf": {
              "name": "pdf",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "extra": {
              "name": "extra",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": true,
              "attributes": []
            },
            "profileId": {
              "name": "profileId",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "profile": {
              "name": "profile",
              "isArray": false,
              "type": {
                "model": "Profile"
              },
              "isRequired": false,
              "attributes": [],
              "association": {
                "connectionType": "BELONGS_TO",
                "targetNames": [
                  "profileId"
                ]
              }
            },
            "stages": {
              "name": "stages",
              "isArray": true,
              "type": {
                "model": "Stage"
              },
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": true,
              "association": {
                "connectionType": "HAS_MANY",
                "associatedWith": [
                  "assessmentId"
                ]
              }
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Assessments",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "key",
              "properties": {
                "name": "assessmentsByProfileId",
                "queryField": "listAssessmentByProfileId",
                "fields": [
                  "profileId"
                ]
              }
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "provider": "userPools",
                    "ownerField": "owner",
                    "allow": "owner",
                    "identityClaim": "cognito:username",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  },
                  {
                    "groupClaim": "cognito:groups",
                    "provider": "userPools",
                    "allow": "groups",
                    "groups": [
                      "admin"
                    ],
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Stage": {
          "name": "Stage",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "stageNumber": {
              "name": "stageNumber",
              "isArray": false,
              "type": "Int",
              "isRequired": true,
              "attributes": []
            },
            "duration": {
              "name": "duration",
              "isArray": false,
              "type": "Float",
              "isRequired": true,
              "attributes": []
            },
            "assessmentId": {
              "name": "assessmentId",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "assessment": {
              "name": "assessment",
              "isArray": false,
              "type": {
                "model": "Assessment"
              },
              "isRequired": false,
              "attributes": [],
              "association": {
                "connectionType": "BELONGS_TO",
                "targetNames": [
                  "assessmentId"
                ]
              }
            },
            "trials": {
              "name": "trials",
              "isArray": true,
              "type": {
                "model": "Trial"
              },
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": true,
              "association": {
                "connectionType": "HAS_MANY",
                "associatedWith": [
                  "stageId"
                ]
              }
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Stages",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "key",
              "properties": {
                "name": "stagesByAssessmentId",
                "queryField": "listStageByAssessmentId",
                "fields": [
                  "assessmentId"
                ]
              }
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "provider": "userPools",
                    "ownerField": "owner",
                    "allow": "owner",
                    "identityClaim": "cognito:username",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  },
                  {
                    "groupClaim": "cognito:groups",
                    "provider": "userPools",
                    "allow": "groups",
                    "groups": [
                      "admin"
                    ],
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "Trial": {
          "name": "Trial",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "startTime": {
              "name": "startTime",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": true,
              "attributes": []
            },
            "duration": {
              "name": "duration",
              "isArray": false,
              "type": "Float",
              "isRequired": true,
              "attributes": []
            },
            "stageId": {
              "name": "stageId",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "stage": {
              "name": "stage",
              "isArray": false,
              "type": {
                "model": "Stage"
              },
              "isRequired": false,
              "attributes": [],
              "association": {
                "connectionType": "BELONGS_TO",
                "targetNames": [
                  "stageId"
                ]
              }
            },
            "compressedKeypoints": {
              "name": "compressedKeypoints",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "Trials",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "key",
              "properties": {
                "name": "trialsByStageId",
                "queryField": "listTrialByStageId",
                "fields": [
                  "stageId"
                ]
              }
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "provider": "userPools",
                    "ownerField": "owner",
                    "allow": "owner",
                    "identityClaim": "cognito:username",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  },
                  {
                    "groupClaim": "cognito:groups",
                    "provider": "userPools",
                    "allow": "groups",
                    "groups": [
                      "admin"
                    ],
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        }
      },
      "enums": {
        "Gender": {
          "name": "Gender",
          "values": [
            "MALE",
            "FEMALE"
          ]
        },
        "AgeRange": {
          "name": "AgeRange",
          "values": [
            "BABY_0_5",
            "CHILD_6_12",
            "TEEN_13_19",
            "ADULT_20_39",
            "ADULT_40_64",
            "SENIOR_65_69",
            "SENIOR_70_79",
            "SENIOR_80_84",
            "SENIOR_85_PLUS"
          ]
        },
        "AssessmentType": {
          "name": "AssessmentType",
          "values": [
            "CTSIB",
            "MCTSIB",
            "GAIT",
            "BERG",
            "REACH",
            "FIST",
            "DEV"
          ]
        },
        "FallHistory": {
          "name": "FallHistory",
          "values": [
            "NONE",
            "FEW",
            "RECURRING"
          ]
        }
      },
      "nonModels": {
        "DetectionEnv": {
          "name": "DetectionEnv",
          "fields": {
            "timestamp": {
              "name": "timestamp",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": true,
              "attributes": []
            },
            "accX": {
              "name": "accX",
              "isArray": false,
              "type": "Float",
              "isRequired": true,
              "attributes": []
            },
            "accY": {
              "name": "accY",
              "isArray": false,
              "type": "Float",
              "isRequired": true,
              "attributes": []
            },
            "accZ": {
              "name": "accZ",
              "isArray": false,
              "type": "Float",
              "isRequired": true,
              "attributes": []
            }
          }
        },
        "Detection": {
          "name": "Detection",
          "fields": {
            "obtrustion": {
              "name": "obtrustion",
              "isArray": false,
              "type": "Boolean",
              "isRequired": true,
              "attributes": []
            },
            "instability": {
              "name": "instability",
              "isArray": false,
              "type": "Boolean",
              "isRequired": true,
              "attributes": []
            },
            "env": {
              "name": "env",
              "isArray": false,
              "type": {
                "nonModel": "DetectionEnv"
              },
              "isRequired": true,
              "attributes": []
            },
            "keypoints": {
              "name": "keypoints",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "prediction": {
              "name": "prediction",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            }
          }
        }
      }
    }
  },
  "version": "1.3"
}''';