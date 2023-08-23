// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  static String m0(what) => "${what} are not added";

  static String m1(name) => "by ${name}";

  static String m2(value) => "See ${value} results";

  static String m3(what) => "${what} is not added";

  static String m4(name) => "${name} profile";

  static String m5(message) => "Server Failure: ${message}";

  static String m6(number) => "Show more (${number})";

  static String m7(count) =>
      "${Intl.plural(count, one: 'Requirement field is empty', other: 'Requirement fields are empty')}";

  static String m8(humanReadableTime) =>
      "${humanReadableTime} project time have already been recorded. \nDo you want to record more time?";

  static String m9(message) => "Unexpected error: ${message}";

  static String m10(version) => "Version ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accidentalTimeDialogContent": MessageLookupByLibrary.simpleMessage(
            "Project time not is not yet saved. \nDo you really want to go back?"),
        "accidentalTimeDialogTitle":
            MessageLookupByLibrary.simpleMessage("Are you sure?"),
        "accountSettings":
            MessageLookupByLibrary.simpleMessage("Account settings"),
        "actionRequired":
            MessageLookupByLibrary.simpleMessage("Action required"),
        "allProtocolEntries":
            MessageLookupByLibrary.simpleMessage("All protocol entries"),
        "appointment": MessageLookupByLibrary.simpleMessage("Appointment"),
        "appointments": MessageLookupByLibrary.simpleMessage("Appointments"),
        "approval": MessageLookupByLibrary.simpleMessage("Approval"),
        "areNotAdded": m0,
        "assigners": MessageLookupByLibrary.simpleMessage("Assigners"),
        "assignmentDetailsMainButtonText":
            MessageLookupByLibrary.simpleMessage("Protokoll ansehen"),
        "assignmentLoadingError": MessageLookupByLibrary.simpleMessage(
            "Couldn\'t load assignment data."),
        "attachment": MessageLookupByLibrary.simpleMessage("Attachment"),
        "authorizationFailure": MessageLookupByLibrary.simpleMessage(
            "Authorization Failure. Password or username is incorrect."),
        "bag": MessageLookupByLibrary.simpleMessage("Beutel"),
        "bar": MessageLookupByLibrary.simpleMessage("Tafel"),
        "bottle": MessageLookupByLibrary.simpleMessage("Flasche"),
        "box": MessageLookupByLibrary.simpleMessage("Box"),
        "breakTime": MessageLookupByLibrary.simpleMessage("Break time"),
        "bucket": MessageLookupByLibrary.simpleMessage("Eimer"),
        "bunch": MessageLookupByLibrary.simpleMessage("Bund"),
        "by": m1,
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cane": MessageLookupByLibrary.simpleMessage("Dose"),
        "canister": MessageLookupByLibrary.simpleMessage("Kanister"),
        "cardboard": MessageLookupByLibrary.simpleMessage("Karton"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change Password"),
        "changeStatus": MessageLookupByLibrary.simpleMessage("Change status"),
        "changeStatusTitle":
            MessageLookupByLibrary.simpleMessage("Change status"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "contact": MessageLookupByLibrary.simpleMessage("kontakieren"),
        "created": MessageLookupByLibrary.simpleMessage("Created"),
        "cubicMetre": MessageLookupByLibrary.simpleMessage("Kubikmeter"),
        "customer": MessageLookupByLibrary.simpleMessage("Customer"),
        "customerSignature":
            MessageLookupByLibrary.simpleMessage("Customer signature"),
        "days": MessageLookupByLibrary.simpleMessage("Tage"),
        "defaultBodyDescription": MessageLookupByLibrary.simpleMessage(
            "Hier findest du deine heutigen  und zukünftigen Arbeitszettel. Momentan sind dir keine Arbeitszettel zugewiesen."),
        "defaultBodyTitle":
            MessageLookupByLibrary.simpleMessage("Welcome to Craftbox"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteProtocolEntry":
            MessageLookupByLibrary.simpleMessage("Delete protocol entry"),
        "deleteProtocolEntryText": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this protocol entry?"),
        "description": MessageLookupByLibrary.simpleMessage("Description"),
        "documentLoadingError": MessageLookupByLibrary.simpleMessage(
            "Couldn\'t load document data."),
        "documentationTitle":
            MessageLookupByLibrary.simpleMessage("Auftragzeit"),
        "documents": MessageLookupByLibrary.simpleMessage("Documents"),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "dozen": MessageLookupByLibrary.simpleMessage("Dutzend"),
        "draft": MessageLookupByLibrary.simpleMessage("Draft"),
        "drivingTime": MessageLookupByLibrary.simpleMessage("Driving time"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "emailError": MessageLookupByLibrary.simpleMessage("Invalid E-mail"),
        "emailHint": MessageLookupByLibrary.simpleMessage("Enter your email"),
        "enterAttachment":
            MessageLookupByLibrary.simpleMessage("Enter your attachment"),
        "enterBreakTime":
            MessageLookupByLibrary.simpleMessage("Enter your break time"),
        "enterDrivingTime":
            MessageLookupByLibrary.simpleMessage("Enter your driving time"),
        "enterWorkingTime":
            MessageLookupByLibrary.simpleMessage("Enter your working time"),
        "enterYourCustomer":
            MessageLookupByLibrary.simpleMessage("Enter your customer"),
        "enterYourText":
            MessageLookupByLibrary.simpleMessage("Enter your text"),
        "enterYourTitle":
            MessageLookupByLibrary.simpleMessage("Enter your title"),
        "executorSignature":
            MessageLookupByLibrary.simpleMessage("Executor signature"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "filterDone": MessageLookupByLibrary.simpleMessage("Done"),
        "filterInProgress": MessageLookupByLibrary.simpleMessage("In progress"),
        "filterScheduled": MessageLookupByLibrary.simpleMessage("Scheduled"),
        "filterSeeResults": m2,
        "flatFee": MessageLookupByLibrary.simpleMessage("Pauschale"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password"),
        "forgotPasswordDescription": MessageLookupByLibrary.simpleMessage(
            "Don’t worry! It happens. Please enter the address associated with your account"),
        "forgotPasswordQ":
            MessageLookupByLibrary.simpleMessage("Forgot password?"),
        "grams": MessageLookupByLibrary.simpleMessage("Gramm"),
        "hours": MessageLookupByLibrary.simpleMessage("Stunden"),
        "indicatorChecking":
            MessageLookupByLibrary.simpleMessage("Checking your email..."),
        "indicatorLoggingIn":
            MessageLookupByLibrary.simpleMessage("Logging in..."),
        "indicatorLoggingOut":
            MessageLookupByLibrary.simpleMessage("Logging out..."),
        "indicatorPasswordSent": MessageLookupByLibrary.simpleMessage(
            "Password reset link sent to your email"),
        "indicatorUnknownError":
            MessageLookupByLibrary.simpleMessage("Unknown error"),
        "info": MessageLookupByLibrary.simpleMessage("Info"),
        "internetConnectionFailure":
            MessageLookupByLibrary.simpleMessage("No internet connection"),
        "invalidFile": MessageLookupByLibrary.simpleMessage("File is invalid"),
        "isNotAdded": m3,
        "kiloGrams": MessageLookupByLibrary.simpleMessage("Kilogramm"),
        "kilometer": MessageLookupByLibrary.simpleMessage("Kilometer"),
        "kilowattPeak": MessageLookupByLibrary.simpleMessage("Kilowatt Peak"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "launchLogin": MessageLookupByLibrary.simpleMessage("Anmelden"),
        "launchLoginDescription": MessageLookupByLibrary.simpleMessage(
            "Wenn du schon Zugangsdaten hast"),
        "launchTryDemo": MessageLookupByLibrary.simpleMessage("Try the demo"),
        "launchTryDemoDescription": MessageLookupByLibrary.simpleMessage(
            "Noch keine Zugangsdaten? \nOhne Registrierung ausprobieren"),
        "legal": MessageLookupByLibrary.simpleMessage("Legal"),
        "litre": MessageLookupByLibrary.simpleMessage("Liter"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "logInAgain":
            MessageLookupByLibrary.simpleMessage("Please log in again"),
        "logOutTitle":
            MessageLookupByLibrary.simpleMessage("Do you want to logout?"),
        "loginPageFooterText": MessageLookupByLibrary.simpleMessage(
            "Mit Fortsetzen, haben Sie die Datenschutzerklärung zur Kenntnis genommen."),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "material": MessageLookupByLibrary.simpleMessage("Material"),
        "metres": MessageLookupByLibrary.simpleMessage("Meter"),
        "millilitre": MessageLookupByLibrary.simpleMessage("Milliliter"),
        "millimetres": MessageLookupByLibrary.simpleMessage("Millimeter"),
        "more": MessageLookupByLibrary.simpleMessage("More"),
        "moreOptions": MessageLookupByLibrary.simpleMessage("More options"),
        "newPhoto": MessageLookupByLibrary.simpleMessage("New photo"),
        "noAppsToOpen": MessageLookupByLibrary.simpleMessage(
            "No apps can perform this action"),
        "noDocumentsYet": MessageLookupByLibrary.simpleMessage(
            "No documentation has been created yet"),
        "not_scheduled": MessageLookupByLibrary.simpleMessage("Not scheduled"),
        "note": MessageLookupByLibrary.simpleMessage("Note"),
        "off": MessageLookupByLibrary.simpleMessage("OFF"),
        "okUppercase": MessageLookupByLibrary.simpleMessage("OK"),
        "on": MessageLookupByLibrary.simpleMessage("ON"),
        "optional": MessageLookupByLibrary.simpleMessage("Optional"),
        "pack": MessageLookupByLibrary.simpleMessage("Pack"),
        "pair": MessageLookupByLibrary.simpleMessage("Paar"),
        "panel": MessageLookupByLibrary.simpleMessage("Platte"),
        "parcel": MessageLookupByLibrary.simpleMessage("Paket"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordError":
            MessageLookupByLibrary.simpleMessage("Invalid password"),
        "passwordHint":
            MessageLookupByLibrary.simpleMessage("Enter your password"),
        "past": MessageLookupByLibrary.simpleMessage("Past"),
        "pathIsEmpty": MessageLookupByLibrary.simpleMessage(
            "Cannot load a file. Filepath is empty."),
        "paused": MessageLookupByLibrary.simpleMessage("Paused"),
        "pdf": MessageLookupByLibrary.simpleMessage("PDF"),
        "percent": MessageLookupByLibrary.simpleMessage("Prozent"),
        "photo": MessageLookupByLibrary.simpleMessage("Photo"),
        "piece": MessageLookupByLibrary.simpleMessage("Stück"),
        "popDialogContent": MessageLookupByLibrary.simpleMessage(
            "By going back your progress will be lost. Continue?"),
        "popDialogTitle":
            MessageLookupByLibrary.simpleMessage("Unsaved changes"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Support"),
        "profile": m4,
        "projectTime": MessageLookupByLibrary.simpleMessage("Project time"),
        "projectTimeRecorded": MessageLookupByLibrary.simpleMessage(
            "Project time recorded so far "),
        "protocolAppBarTitle": MessageLookupByLibrary.simpleMessage("Protocol"),
        "protocolDialogEnterCustomerName": MessageLookupByLibrary.simpleMessage(
            "Please enter the name of \nthe customer."),
        "protocolEntry": MessageLookupByLibrary.simpleMessage("Protocol entry"),
        "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "required": MessageLookupByLibrary.simpleMessage(
            "At least one field should be set"),
        "resources": MessageLookupByLibrary.simpleMessage("Resources"),
        "roll": MessageLookupByLibrary.simpleMessage("Rolle"),
        "runningMeter": MessageLookupByLibrary.simpleMessage("Laufende Meter"),
        "sac": MessageLookupByLibrary.simpleMessage("Sack"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "saving": MessageLookupByLibrary.simpleMessage("Saving..."),
        "sendLogs":
            MessageLookupByLibrary.simpleMessage("Send logs to support"),
        "serverFailure": m5,
        "sessionExpired":
            MessageLookupByLibrary.simpleMessage("Session Expired"),
        "sessionExpiredPleaseLogin": MessageLookupByLibrary.simpleMessage(
            "Session expired. Please login again."),
        "set": MessageLookupByLibrary.simpleMessage("Satz"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "showMore": MessageLookupByLibrary.simpleMessage("Show more"),
        "showMoreNumber": m6,
        "signatureEmpty": m7,
        "signaturePopDialogNegative":
            MessageLookupByLibrary.simpleMessage("Discard"),
        "signaturePopDialogPositive":
            MessageLookupByLibrary.simpleMessage("Stay on page"),
        "sinceToday": MessageLookupByLibrary.simpleMessage("Since today"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "squareMeter": MessageLookupByLibrary.simpleMessage("Quadratmeter"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "submitApproval":
            MessageLookupByLibrary.simpleMessage("Submit approval"),
        "success": MessageLookupByLibrary.simpleMessage("Success!"),
        "support": MessageLookupByLibrary.simpleMessage("Support"),
        "tapToRefresh":
            MessageLookupByLibrary.simpleMessage("Tap to refresh the screen"),
        "termsDialogContent": MessageLookupByLibrary.simpleMessage(
            "I agree to the Craftboxx Terms and Conditions."),
        "termsDialogPositive": MessageLookupByLibrary.simpleMessage("Agree"),
        "termsDialogTitle":
            MessageLookupByLibrary.simpleMessage("Terms and Conditions"),
        "termsSwitcherText": MessageLookupByLibrary.simpleMessage(
            "I have read and accepted the Terms and Conditions."),
        "text": MessageLookupByLibrary.simpleMessage("Text"),
        "thisFieldIsEmpty":
            MessageLookupByLibrary.simpleMessage("This field is empty"),
        "time": MessageLookupByLibrary.simpleMessage("Time"),
        "timeDialogContent": m8,
        "timeDialogDiscard": MessageLookupByLibrary.simpleMessage("Discard"),
        "timeDialogNegativeButton":
            MessageLookupByLibrary.simpleMessage("Change status only"),
        "timeDialogPositiveButton":
            MessageLookupByLibrary.simpleMessage("Record more time"),
        "timeDialogStay": MessageLookupByLibrary.simpleMessage("Stay on page"),
        "timeDialogTitle":
            MessageLookupByLibrary.simpleMessage("Project times"),
        "timePlaceholder": MessageLookupByLibrary.simpleMessage("-- h -- m"),
        "timeRecorderAppBarTitle":
            MessageLookupByLibrary.simpleMessage("Record project time"),
        "timeRecorderMainButtonTitle":
            MessageLookupByLibrary.simpleMessage("Save"),
        "timesheet": MessageLookupByLibrary.simpleMessage("Timesheet"),
        "title": MessageLookupByLibrary.simpleMessage("Title"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "tons": MessageLookupByLibrary.simpleMessage("Tonnen"),
        "trimming": MessageLookupByLibrary.simpleMessage("Garnitur"),
        "tube": MessageLookupByLibrary.simpleMessage("Tube"),
        "unexpectedFailure": m9,
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "unknownFailure": MessageLookupByLibrary.simpleMessage("Unknown error"),
        "updated": MessageLookupByLibrary.simpleMessage("Updated"),
        "validationFailure":
            MessageLookupByLibrary.simpleMessage("Validation Failure"),
        "version": m10,
        "viewAll": MessageLookupByLibrary.simpleMessage("View all"),
        "workingTime": MessageLookupByLibrary.simpleMessage("Working time")
      };
}
