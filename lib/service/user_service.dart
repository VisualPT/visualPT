///CHARBO GIVES CREDIT TO BEAT TEAM EXPERIENCE FOR THIS CODE 3/1/2023
import 'dart:developer';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:visualpt/models/ModelProvider.dart';
import 'package:visualpt/service/_service.dart';

late User currentUser;

UserService userService = UserService();

class UserService extends AppService {
  Future<User> initUser() async {
    final userData = await Amplify.Auth.fetchUserAttributes();
    log("userData has returned with the values $userData");
    late String email, firstName, lastName;
    //TODO this needs to be set dynamically eventually
    late String status = "MALE";

    for (var element in userData) {
      switch (element.userAttributeKey.key) {
        case "email":
          email = element.value;
          break;
        case "name":
          firstName = element.value;
          break;
        case "family_name":
          lastName = element.value;
          break;
        case "status":
          status = element.value;
          break;
        default:
          log("Could not store ${element.userAttributeKey.key}========${element.value}");
      }
    }
    return fetchUserByEmail(email).then((user) async =>
        user ??
        await createUser(email, firstName, lastName, userStatusParse(status)));
  }

  Future<User?> fetchUserByEmail(String email) async {
    try {
      return await Amplify.DataStore.query(User.classType,
              where: User.EMAIL.eq(email))
          .then((users) => users.first);
    } catch (e) {
      log("fetchByUserEmail function failed to return a User with error $e");
      return null;
    }
  }

  Future<User> createUser(
    String email,
    String firstName,
    String lastName,
    UserStatus status,
  ) async {
    final User user = User(
      email: email,
      first_name: firstName,
      last_name: lastName,
      status: status,
    );
    saveData(user);
    return user;
  }

  UserStatus userStatusParse(String text) {
    log("userStatusParse function called with text $text");
    switch (text) {
      case "MALE":
        return UserStatus.ADMIN;
      default:
        log("Incorrect userStatus");
        return UserStatus.ADMIN;
    }
  }
}

  //Testing out some new bidirectional swag, still working on it
  // Future<void> saveGoalToUser(Goal goal) async {
  //   if (currentUser.userGoals == null) {
  //     currentUser = currentUser.copyWith(userGoals: [goal]);
  //   } else {
  //     currentUser.userGoals!.add(goal);
  //   }
  //   return userRepository.saveUser(currentUser);
  // }

/// Cannot put this in models folder because it will be overwritten on `amplify pull`