import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/assessment/_assessment.dart';
import 'package:visualpt/features/profile/_profile.dart';
import 'package:visualpt/features/profile/view/profile_view.dart';
import 'package:visualpt/features/trend/_trend.dart';
import 'package:visualpt/models/ModelProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configure();
  runApp(const VisualPT());
}

class VisualPT extends StatefulWidget {
  const VisualPT({super.key});

  @override
  State<VisualPT> createState() => _VisualPTState();
}

class _VisualPTState extends State<VisualPT> {
  @override
  void initState() {
    super.initState();
    requestPermissions(_showCameraAccessDeniedAlert);
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: const CupertinoThemeData(
              brightness: Brightness.light,
              textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(
                      fontFamily: "Raleway",
                      fontWeight: FontWeight.bold,
                      color: Styles.black))),
          home: CupertinoTabScaffold(
              tabBar: CupertinoTabBar(items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.list_bullet),
                  label: "Assessments",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.group),
                  label: "Profiles",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chart_bar),
                  label: "Trends",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings),
                  label: "Settings",
                ),
              ]),
              tabBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const AssessmentsView();
                  case 1:
                    return const ProfilesView();
                  case 2:
                    return const TrendsView();
                  default:
                    return const SettingsView();
                }
              }),
          onGenerateRoute: (route) {
            if (route.name == "/assessment") {
              final props = route.arguments as AssessmentPathProps;
              final config = AssessmentUtils.getConfig(props.type);
              return CupertinoPageRoute(
                  builder: (context) => AssessmentView(config, props.profile));
            }
            if (route.name == "/profile") {
              final profile = route.arguments as Profile;
              return CupertinoPageRoute(
                  builder: (context) => ProfileView(profile));
            }
            return null;
          }),
    );
  }

  void _showCameraAccessDeniedAlert() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Camera Permission Denied"),
          content: const Text(
              "Camera access is required for this app to function properly. Please enable camera access in your device settings."),
          actions: <Widget>[
            CupertinoButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AssessmentPathProps {
  final AssessmentType type;
  final Profile profile;

  const AssessmentPathProps(this.type, this.profile);
}
