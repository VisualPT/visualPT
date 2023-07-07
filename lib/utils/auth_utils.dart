class AuthUtils {
  bool validateEmail(
      {required String email, required void Function(String) onInvalid}) {
    //Split email requirements into invidiual checks
    //Check 1: at least 1 @ symbol
    if (email.contains("@") == false) {
      onInvalid("Email must contain @ symbol");
      return false;
    }
    //Check 2: at least 1 . symbol
    if (email.contains(".") == false) {
      onInvalid("Email must contain . symbol");
      return false;
    }
    //Check 3: at least 1 character before @
    if (email.split("@")[0].isEmpty) {
      onInvalid("Email must contain at least 1 character before @");
      return false;
    }
    //Check 4: at least 1 character between @ and .
    if (email.split("@")[1].split(".")[0].isEmpty) {
      onInvalid("Email must contain at least 1 character between @ and .");
      return false;
    }
    //Check 5: at least 1 character after .
    if (email.split("@")[1].split(".")[1].isEmpty) {
      onInvalid("Email must contain at least 1 character after .");
      return false;
    }
    if (!email.contains(RegExp(
        r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])'''))) {
      onInvalid("Email must be valid, did not pass master check");
      return false;
    }

    return true;
  }

  bool validatePassword(
      {required String password, required void Function(String) onInvalid}) {
    //Split password requirements into individual checks
    //Check 1: at least 8 characters
    if (password.length < 8) {
      onInvalid("Password must be at least 8 characters");
      return false;
    }
    //Check 2: at least 1 uppercase letter
    if (password.contains(RegExp(r'[A-Z]')) == false) {
      onInvalid("Password must contain at least 1 uppercase letter");
      return false;
    }
    //Check 3: at least 1 lowercase letter
    if (password.contains(RegExp(r'[a-z]')) == false) {
      onInvalid("Password must contain at least 1 lowercase letter");
      return false;
    }
    //Check 4: at least 1 number
    if (password.contains(RegExp(r'[0-9]')) == false) {
      onInvalid("Password must contain at least 1 number");
      return false;
    }
    //Check 5: at least 1 special character
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) == false) {
      onInvalid("Password must contain at least 1 special character");
      return false;
    }
    return true;
  }
}
