import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';

class AssessmentForm<T extends BaseAssessment> extends StatefulWidget {
  const AssessmentForm(this.state, {super.key});

  final AssessmentInputs<T> state;

  @override
  State<AssessmentForm<T>> createState() => _AssessmentFormState<T>();
}

class _AssessmentFormState<T extends BaseAssessment>
    extends State<AssessmentForm<T>> {
  late final AssessmentBloc<T> bloc =
      BlocProvider.of<AssessmentBloc<T>>(context);
  bool storeData = true;
  late Map<String, FormFieldItem> formFields = widget.state.meta.formFields;
  late Map<String, dynamic> formValues = {};
  final _formKey = GlobalKey<FormBuilderState>();

  void handleFormSubmit() {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        bloc.add(AssessmentInit(formValues.map((k, v) {
          final key = k.toLowerCase();
          final oldItem = formFields[key]!;
          final item = FormFieldItem(form: oldItem.form, value: v);
          return MapEntry(key, item);
        }), storeData));
      }
    } catch (e) {
      print('Error occurred during form submission: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nav = AppNav(context);
    try {
      return BaseView(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            onChanged: () {
              _formKey.currentState!.save();
              setState(() => formValues = _formKey.currentState!.value
                  .map((k, v) => MapEntry(k.toLowerCase(), v.toString())));
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: Column(
                //TODO: add a reset button
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Text(
                    "${widget.state.meta.name} Questions",
                    style: Styles.heading3,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  ...formFields.entries.map((formFieldItem) {
                    return FormBuilderField(
                      name: formFieldItem.key,
                      builder: (FormFieldState field) {
                        return formFieldItem.value.form;
                      },
                    );
                  }),
                  kDebugMode
                      ? GestureDetector(
                          onTap: () => setState(() {
                            print(formValues);
                            storeData = !storeData;
                          }),
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
                  const Spacer(),
                  Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Button(onPressed: handleFormSubmit, text: "Next")),
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
              Button(onPressed: () => nav.back(), text: "Restart Assessment")
            ],
          ));
    }
  }
}
