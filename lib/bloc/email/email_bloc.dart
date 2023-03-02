import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'email_event.dart';
part 'email_state.dart';

class EmailBloc extends Bloc<EmailEvent, EmailState> {
  EmailBloc() : super(EmailInitial()) {
    on<EmailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  //Future<bool> ensureEmail() async {
  // return await Amplify.Auth.fetchUserAttributes().then((attributes) {
  //   for (AuthUserAttribute attr in attributes) {
  //     if (attr.userAttributeKey.toString().compareTo("email") == 0) {
  //       patient.managingtherapistEmail = attr.value;
  //       return true;
  //     }
  //   }
  // });
  //}
}
