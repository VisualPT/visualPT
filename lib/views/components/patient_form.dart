import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/bloc/_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/views/_views.dart';
import 'package:visualpt/views/components/_components.dart';

class PatientForm extends StatefulWidget {
  final AssessmentType assessmentType;

  const PatientForm({Key? key, required this.assessmentType}) : super(key: key);

  @override
  State<PatientForm> createState() => _PatientFormState();
}

//TODO FIX WITH BLOC (post nap)
class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView(
      pageTitle: "Patient Information",
      child: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 100,
            maxHeight: 500,
          ),
          child: Column(
            //TODO BLOC this shit UP into a form BLOC and add a reset button
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FormInput(
                "First Name",
                controller: firstNameController,
                inputType: TextInputType.name,
              ),
              FormInput(
                "Last Name",
                controller: lastNameController,
                inputType: TextInputType.name,
              ),
              FormInput(
                "Birth Date",
                controller: dobController,
                inputPopup: datePopup,
              ),
              FormInput(
                "Gender",
                controller: genderController,
                inputPopup: genderPopup,
              ),
              FormInput(
                "Height",
                controller: heightController,
                inputPopup: numberPopup,
              ),
              Buttons(context)
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> datePopup() {
    String? value;
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            color: CupertinoColors.white,
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                const Text("Date", style: Styles.inputStyle),
                const Spacer(),
                CupertinoButton(
                    color: CupertinoColors.link,
                    onPressed: () => Navigator.pop(context, value),
                    child: const Text("Save")),
              ],
            ),
          ),
          Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.white,
            child: SafeArea(
              top: false,
              child: CupertinoDatePicker(
                backgroundColor: CupertinoColors.white,
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
            //TODO Make this a reusable widget
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              color: CupertinoColors.white,
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
              ),
            ),
            Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.white,
              child: SafeArea(
                top: false,
                child: CupertinoPicker(
                  backgroundColor: CupertinoColors.white,
                  itemExtent: Styles.kItemExtent,
                  onSelectedItemChanged: (int selectedItem) {
                    value = selectedItem == 0
                        ? ""
                        : Gender.values[selectedItem - 1].name.toString();
                  },
                  children: List<Text>.generate(
                    3,
                    (index) => index == 0
                        ? const Text("")
                        : Text(Gender.values[index - 1].name.toString(),
                            style: Styles.popupSelectionStyle),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  Future<String?> numberPopup() {
    List<Text> heightList = List<Text>.generate(
        80,
        (index) => Text("${(index + 36) ~/ 12}'${(index + 36) % 12}''",
            style: Styles.popupSelectionStyle));
    String? value;
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //TODO Make this a reusable widget
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              color: CupertinoColors.white,
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  const Text("Height", style: Styles.inputStyle),
                  const Spacer(),
                  CupertinoButton(
                      color: CupertinoColors.link,
                      onPressed: () => Navigator.pop(context, value),
                      child: const Text("Save")),
                ],
              ),
            ),
            Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.white,
              child: SafeArea(
                top: false,
                child: CupertinoPicker(
                  backgroundColor: CupertinoColors.white,
                  itemExtent: Styles.kItemExtent,
                  onSelectedItemChanged: (int selectedItem) {
                    value = heightList[selectedItem].data.toString();
                  },
                  children: List<Text>.generate(
                    80,
                    (index) => heightList[index],
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  Widget Buttons(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width / 2,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Styles.actionPrimary),
              child: Text("Next", style: Styles.actionText),
            ),
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Patient patient = Patient(
                  name: firstNameController.text,
                  family_name: lastNameController.text,
                  dob: TemporalDate(DateTime.parse(dobController.text)),
                  gender: genderParse(genderController.text),
                  height_in_inches: double.parse(heightController.text),
                );
                BlocProvider.of<AssessmentBloc>(context).add(AssessmentInit(0));
                //TODO store data to backend
              }
            },
          ),
        ),
      ],
    );
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

Gender genderParse(String text) {
  switch (text) {
    case "MALE":
      return Gender.MALE;

    case "FEMALE":
      return Gender.FEMALE;

    default:
      return Gender.MALE;
  }
}
