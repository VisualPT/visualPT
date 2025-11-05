import 'package:flutter/cupertino.dart';
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
  late Map<String, FormFieldItem> formFields;
  late Map<String, dynamic> formValues = {};
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    formFields = widget.state.config.formFields;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Ensure form values are updated after the first build
      setState(() {
        _formKey.currentState?.save();
        formValues = _formKey.currentState?.value
                .map((k, v) => MapEntry(k.toLowerCase(), v.toString())) ??
            {};
      });
    });
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void handleFormSubmit() {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final fields = formValues.map((k, v) {
          final key = k.toLowerCase();
          final oldItem = formFields[key]!;
          final item = FormFieldItem(form: oldItem.form, value: v);
          return MapEntry(key, item);
        });
        bloc.add(AssessmentInit(fields));
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    "${widget.state.config.name} Questions",
                    style: Styles.heading3,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: formFields.length,
                    itemBuilder: (context, index) {
                      final formFieldItem = formFields.entries.elementAt(index);
                      return FormBuilderField(
                        key: Key(formFieldItem.key),
                        name: formFieldItem.key,
                        builder: (FormFieldState field) {
                          return formFieldItem.value.form;
                        },
                      );
                    },
                  ),
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
          pageTitle: "Assessment Form Error",
          child: Column(
            children: [
              Text(e.toString()),
              Button(onPressed: () => nav.back(), text: "Restart")
            ],
          ));
    }
  }
}
