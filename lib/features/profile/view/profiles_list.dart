import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visualpt/core/_core.dart';
import 'package:visualpt/features/profile/_profile.dart';
import 'package:visualpt/features/profile/view/profile_form.dart';
import 'package:visualpt/models/ModelProvider.dart';

class ProfilesList extends StatelessWidget {
  const ProfilesList(this.onSelected, {super.key});

  final Function(Profile) onSelected;

  @override
  Widget build(BuildContext context) {
    return ProfilePresenter(
        onLoading: _onLoading, onLoaded: _onLoaded, onError: onError);
  }

  Widget _onLoading(BuildContext context, ProfileLoading state) {
    return const Center(child: CupertinoActivityIndicator());
  }

  Widget _onLoaded(BuildContext context, ProfileLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Button(
            text: "Add Profile",
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (ctx) => BlocProvider.value(
                        value: BlocProvider.of<ProfileBloc>(context),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Styles.white,
                            borderRadius: Styles.borderRadiusM,
                          ),
                          child: CupertinoScrollbar(
                            child: ProfileForm((profile) {
                              BlocProvider.of<ProfileBloc>(context,
                                      listen: false)
                                  .add(ProfileCreate(profile));
                              AppNav(context).pop();
                              onSelected(profile);
                            }),
                          ),
                        ),
                      ));
            }),
        Flexible(
          flex: 2,
          fit: FlexFit.loose,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              shrinkWrap: false,
              itemCount: state.profiles.length,
              itemBuilder: (context, index) {
                final profile = state.profiles[index];
                return Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile?.firstName ?? "Unnamed User",
                            style: Styles.heading2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      onSelected(profile!);
                    });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget onError(BuildContext context, ProfileState state, Exception? e) {
    return Center(child: Text(e.toString()));
  }
}
