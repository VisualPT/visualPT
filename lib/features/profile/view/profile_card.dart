import 'package:flutter/widgets.dart';

import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/profile/_profile.dart';
import 'package:visualpt/models/ModelProvider.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard(this.profile, this.onSelected, {super.key});
  final Profile profile;
  final void Function(Profile) onSelected;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool loading = true;
  List<Assessment> assessments = [];
  Assessment? latestAssessment;

  // Fetch all the assessments belonging to the patient
  Future<void> fetchPatientAssessments() async {
    assessments =
        await ProfileService.queryAssessmentsByProfileId(widget.profile.id);
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
  didUpdateWidget(ProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchPatientAssessments();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      onTap: () => widget.onSelected(widget.profile),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.profile.firstName} ${widget.profile.lastName}",
                style: Styles.heading2,
                textAlign: TextAlign.center,
              ),
              Text(
                loading ? "Loading..." : "${assessments.length} Assessments",
                style: Styles.heading3,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${DateTime.now().difference(widget.profile.dob.getDateTime()).inDays ~/ 365} y/o",
                style: Styles.heading3,
                textAlign: TextAlign.center,
              ),
              Text(
                loading
                    ? "Loading..."
                    : (latestAssessment != null
                        ? "last seen ${FormatUtil.date(latestAssessment!.createdAt.getDateTimeInUtc().toLocal())}"
                        : "Never seen"),
                style: Styles.heading3,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
