import 'package:firebase_auth/firebase_auth.dart';

import '../../../utils/Uihelper/ui_helper.dart';

class FirebaseExceptionHelper {
  static void exceptionHandler(FirebaseException exception) {
    switch (exception.code) {
      case "invalid-email":
        UiHelper.customSnackbar(
            titleMsg: "Invalid Email",
            msg: "Please provide correct email or valid email");
        break;

      case "user-disabled":
        UiHelper.customSnackbar(
            titleMsg: "User Disabled",
            msg: "User account has been disabled by an administrator");
        break;

      case "weak-password":
        UiHelper.customSnackbar(
            titleMsg: "Weak Password", msg: "Please provide strong password");
        break;

      case "operation-not-allowed":
        UiHelper.customSnackbar(
            titleMsg: "Opeartion Not Allowed",
            msg: "This action not allowed or unauthorized access");
        break;

      case "email-already-in-use":
        UiHelper.customSnackbar(
            titleMsg: "Email Id Already In Use",
            msg: "This email is already associated with another account");
        break;

      case "user-not-found":
        UiHelper.customSnackbar(
            titleMsg: "User Not Found", msg: "User does not Exist");
        break;

      case "wrong-password":
        UiHelper.customSnackbar(
            titleMsg: "Wrong Password", msg: "Please enter correct password");
        break;

      case "deadline-exceeded":
        UiHelper.customSnackbar(
            titleMsg: "Exceeded Time Out",
            msg: "Operation took too long and was canceled");
        break;

      case "unavailable":
        UiHelper.customSnackbar(
            titleMsg: "Service Unavailable",
            msg: "Service are temporarily unavailable");
        break;

      case "aborted":
        UiHelper.customSnackbar(
            titleMsg: "Action Aborted",
            msg: "Operation was aborted due to a conflict");
        break;

      case "not-found":
        UiHelper.customSnackbar(
            titleMsg: "Not Found", msg: "Document or user doesn't exist");
        break;

      case "permission-denied":
        UiHelper.customSnackbar(
            titleMsg: "Permission Denied",
            msg: "User does not have permission to perform the action");
        break;

      case "invalid-argument":
        UiHelper.customSnackbar(
            titleMsg: "Invalid Argument",
            msg: "Invalid argument was passed to the storage operation.");
        break;

      case "unauthorized":
        UiHelper.customSnackbar(
            titleMsg: "Unauthorized Access Denied",
            msg: "User does not have permission to access the file");
        break;

      case "unauthenticated":
        UiHelper.customSnackbar(
            titleMsg: "Unauthenticated Action",
            msg: "User is not authenticated to access the file");
        break;

      case "canceled":
        UiHelper.customSnackbar(
            titleMsg: "Operation Canceled",
            msg: "Upload or download operation was canceled");
        break;

      case "invalid-credential":
        UiHelper.customSnackbar(
            titleMsg: "Invalid Credential",
            msg: "Invalid credential or provide correct details");
        break;

      default:
        UiHelper.customSnackbar(
            titleMsg: "Error Ocurred",
            msg: "Something went wrong please try again");
        break;
    }
  }
}
