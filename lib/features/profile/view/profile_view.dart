import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/features/profile/service/profile_service.dart';
import 'package:visualpt/features/profile/view/profile_assessment_view.dart';
import 'package:visualpt/models/ModelProvider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView(this.profile, {super.key});

  final Profile profile;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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
  didUpdateWidget(ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchPatientAssessments();
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Styles.heading3),
          Text(value, style: Styles.heading2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      poppable: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text("Profile", style: Styles.title),
                  ),
                  _buildProfileRow("Name:",
                      "${widget.profile.firstName} ${widget.profile.lastName}"),
                  _buildProfileRow(
                      "DOB:",
                      widget.profile.dob
                          .getDateTime()
                          .toString()
                          .split(" ")[0]),
                  _buildProfileRow("Gender:", widget.profile.gender.name),
                  _buildProfileRow("Email:", widget.profile.email),
                  _buildProfileRow("Height:",
                      '${(widget.profile.height / 12).round()}\' ${(widget.profile.height % 12).round()}\'\''),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
                child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text("Assessments", style: Styles.title),
              ),
              //Make a card here for each unique assessment type that the user has taken
              if (loading) const Center(child: CupertinoActivityIndicator()),
              ...assessments
                  .map((assessment) => assessment.type)
                  .toSet()
                  .map((type) {
                final count = assessments
                    .where((assessment) => assessment.type == type)
                    .length;
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(children: [
                      SizedBox(
                        height: 60,
                        width: 80,
                        child: Image(
                          image: AssetImage(
                              AssessmentUtils.getConfig(type).imagePath),
                          fit: BoxFit.contain,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            return ClipRRect(
                              borderRadius: Styles.borderRadiusM,
                              child: child,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const Icon(
                              CupertinoIcons.question_circle_fill,
                              color: Styles.black,
                              size: 60,
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              CupertinoIcons.question_circle_fill,
                              color: Styles.black,
                              size: 60,
                            );
                          },
                        ),
                      ),
                      Text(
                        type.name,
                        style: Styles.heading2,
                      ),
                      const Spacer(),
                      Text(
                        "$count",
                        style: Styles.heading2,
                      ),
                      const SizedBox(width: 8),
                      Button(
                        text: "See All",
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ProfileAssessmentsView(
                                AssessmentUtils.getConfig(type),
                                widget.profile,
                              ),
                            ),
                          );
                        },
                      )
                    ]),
                  ),
                  // TODO: implement additional assessment cards here
                ]);
              })
            ])),
          ]),
        ),
      ),
    );
  }
}
