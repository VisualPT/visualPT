import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/features/assessment/bloc/assessment_bloc.dart';
import 'package:visualpt/features/assessment/service/form_helper.dart';
import 'package:visualpt/features/assessment/view/_assessments.dart';
import 'package:visualpt/features/auth/bloc/auth_bloc.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/core/views/_views.dart';
import 'package:visualpt/core/views/components/_components.dart';

class AssessmentForm<T extends BaseAssessment> extends StatefulWidget {
  final T assessment;

  const AssessmentForm({super.key, required this.assessment});

  @override
  State<AssessmentForm> createState() => _AssessmentFormState();
}

class _AssessmentFormState extends State<AssessmentForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController fallHistoryController = TextEditingController();
  bool storeData = true;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    //TODO: Use this for analytics?
    // AppTrackingTransparency.getAdvertisingIdentifier();
    // If the system can show an authorization request dialog
    if (await AppTrackingTransparency.trackingAuthorizationStatus ==
        TrackingStatus.notDetermined) {
      //TODO Show a custom explainer dialog before the system dialog
      // await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  void handleAutofill() {
    firstNameController.text = "Sample";
    lastNameController.text = "Subject";
    dobController.text = "2000-01-01";
    genderController.text = "MALE";
    heightController.text = "60\"";
    fallHistoryController.text = "NONE";
  }

  void handleFormSubmit() {
    //TODO <are you sure this data is correct?> modal
    try {
      final user = BlocProvider.of<AuthBloc>(context).state.user as User;
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final subject = FormHelper.createSubject(
            user.id,
            firstNameController.text,
            lastNameController.text,
            dobController.text,
            genderController.text,
            heightController.text,
            user.email,
            fallHistoryController.text);
        BlocProvider.of<AssessmentBloc>(context)
            .add(AssessmentInit(subject, storeData));
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nav = AppNav(context);
    try {
      return BaseView(
        pageTitle: "Subject Information",
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: MediaQuery.of(context).size.height - 150,
              ),
              child: Column(
                //TODO: add a reset button
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  const Text(
                    "A few pieces of info to \n curate your experience",
                    style: Styles.heading3,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // FormInput(
                  //   "First Name",
                  //   controller: firstNameController,
                  //   inputType: TextInputType.name,
                  // ),
                  // FormInput(
                  //   "Last Name",
                  //   controller: lastNameController,
                  //   inputType: TextInputType.name,
                  // ),
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
                  FormInput(
                    "Fall History",
                    controller: fallHistoryController,
                    inputPopup: fallHistoryPopup,
                  ),
                  kDebugMode
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              storeData = !storeData;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: storeData ? Styles.blue : Styles.gray,
                                borderRadius: Styles.borderRadiusM),
                            child: const Text(
                              "Store Data",
                              style: Styles.placeholderStyle,
                            ),
                          ),
                        )
                      : Container(),
                  kDebugMode
                      ? CupertinoButton(
                          onPressed: handleAutofill,
                          child: const Text("Autofill",
                              style: TextStyle(color: Styles.black)))
                      : Container(),
                  Container(
                      padding: const EdgeInsets.all(16.0),
                      child: CupertinoButton(
                        color: Styles.actionPrimary,
                        onPressed: handleFormSubmit,
                        child: const Text("Next", style: Styles.actionText),
                      )),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return BaseView(
          pageTitle: "Patient View Error",
          child: Column(
            children: [
              Text(e.toString()),
              CupertinoButton(
                  onPressed: () => nav.back(),
                  child: const Text("Restart Assessment"))
            ],
          ));
    }
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
            color: Styles.white,
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                const Text("Date", style: Styles.inputStyle),
                const Spacer(),
                CupertinoButton(
                    color: Styles.link,
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
            color: Styles.white,
            child: SafeArea(
              top: false,
              child: CupertinoDatePicker(
                backgroundColor: Styles.white,
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
              color: Styles.white,
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  const Text("Gender", style: Styles.inputStyle),
                  const Spacer(),
                  CupertinoButton(
                      color: Styles.link,
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
              color: Styles.white,
              child: SafeArea(
                top: false,
                child: CupertinoPicker(
                  backgroundColor: Styles.white,
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

  Future<String?> fallHistoryPopup() {
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
              color: Styles.white,
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  const Text("Fall History", style: Styles.inputStyle),
                  const Spacer(),
                  CupertinoButton(
                      color: Styles.link,
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
              color: Styles.white,
              child: SafeArea(
                top: false,
                child: CupertinoPicker(
                  backgroundColor: Styles.white,
                  itemExtent: Styles.kItemExtent,
                  onSelectedItemChanged: (int selectedItem) {
                    value = selectedItem == 0
                        ? ""
                        : FallHistory.values[selectedItem - 1].name.toString();
                  },
                  children: List<Text>.generate(
                    4,
                    (index) => index == 0
                        ? const Text("")
                        : Text(FallHistory.values[index - 1].name.toString(),
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
              color: Styles.white,
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  const Text("Height", style: Styles.inputStyle),
                  const Spacer(),
                  CupertinoButton(
                      color: Styles.link,
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
              color: Styles.white,
              child: SafeArea(
                top: false,
                child: CupertinoPicker(
                  backgroundColor: Styles.white,
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
