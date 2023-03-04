import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/service/_service.dart';

class UserService extends AppService {
  Future<String> currentUserEmail() async {
    return await Amplify.Auth.fetchUserAttributes().then<String>((attributes) =>
        attributes
            .where((attr) =>
                attr.userAttributeKey.toString().compareTo("email") == 0)
            .first
            .value);
  }
}
