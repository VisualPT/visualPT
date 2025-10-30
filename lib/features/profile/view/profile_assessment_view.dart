import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/analysis/view/analysis_view.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/features/profile/service/profile_service.dart';
import 'package:visualpt/models/ModelProvider.dart';

class ProfileAssessmentsView extends StatefulWidget {
  const ProfileAssessmentsView(this.config, this.profile, {super.key});

  final BaseAssessment config;
  final Profile profile;

  @override
  State<ProfileAssessmentsView> createState() => _ProfileAssessmentsViewState();
}

class _ProfileAssessmentsViewState extends State<ProfileAssessmentsView> {
  bool loading = true;
  List<Assessment> assessments = [];
  Assessment? latestAssessment;

  // Fetch all the assessments belonging to the patient
  Future<void> fetchPatientAssessments() async {
    assessments = await ProfileService.queryAssessmentsByProfileId(
        widget.profile.id,
        type: widget.config.type);
    assessments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (mounted) {
      setState(() {
        latestAssessment = assessments.isNotEmpty ? assessments.last : null;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPatientAssessments();
  }

  @override
  void didUpdateWidget(ProfileAssessmentsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchPatientAssessments();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      pageTitle:
          '${widget.profile.firstName} ${widget.config.type.name} Assessments',
      poppable: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: loading
            ? const Center(child: CupertinoActivityIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: assessments.isNotEmpty
                      ? assessments
                          .map((assessment) => Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Dismissible(
                                    key: Key(assessment.id),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (direction) {
                                      return showCupertinoDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoAlertDialog(
                                            title:
                                                const Text('Confirm Deletion'),
                                            content: Text(
                                              'Are you sure you want to delete the assessment from ${FormatUtil.date(assessment.createdAt.getDateTimeInUtc().toLocal())} at ${FormatUtil.time(assessment.createdAt.getDateTimeInUtc().toLocal())}?',
                                            ),
                                            actions: <CupertinoDialogAction>[
                                              CupertinoDialogAction(
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  ProfileService
                                                      .deleteAssessment(
                                                          assessment);
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    assessments
                                                        .remove(assessment);
                                                  });
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    background: Container(
                                      decoration: BoxDecoration(
                                        color: Styles.red,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      alignment: Alignment.centerRight,
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: const Icon(
                                        CupertinoIcons.trash,
                                        color: Styles.white,
                                      ),
                                    ),
                                    child: ProfileAssessmentCard(
                                        widget.profile, assessment)),
                              ))
                          .toList()
                      : [const Text('No assessments available')],
                ),
              ),
      ),
    );
  }
}

class ProfileAssessmentCard extends StatefulWidget {
  const ProfileAssessmentCard(this.profile, this.assessment, {super.key});
  final Profile profile;
  final Assessment assessment;

  @override
  State<ProfileAssessmentCard> createState() => _ProfileAssessmentCardState();
}

class _ProfileAssessmentCardState extends State<ProfileAssessmentCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      onTap: () => AppNav(context)
          .toView(ProfileAssessmentView(widget.profile, widget.assessment.id)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  FormatUtil.date(
                      widget.assessment.createdAt.getDateTimeInUtc().toLocal()),
                  style: Styles.heading2,
                ),
                Text(
                  FormatUtil.time(
                      widget.assessment.createdAt.getDateTimeInUtc().toLocal()),
                  style: Styles.heading2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAssessmentView extends StatefulWidget {
  const ProfileAssessmentView(this.profile, this.id, {super.key});
  final Profile profile;
  final String id;

  @override
  State<ProfileAssessmentView> createState() => _ProfileAssessmentViewState();
}

class _ProfileAssessmentViewState extends State<ProfileAssessmentView> {
  AssessmentAnalysis? analysis;
  bool loading = true;
  String error = '';

  fetchAnalysis() async {
    try {
      final assembledAssessment =
          await AssessmentService.assembleAssessment(widget.id);
      final config = AssessmentUtils.getConfig(assembledAssessment.type);
      final formFields = Map<String, FormFieldItem<dynamic>>.fromEntries(
        (jsonDecode(assembledAssessment.extra) as Map<String, dynamic>)
            .entries
            .map(
          (entry) {
            final key = entry.key;
            final value = entry.value;

            // Fetch default form (template) from config
            final defaultField = config.formFields[key];

            if (defaultField == null) {
              throw Exception("Unknown field key: $key");
            }

            return MapEntry(
              key,
              FormFieldItem<dynamic>(
                form: defaultField.form,
                value: FormatUtil.castValue(value, defaultField.value),
              ),
            );
          },
        ),
      );

      if (mounted) {
        setState(() {
          analysis = AssessmentAnalysis(
            widget.profile,
            assembledAssessment,
            config,
            formFields,
          );
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        error = 'Analysis Error: ${e.toString()}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        color: Styles.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Loading full pose analysis, this might take a minute...'),
              SizedBox(height: 8),
              CupertinoActivityIndicator(),
            ],
          ),
        ),
      );
    }

    if (analysis == null) {
      return Container(
        color: Styles.white,
        child: Center(
          child: Text(error.isNotEmpty
              ? error
              : 'No assessment found for ID: ${widget.id}'),
        ),
      );
    }

    try {
      return AnalysisView(
        analysis!,
        poppable: true,
      );
    } catch (e) {
      return Container(
        color: Styles.white,
        child: Center(
          child: Text(
            'Failed to build analysis view due to outdated assessment format. '
            'Assessment ID: ${widget.id}\nError: ${e.toString()}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
