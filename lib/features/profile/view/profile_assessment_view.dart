import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/config/base.dart';
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
                                    child: ProfileAssessmentCard(assessment)),
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
  const ProfileAssessmentCard(this.assessment, {super.key});
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
      onTap: () =>
          AppNav(context).toView(ProfileAssessmentView(widget.assessment)),
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

class ProfileAssessmentView extends StatelessWidget {
  const ProfileAssessmentView(this.assessment, {super.key});
  final Assessment assessment;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      pageTitle: 'Assessment Details',
      poppable: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Date: ${assessment.createdAt.toString()}'),
              Text('Stages: ${assessment.stages}'),
              Text(
                  'Trials: ${assessment.stages?.map((s) => s.trials).join(', ')}'),
              Text(
                  'Detections: ${assessment.stages?.map((s) => s.trials?.map((t) => t.compressedDetections).join(', ')).join(', ')}'),
              Text(
                  'Total Detections: ${assessment.stages?.expand<String>((s) => s.trials?.map((t) => t.compressedDetections) ?? []).length ?? 0}'),
            ],
          ),
        ),
      ),
    );
  }
}
