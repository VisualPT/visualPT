import { type ClientSchema, a, defineData } from "@aws-amplify/backend";

const schema = a.schema({
  Gender: a.enum(["MALE", "FEMALE"]),
  AgeRange: a.enum([
    "BABY_0_5",
    "CHILD_6_12",
    "TEEN_13_19",
    "ADULT_20_39",
    "ADULT_40_64",
    "SENIOR_65_69",
    "SENIOR_70_79",
    "SENIOR_80_84",
    "SENIOR_85_PLUS",
  ]),
  AssessmentType: a.enum([
    "CTSIB",
    "MCTSIB",
    "GAIT",
    "BERG",
    "REACH",
    "FIST",
    "DEV",
  ]),
  CameraDirection: a.enum(["FRONT", "BACK"]),
  FallHistory: a.enum(["NONE", "FEW", "RECURRING"]),
  DetectionEnv: a.customType({
    timestamp: a.datetime().required(),
    accX: a.float().required(),
    accY: a.float().required(),
    accZ: a.float().required(),
  }),
  Detection: a.customType({
    obtrustion: a.boolean().required(),
    instability: a.boolean().required(),
    direction: a.ref("CameraDirection").required(),
    env: a.ref("DetectionEnv").required(),
    keypoints: a.string().required(),
    prediction: a.string(),
  }),
  Norm: a
    .model({
      type: a.ref("AssessmentType").required(),
      stageNumber: a.integer().required(),
      ageRange: a.ref("AgeRange").required(),
      gender: a.ref("Gender").required(),
      scoreSum: a.float().required(),
      trialSum: a.integer().required(),
    })
    .authorization((allow) => [allow.authenticated()]),
  Profile: a
    .model({
      email: a.email().required(),
      firstName: a.string().required(),
      lastName: a.string().required(),
      dob: a.date().required(),
      gender: a.ref("Gender").required(),
      height: a.float().required(), // in inches
      assessments: a.hasMany("Assessment", "profileId"),
    })
    .secondaryIndexes((index) => [index("email")])
    .authorization((allow) => [allow.owner(), allow.group("admin")]),
  Assessment: a
    .model({
      type: a.ref("AssessmentType").required(),
      duration: a.float().required(),
      pdf: a.string(),
      extra: a.string().required(), // a string parsable into a JSON object defined by the BaseAssessment.formField schema
      createdAt: a.datetime().required(),
      profileId: a.id().required(),
      profile: a.belongsTo("Profile", "profileId"),
      stages: a.hasMany("Stage", "assessmentId"),
    })
    .secondaryIndexes((index) => [index("profileId")])
    .authorization((allow) => [allow.owner(), allow.group("admin")]),
  Stage: a
    .model({
      stageNumber: a.integer().required(),
      duration: a.float().required(),
      assessmentId: a.id().required(),
      assessment: a.belongsTo("Assessment", "assessmentId"),
      trials: a.hasMany("Trial", "stageId"),
    })
    .secondaryIndexes((index) => [index("assessmentId")])
    .authorization((allow) => [allow.owner(), allow.group("admin")]),
  Trial: a
    .model({
      startTime: a.datetime().required(),
      duration: a.float().required(),
      stageId: a.id().required(),
      stage: a.belongsTo("Stage", "stageId"),
      compressedDetections: a.string().required(), // a base 64 gzip of detection data
    })
    .secondaryIndexes((index) => [index("stageId")])
    .authorization((allow) => [allow.owner(), allow.group("admin")]),
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: "userPool",
  },
});

/*== STEP 2 ===============================================================
Go to your frontend source code. From your client-side code, generate a
Data client to make CRUDL requests to your table. (THIS SNIPPET WILL ONLY
WORK IN THE FRONTEND CODE FILE.)

Using JavaScript or Next.js React Server Components, Middleware, Server 
Actions or Pages Router? Review how to generate Data clients for those use
cases: https://docs.amplify.aws/gen2/build-a-backend/data/connect-to-API/
=========================================================================*/

/*
"use client"
import { generateClient } from "aws-amplify/data";
import type { Schema } from "@/amplify/data/resource";

const client = generateClient<Schema>() // use this Data client for CRUDL requests
*/

/*== STEP 3 ===============================================================
Fetch records from the database and use them in your frontend component.
(THIS SNIPPET WILL ONLY WORK IN THE FRONTEND CODE FILE.)
=========================================================================*/

/* For example, in a React component, you can use this snippet in your
  function's RETURN statement */
// const { data: todos } = await client.models.Todo.list()

// return <ul>{todos.map(todo => <li key={todo.id}>{todo.content}</li>)}</ul>
