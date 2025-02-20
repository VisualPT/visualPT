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
  bool storeData = false;
  late Map<String, FormFieldItem> formFields = widget.state.meta.formFields;
  final _formKey = GlobalKey<FormBuilderState>();

  void handleFormSubmit() {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        bloc.add(AssessmentInit(formFields, storeData));
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
                  ...formFields.entries
                      .map((formFieldItem) => formFieldItem.value.form),
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
                  const Spacer(),
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
}
