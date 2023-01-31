import 'dart:developer';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/styles.dart';

class PatientForm extends StatefulWidget {
  const PatientForm({Key? key}) : super(key: key);

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  Patient patient = Patient(
      first_name: "TODO",
      last_name: "TODO",
      dob: TemporalDate(DateTime.now()),
      gender: Gender.MALE,
      height_in_inches: 0);
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: CupertinoColors.link,
      onPressed: showFormDialog,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("New Patient"),
        ],
      ),
    );
  }

  Future<void> showFormDialog() {
    return showCupertinoModalPopup(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return CupertinoAlertDialog(
          title: const Text('Patient Information'),
          content: Form(
            key: _formKey,
            child: SizedBox(
              height: 310,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Who is being treated?"),
                  _formInput("First Name"),
                  _formInput("Last Name"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Birth Date"),
                          CupertinoButton(
                            onPressed: () => showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) => Container(
                                      height: 216,
                                      padding: const EdgeInsets.only(top: 6.0),
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      color: CupertinoColors.systemBackground
                                          .resolveFrom(context),
                                      child: SafeArea(
                                        top: false,
                                        child: CupertinoDatePicker(
                                            initialDateTime: date,
                                            mode: CupertinoDatePickerMode.date,
                                            onDateTimeChanged:
                                                (DateTime newDate) {
                                              setState(() => date = newDate);
                                            },
                                            minimumYear: 1900,
                                            maximumDate: DateTime.now()),
                                      ),
                                    )),
                            child:
                                Text('${date.month}/${date.day}/${date.year}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => (patient.gender == Gender.MALE)
                        ? patient = patient.copyWith(gender: Gender.FEMALE)
                        : patient = patient.copyWith(gender: Gender.MALE)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
                            const Text("Gender"),
                            const Spacer(),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(1.0),
                                      decoration: patient.gender == Gender.MALE
                                          ? BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: Styles
                                                  .backgroundComplementory
                                                  .withOpacity(0.5))
                                          : null,
                                      child: const Text("Male"),
                                    ),
                                    const Text("/   "),
                                    Container(
                                      padding: const EdgeInsets.all(1.0),
                                      decoration: patient.gender != Gender.MALE
                                          ? BoxDecoration(
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: Styles
                                                  .backgroundComplementory
                                                  .withOpacity(0.5))
                                          : null,
                                      child: const Text("Female"),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                color: CupertinoColors.link,
                onPressed: () {
                  //storeDateTimeData(date);
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context);
                    // TODO
                  }
                },
                child: const Text("Begin Evaluation"),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _formInput(String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 63,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: CupertinoTextFormFieldRow(
          prefix: Text(field),
          textCapitalization: TextCapitalization.words,
          placeholder: 'Enter a ${field.split(' ')[1].toLowerCase()}',
          validator: (value) => value == null || value.isEmpty
              ? 'Please enter a valid response'
              : null,
          onSaved: (String? value) {
            storeValue(field, value);
          },
        ),
      ),
    );
  }

  void storeValue(String field, String? value) {
    try {
      switch (field) {
        case "First Name":
          patient = patient.copyWith(first_name: value!);
          break;
        case "Last Name":
          patient = patient.copyWith(last_name: value!);
          break;
        case "Height":
          patient = patient.copyWith(height_in_inches: double.tryParse(value!));
          break;
        default:
          throw Exception("Invalid field or value used");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

// void storeDateTimeData(DateTime date) {
//   patientData.bday = date.toString().split(" ")[0];
//   final now = DateTime.now();
//   final String age = (now.difference(date).inDays / 365).floor().toString();
//   patientData.age = age;
//   final nowString = now.toString();
//   final String nowDate = nowString.split(" ")[0];
//   final String nowTime = nowString
//       .split(" ")[1]
//       .split(".")[0]
//       .substring(0, nowString.split(" ")[1].split(".")[0].lastIndexOf(':'));
//   patientData.date = nowDate;
//   patientData.time = nowTime;
// }
