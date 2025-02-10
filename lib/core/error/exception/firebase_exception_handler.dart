import 'package:s_bazar/utils/Uihelper/custom_snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExceptionHelper {
  static void exceptionHandler(FirebaseException exception) {
    switch (exception.code) {
      case "invalid-email":
        SnackbarHelper.customSnackbar(
            titleMsg: "Invalid Email",
            msg: "Please provide correct email or valid email");
        break;

      case "user-disabled":
        SnackbarHelper.customSnackbar(
            titleMsg: "User Disabled",
            msg: "User account has been disabled by an administrator");
        break;

      case "weak-password":
        SnackbarHelper.customSnackbar(
            titleMsg: "Weak Password", msg: "Please provide strong password");
        break;

      case "operation-not-allowed":
        SnackbarHelper.customSnackbar(
            titleMsg: "Opeartion Not Allowed",
            msg: "This action not allowed or unauthorized access");
        break;

      case "email-already-in-use":
        SnackbarHelper.customSnackbar(
            titleMsg: "Email Id Already In Use",
            msg: "This email is already associated with another account");
        break;

      case "user-not-found":
        SnackbarHelper.customSnackbar(
            titleMsg: "User Not Found", msg: "User does not Exist");
        break;

      case "wrong-password":
        SnackbarHelper.customSnackbar(
            titleMsg: "Wrong Password", msg: "Please enter correct password");
        break;

      case "deadline-exceeded":
        SnackbarHelper.customSnackbar(
            titleMsg: "Exceeded Time Out",
            msg: "Operation took too long and was canceled");
        break;

      case "unavailable":
        SnackbarHelper.customSnackbar(
            titleMsg: "Service Unavailable",
            msg: "Service are temporarily unavailable");
        break;

      case "aborted":
        SnackbarHelper.customSnackbar(
            titleMsg: "Action Aborted",
            msg: "Operation was aborted due to a conflict");
        break;

      case "not-found":
        SnackbarHelper.customSnackbar(
            titleMsg: "Not Found", msg: "Document or user doesn't exist");
        break;

      case "permission-denied":
        SnackbarHelper.customSnackbar(
            titleMsg: "Permission Denied",
            msg: "User does not have permission to perform the action");
        break;

      case "invalid-argument":
        SnackbarHelper.customSnackbar(
            titleMsg: "Invalid Argument",
            msg: "Invalid argument was passed to the storage operation.");
        break;

      case "unauthorized":
        SnackbarHelper.customSnackbar(
            titleMsg: "Unauthorized Access Denied",
            msg: "User does not have permission to access the file");
        break;

      case "unauthenticated":
        SnackbarHelper.customSnackbar(
            titleMsg: "Unauthenticated Action",
            msg: "User is not authenticated to access the file");
        break;

      case "canceled":
        SnackbarHelper.customSnackbar(
            titleMsg: "Operation Canceled",
            msg: "Upload or download operation was canceled");
        break;

      case "invalid-credential":
        SnackbarHelper.customSnackbar(
            titleMsg: "Invalid Credential",
            msg: "Invalid credential or provide correct details");
        break;

      default:
        SnackbarHelper.customSnackbar(
            titleMsg: "Error Ocurred",
            msg: "Something went wrong please try again");
        break;
    }
  }
}
