class AuthUtils {
  static String? validateEmail(String? email) {
    //Check 0: email is not empty
    if (email == null || email.isEmpty) {
      return "Email cannot be empty";
    }
    //Check 1: at least 1 @ symbol
    if (email.contains("@") == false) {
      return "Email must contain @ symbol";
    }
    //Check 2: at least 1 . symbol
    if (email.contains(".") == false) {
      return "Email must contain . symbol";
    }
    //Check 3: at least 1 character before @
    if (email.split("@")[0].isEmpty) {
      return "Email must contain at least 1 character before @";
    }
    //Check 4: at least 1 character between @ and .
    if (email.split("@")[1].split(".")[0].isEmpty) {
      return "Email must contain at least 1 character between @ and .";
    }
    //Check 5: at least 1 character after .
    if (email.split("@")[1].split(".")[1].isEmpty) {
      return "Email must contain at least 1 character after .";
    }
    if (!email.contains(RegExp(
        r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''',
        caseSensitive: false))) {
      return "Email must be valid, did not pass master check";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    //Check 0: password is not empty
    if (password == null || password.isEmpty) {
      return "Password cannot be empty";
    }
    //Check 1: at least 8 characters
    if (password.length < 8) {
      return "Password must be at least 8 characters";
    }
    //Check 2: at least 1 uppercase letter
    if (password.contains(RegExp(r'[A-Z]')) == false) {
      return "Password must contain at least 1 uppercase letter";
    }
    //Check 3: at least 1 lowercase letter
    if (password.contains(RegExp(r'[a-z]')) == false) {
      return "Password must contain at least 1 lowercase letter";
    }
    //Check 4: at least 1 number
    if (password.contains(RegExp(r'[0-9]')) == false) {
      return "Password must contain at least 1 number";
    }
    //Check 5: at least 1 special character
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) == false) {
      return "Password must contain at least 1 special character";
    }
    return null;
  }

  static String? validateCode(String? code) {
    if (code == null || code.isEmpty) {
      return "Code cannot be empty";
    }
    if (code.contains(RegExp(r'^[0-9]{6}$')) == false) {
      return "Code must be 6 digits";
    }
    return null;
  }
}
