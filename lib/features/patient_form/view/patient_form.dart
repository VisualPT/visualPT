import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/patient_form/bloc/patient_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/core/views/components/_components.dart';

class PatientForm extends StatefulWidget {
  final User user;
  final AssessmentType assessmentType;

  const PatientForm(
      {Key? key, required this.user, required this.assessmentType})
      : super(key: key);

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
                Text(widget.user.email),
                CupertinoButton(
                    onPressed: () {
                      firstNameController.text = "Sample";
                      lastNameController.text = "Patient";
                      dobController.text = "2000-01-01";
                      genderController.text = "MALE";
                      heightController.text = "60\"";
                    },
                    child: const Text("Autofill")),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoButton(
                      color: Styles.actionPrimary,
                      onPressed: () {
                        //TODO <are you sure this data is correct?> modal
                        try {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            BlocProvider.of<PatientBloc>(context).add(
                                PatientInit(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    dateOfBirth: dobController.text,
                                    gender: genderController.text,
                                    height: heightController.text,
                                    email: widget.user.email));
                          }
                        } catch (e) {
                          BlocProvider.of<PatientBloc>(context)
                              .add(PatientSaveFailure(message: e.toString()));
                        }
                      },
                      child: const Text("Next", style: Styles.actionText),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TODO: Put custom popups in utils/

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
