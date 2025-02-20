import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_cupertino_fields/form_builder_cupertino_fields.dart';
import 'package:intl/intl.dart';

import 'package:visualpt/core/_core.dart';
import 'package:visualpt/core/view/components/form_item_container.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/models/ModelProvider.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm(this.onCreated, {super.key});
  final void Function(Profile) onCreated;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController =
      TextEditingController(text: DateTime.now().toIso8601String());
  TextEditingController genderController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  void handleAutofill() {
    setState(() {
      firstNameController.text = "Sample";
      lastNameController.text = "Profile";
      emailController.text = "visualpt@visualpt.ai";

      //FIXME: Form not updating the non-text fields

      // _formKey.currentState?.setInternalFieldValue("Birth Date", "2000-01-01");
      // _formKey.currentState?.setInternalFieldValue("Gender", Gender.MALE);
      // _formKey.currentState?.setInternalFieldValue("Height", "60\"");
      // _formKey.currentState?.setInternalFieldValue("Weight", "160\"");
      dobController.text = "Feb 20, 1970";
      genderController.text = Gender.MALE.toString();
      heightController.text = "60";
      weightController.text = "160";
    });
  }

  void handleFormSubmit() {
    //TODO <are you sure this data is correct?> modal
    try {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();
        final profile = FormHelper.createProfile(
            firstNameController.text,
            lastNameController.text,
            DateFormat("MMM dd, yyyy")
                .parse(dobController.text)
                .toIso8601String(),
            genderController.text,
            heightController.text,
            emailController.text);
        widget.onCreated(profile);

        setState(() {
          firstNameController.clear();
          lastNameController.clear();
          dobController.clear();
          genderController.clear();
          heightController.clear();
          emailController.clear();
        });
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
      return SafeArea(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUnfocus,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //TODO: add a reset button
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                const Text(
                  "New Patient Profile Form",
                  style: Styles.heading3,
                  textAlign: TextAlign.center,
                ),
                FormItemContainer(
                  child: FormBuilderCupertinoTextField(
                    name: "First Name",
                    controller: firstNameController,
                    keyboardType: TextInputType.name,
                    style: Styles.inputStyle,
                    placeholder: "First Name",
                    placeholderStyle: Styles.placeholderStyle,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter a first name"
                        : null,
                  ),
                ),
                FormItemContainer(
                  child: FormBuilderCupertinoTextField(
                    name: "Last Name",
                    controller: lastNameController,
                    keyboardType: TextInputType.name,
                    style: Styles.inputStyle,
                    placeholder: "Last Name",
                    placeholderStyle: Styles.placeholderStyle,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter a last name"
                        : null,
                  ),
                ),
                FormItemContainer(
                  child: FormBuilderCupertinoTextField(
                    name: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: Styles.inputStyle,
                    placeholder: "Email",
                    placeholderStyle: Styles.placeholderStyle,
                    validator: (value) => value == null ||
                            value.isEmpty ||
                            !value.contains('@') ||
                            !value.contains('.')
                        //TODO: add a regex for email validation
                        ? "Please enter an email"
                        : null,
                  ),
                ),
                FormItemContainer(
                  child: FormBuilderCupertinoDateTimePicker(
                    name: "Birth Date",
                    controller: dobController,
                    inputType: InputType.date,
                    format: DateFormat("MMM dd, yyyy"),
                    initialValue:
                        DateTime.tryParse(dobController.text) ?? DateTime.now(),
                    style: Styles.inputStyle,
                    prefix:
                        const Text("Date of Birth", style: Styles.prefixStyle),
                    textAlign: TextAlign.center,
                    onChanged: (date) {
                      // the user should only be able to put the date, and this value should be interpreted at UTC and never converted to locale time
                      setState(() => dobController.text =
                          date?.toUtc().toIso8601String().split('T').first ??
                              '');
                    },
                    validator: (value) {
                      //if its within the last 10 years its probably a mistake
                      final min = DateTime.now().year - value!.year < 10;
                      final max = DateTime.now().year - value.year > 120;

                      if (value == null || min || max) {
                        return 'Please select a valid birth date';
                      }
                      return null;
                    },
                  ),
                ),
                FormItemContainer(
                  child: FormBuilderCupertinoSegmentedControl(
                    name: "Gender",
                    shouldExpandedField: true,
                    initialValue: Gender.values.firstWhere(
                      (gender) => gender.name == genderController.text,
                      orElse: () => Gender.values.first,
                    ),
                    prefix: const Text("Gender", style: Styles.prefixStyle),
                    options: Gender.values
                        .map((e) => FormBuilderFieldOption(
                            value: e,
                            child: Text(e.name, style: Styles.inputStyle)))
                        .toList(),
                    onChanged: (value) => setState(
                        () => genderController.text = value.toString()),
                  ),
                ),
                FormItemContainer(
                  child: FormBuilderCupertinoSlider(
                    name: "Height",
                    min: 36,
                    max: 99,
                    divisions: 63,
                    initialValue: double.tryParse(heightController.text) ?? 60,
                    prefix: const Text(
                      "Height ",
                      style: Styles.prefixStyle,
                    ),
                    onChanged: (value) => setState(
                        () => heightController.text = value.toString()),
                    minValueWidget: (string) => Container(),
                    maxValueWidget: (string) => Container(),
                    valueWidget: (value) {
                      final v = int.parse(value);
                      final meters = v * 0.0254;
                      //convert to XftXXin (m)
                      return Text(
                          "${v ~/ 12}ft${v % 12}in / ${meters.toStringAsFixed(2)} m",
                          style: Styles.inputNumberText);
                    },
                  ),
                ),
                FormItemContainer(
                  child: FormBuilderCupertinoSlider(
                    name: "Weight",
                    min: 60,
                    max: 260,
                    divisions: 200,
                    initialValue: double.tryParse(weightController.text) ?? 100,
                    prefix: const Text(
                      "Weight ",
                      style: Styles.prefixStyle,
                    ),
                    onChanged: (value) => setState(
                        () => weightController.text = value.toString()),
                    minValueWidget: (string) => Container(),
                    maxValueWidget: (string) => Container(),
                    valueWidget: (value) {
                      final v = int.parse(value);
                      // Since this is now for weight, we'll convert to kg instead of height calculations
                      final kg = v * 0.453592;
                      // Show weight in lbs and kg
                      return Text("$v lbs / ${kg.toStringAsFixed(2)} kg",
                          style: Styles.inputNumberText);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      kDebugMode
                          ? CupertinoButton(
                              color: Styles.actionPrimary,
                              onPressed: handleAutofill,
                              child: const Text("Autofill",
                                  style: Styles.actionText))
                          : Container(),
                      CupertinoButton(
                        color: Styles.actionPrimary,
                        onPressed: handleFormSubmit,
                        child: const Text("Next", style: Styles.actionText),
                      ),
                    ],
                  ),
                )
              ],
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
}
