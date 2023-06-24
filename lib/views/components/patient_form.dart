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

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView(
      pageTitle: "Patient Information",
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              //TODO: add a reset button
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
                  inputPopup: heightPopup,
                ),
                Text(BlocProvider.of<UserBloc>(context).currentUser.email),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width / 2,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Styles.actionPrimary),
                      child: const Text("Next", style: Styles.actionText),
                    ),
                    onTap: () {
                      //TODO <are you sure this data is correct?> modal
                      try {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          BlocProvider.of<PatientBloc>(context).add(PatientInit(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              dateOfBirth: dobController.text,
                              gender: genderController.text,
                              height: heightController.text,
                              email: BlocProvider.of<UserBloc>(context)
                                  .currentUser
                                  .email));
                        }
                      } catch (e) {
                        BlocProvider.of<PatientBloc>(context)
                            .add(PatientSaveFailure(message: e.toString()));
                      }
                    },
                  ),
                ),
              ],
            ),
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
                initialDateTime: DateTime.now(),
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
                            style: Styles.popupSelectionText),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  Future<String?> heightPopup() {
    const int minHeight = 36; //Minimum listable height on the picker (inches)
    const int maxHeight = 120;

    List<Text> heightList = List<Text>.generate(
        maxHeight - minHeight,
        (index) => Text(
            "${(index + minHeight) ~/ 12}'${(index + minHeight) % 12}''",
            style: Styles.popupSelectionText));
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
                  onSelectedItemChanged: (int heightInches) {
                    value = "${heightInches + minHeight}\"";
                  },
                  children: List<Text>.generate(
                    maxHeight - minHeight,
                    (index) => heightList[index],
                  ),
                ),
              ),
            ),
          ]),
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
