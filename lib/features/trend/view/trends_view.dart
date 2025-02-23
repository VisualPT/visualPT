import 'package:flutter/cupertino.dart';
import 'package:visualpt/core/_core.dart';

class TrendsView extends StatelessWidget {
  const TrendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BaseView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  shrinkWrap: false,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text("Trends",
                          style: Styles.title, textAlign: TextAlign.left),
                    ),
                    Text("Coming Soon...", style: Styles.disabledTitle),
                    //TODO: Add Profiles Here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
