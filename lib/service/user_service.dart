import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/service/_service.dart';

//TODO Fortify this, make sure it is always set when the user is signed in!!!!!
late String currentEmail;

UserService userService = UserService();

class UserService extends AppService {
  Future<String> currentUserEmail() async {
    return await Amplify.Auth.fetchUserAttributes()
        .then<String>((attributes) => attributes
            .where((attr) =>
                attr.userAttributeKey.toString().compareTo("email") == 0)
            .first
            .value)
        .then((email) => currentEmail = email);
  }
}
