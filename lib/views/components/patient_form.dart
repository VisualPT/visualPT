import 'dart:developer';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/styles.dart';

class PatientForm extends StatefulWidget {
  final AssessmentType assessmentType;
  final Widget child;
  const PatientForm(
      {Key? key, required this.assessmentType, required this.child})
      : super(key: key);

  @override
  State<PatientForm> createState() => _PatientFormState();
}

//TODO FIX WITH BLOC (post nap)
class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  Patient patient = Patient(
      name: "TODO",
      family_name: "TODO",
      dob: TemporalDate(DateTime.now()),
      gender: Gender.MALE,
      height_in_inches: 0);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: showFormDialog, child: widget.child);
  }

  Future<void> showFormDialog() {
    return showCupertinoModalPopup(
      useRootNavigator: false,
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return CupertinoAlertDialog(
          title: const Text('Patient Information',
              style: Styles.defaultTitleOverride),
          content: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100,
                maxHeight: 400,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _formInput("First Name"),
                  _formInput("Last Name"),
                  _formInput("Birth Date", inputPopup: datePopup),
                  _formInput("Gender", inputPopup: genderPopup),
                  _formInput("Height"),
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
                    //TODO Specify assessment type argument
                    Navigator.pushNamed(context, "/assessment",
                        arguments: widget.assessmentType);
                  }
                },
                child: const Text("Next"),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _formInput(String field, {Future<String?> Function()? inputPopup}) {
    TextEditingController controller = TextEditingController();
    return CupertinoTextFormFieldRow(
        controller: controller,
        textAlign: TextAlign.center,
        style: Styles.inputStyle,
        autocorrect: false,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        textCapitalization: TextCapitalization.words,
        placeholder: field,
        validator: (value) => value == null || value.isEmpty
            ? 'Please enter a valid response'
            : null,
        onSaved: (String? value) {
          storeValue(field, value);
        },
        //TODO Manage the controller.text (maybe do this after the rest of the UI build?)
        onTap: () => inputPopup != null
            ? inputPopup()
                .then((value) => value != null ? controller.text = value : null)
            : null);
  }

  Future<String?> datePopup() {
    String? value;
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CupertinoButton(
            child: const Text("Ok"),
            onPressed: () => Navigator.pop(context, value),
          ),
          Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: CupertinoDatePicker(
                initialDateTime: date,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) =>
                    value = newDate.toString().split(" ")[0],
                minimumYear: 1900,
                maximumDate: DateTime.now(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> genderPopup() {
    String? value;
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //Make this a reusable widget
            Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                color: CupertinoColors.systemBackground.resolveFrom(context),
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    const Text("Gender", style: Styles.inputStyle),
                    const Spacer(),
                    CupertinoButton(
                        color: CupertinoColors.link,
                        onPressed: () => Navigator.pop(context, value),
                        child: const Text("Save")),
                  ],
                )),
            Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: CupertinoPicker(
                  itemExtent: Styles.kItemExtent,
                  onSelectedItemChanged: (int selectedItem) {
                    setState(
                      () {
                        value = selectedItem == 0
                            ? ""
                            : Gender.values[selectedItem - 1].name.toString();
                      },
                    );
                  },
                  children: List<Text>.generate(
                    3,
                    (index) => index == 0
                        ? const Text("")
                        : Text(
                            Gender.values[index - 1].name.toString(),
                          ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  void storeValue(String field, String? value) {
    try {
      switch (field) {
        case "First Name":
          patient = patient.copyWith(name: value!);
          break;
        case "Last Name":
          patient = patient.copyWith(family_name: value!);
          break;
        case "Birth Date":
          patient = patient.copyWith(dob: TemporalDate.fromString(value!));
          break;
        case "Gender":
          //TODO FIX WITH BLOC PATTERN
          patient = patient.copyWith(gender: Gender.MALE);
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
