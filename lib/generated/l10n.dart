// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Session Expired`
  String get sessionExpired {
    return Intl.message(
      'Session Expired',
      name: 'sessionExpired',
      desc: '',
      args: [],
    );
  }

  /// `Please log in again`
  String get logInAgain {
    return Intl.message(
      'Please log in again',
      name: 'logInAgain',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get okUppercase {
    return Intl.message(
      'OK',
      name: 'okUppercase',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get indicatorUnknownError {
    return Intl.message(
      'Unknown error',
      name: 'indicatorUnknownError',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get email {
    return Intl.message(
      'E-mail',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get emailHint {
    return Intl.message(
      'Enter your email',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid E-mail`
  String get emailError {
    return Intl.message(
      'Invalid E-mail',
      name: 'emailError',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load assignment data.`
  String get assignmentLoadingError {
    return Intl.message(
      'Couldn\'t load assignment data.',
      name: 'assignmentLoadingError',
      desc: '',
      args: [],
    );
  }

  /// `Authorization Failure. Password or username is incorrect.`
  String get authorizationFailure {
    return Intl.message(
      'Authorization Failure. Password or username is incorrect.',
      name: 'authorizationFailure',
      desc: '',
      args: [],
    );
  }

  /// `Server Failure: {message}`
  String serverFailure(Object message) {
    return Intl.message(
      'Server Failure: $message',
      name: 'serverFailure',
      desc: '',
      args: [message],
    );
  }

  /// `Unknown error`
  String get unknownFailure {
    return Intl.message(
      'Unknown error',
      name: 'unknownFailure',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get internetConnectionFailure {
    return Intl.message(
      'No internet connection',
      name: 'internetConnectionFailure',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error: {message}`
  String unexpectedFailure(Object message) {
    return Intl.message(
      'Unexpected error: $message',
      name: 'unexpectedFailure',
      desc: '',
      args: [message],
    );
  }

  /// `Validation Failure`
  String get validationFailure {
    return Intl.message(
      'Validation Failure',
      name: 'validationFailure',
      desc: '',
      args: [],
    );
  }

  /// `Session expired. Please login again.`
  String get sessionExpiredPleaseLogin {
    return Intl.message(
      'Session expired. Please login again.',
      name: 'sessionExpiredPleaseLogin',
      desc: '',
      args: [],
    );
  }

  /// `Cannot load a file. Filepath is empty.`
  String get pathIsEmpty {
    return Intl.message(
      'Cannot load a file. Filepath is empty.',
      name: 'pathIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No apps can perform this action`
  String get noAppsToOpen {
    return Intl.message(
      'No apps can perform this action',
      name: 'noAppsToOpen',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get launchLogin {
    return Intl.message(
      'Log in',
      name: 'launchLogin',
      desc: '',
      args: [],
    );
  }

  /// `Wenn du schon Zugangsdaten hast`
  String get launchLoginDescription {
    return Intl.message(
      'Wenn du schon Zugangsdaten hast',
      name: 'launchLoginDescription',
      desc: '',
      args: [],
    );
  }

  /// `Try the demo`
  String get launchTryDemo {
    return Intl.message(
      'Try the demo',
      name: 'launchTryDemo',
      desc: '',
      args: [],
    );
  }

  /// `Noch keine Zugangsdaten? \nOhne Registrierung ausprobieren`
  String get launchTryDemoDescription {
    return Intl.message(
      'Noch keine Zugangsdaten? \nOhne Registrierung ausprobieren',
      name: 'launchTryDemoDescription',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get passwordHint {
    return Intl.message(
      'Enter your password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid password`
  String get passwordError {
    return Intl.message(
      'Invalid password',
      name: 'passwordError',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPasswordQ {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPasswordQ',
      desc: '',
      args: [],
    );
  }

  /// `I have read and accepted the Terms and Conditions.`
  String get termsSwitcherText {
    return Intl.message(
      'I have read and accepted the Terms and Conditions.',
      name: 'termsSwitcherText',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get termsDialogTitle {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `I agree to the Craftboxx Terms and Conditions.`
  String get termsDialogContent {
    return Intl.message(
      'I agree to the Craftboxx Terms and Conditions.',
      name: 'termsDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get termsDialogPositive {
    return Intl.message(
      'Agree',
      name: 'termsDialogPositive',
      desc: '',
      args: [],
    );
  }

  /// `Mit Fortsetzen, haben Sie die Datenschutzerklärung zur Kenntnis genommen.`
  String get loginPageFooterText {
    return Intl.message(
      'Mit Fortsetzen, haben Sie die Datenschutzerklärung zur Kenntnis genommen.',
      name: 'loginPageFooterText',
      desc: '',
      args: [],
    );
  }

  /// `Logging in...`
  String get indicatorLoggingIn {
    return Intl.message(
      'Logging in...',
      name: 'indicatorLoggingIn',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don’t worry! It happens. Please enter the address associated with your account`
  String get forgotPasswordDescription {
    return Intl.message(
      'Don’t worry! It happens. Please enter the address associated with your account',
      name: 'forgotPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Password reset link sent to your email`
  String get indicatorPasswordSent {
    return Intl.message(
      'Password reset link sent to your email',
      name: 'indicatorPasswordSent',
      desc: '',
      args: [],
    );
  }

  /// `Checking your email...`
  String get indicatorChecking {
    return Intl.message(
      'Checking your email...',
      name: 'indicatorChecking',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Appointments`
  String get appointments {
    return Intl.message(
      'Appointments',
      name: 'appointments',
      desc: '',
      args: [],
    );
  }

  /// `Timesheet`
  String get timesheet {
    return Intl.message(
      'Timesheet',
      name: 'timesheet',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Past`
  String get past {
    return Intl.message(
      'Past',
      name: 'past',
      desc: '',
      args: [],
    );
  }

  /// `Since today`
  String get sinceToday {
    return Intl.message(
      'Since today',
      name: 'sinceToday',
      desc: '',
      args: [],
    );
  }

  /// `Not scheduled`
  String get not_scheduled {
    return Intl.message(
      'Not scheduled',
      name: 'not_scheduled',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Craftbox`
  String get defaultBodyTitle {
    return Intl.message(
      'Welcome to Craftbox',
      name: 'defaultBodyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Hier findest du deine heutigen  und zukünftigen Arbeitszettel. Momentan sind dir keine Arbeitszettel zugewiesen.`
  String get defaultBodyDescription {
    return Intl.message(
      'Hier findest du deine heutigen  und zukünftigen Arbeitszettel. Momentan sind dir keine Arbeitszettel zugewiesen.',
      name: 'defaultBodyDescription',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled`
  String get filterScheduled {
    return Intl.message(
      'Scheduled',
      name: 'filterScheduled',
      desc: '',
      args: [],
    );
  }

  /// `In progress`
  String get filterInProgress {
    return Intl.message(
      'In progress',
      name: 'filterInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Action required`
  String get actionRequired {
    return Intl.message(
      'Action required',
      name: 'actionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Paused`
  String get paused {
    return Intl.message(
      'Paused',
      name: 'paused',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get filterDone {
    return Intl.message(
      'Done',
      name: 'filterDone',
      desc: '',
      args: [],
    );
  }

  /// `See {value} results`
  String filterSeeResults(Object value) {
    return Intl.message(
      'See $value results',
      name: 'filterSeeResults',
      desc: '',
      args: [value],
    );
  }

  /// `Logging out...`
  String get indicatorLoggingOut {
    return Intl.message(
      'Logging out...',
      name: 'indicatorLoggingOut',
      desc: '',
      args: [],
    );
  }

  /// `Account settings`
  String get accountSettings {
    return Intl.message(
      'Account settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `{name} profile`
  String profile(Object name) {
    return Intl.message(
      '$name profile',
      name: 'profile',
      desc: '',
      args: [name],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Send logs to support`
  String get sendLogs {
    return Intl.message(
      'Send logs to support',
      name: 'sendLogs',
      desc: '',
      args: [],
    );
  }

  /// `Legal`
  String get legal {
    return Intl.message(
      'Legal',
      name: 'legal',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get privacyPolicy {
    return Intl.message(
      'Support',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to logout?`
  String get logOutTitle {
    return Intl.message(
      'Do you want to logout?',
      name: 'logOutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Version {version}`
  String version(Object version) {
    return Intl.message(
      'Version $version',
      name: 'version',
      desc: '',
      args: [version],
    );
  }

  /// `Appointment`
  String get appointment {
    return Intl.message(
      'Appointment',
      name: 'appointment',
      desc: '',
      args: [],
    );
  }

  /// `Assigners`
  String get assigners {
    return Intl.message(
      'Assigners',
      name: 'assigners',
      desc: '',
      args: [],
    );
  }

  /// `Protokoll ansehen`
  String get assignmentDetailsMainButtonText {
    return Intl.message(
      'Protokoll ansehen',
      name: 'assignmentDetailsMainButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Resources`
  String get resources {
    return Intl.message(
      'Resources',
      name: 'resources',
      desc: '',
      args: [],
    );
  }

  /// `Show more`
  String get showMore {
    return Intl.message(
      'Show more',
      name: 'showMore',
      desc: '',
      args: [],
    );
  }

  /// `Show more ({number})`
  String showMoreNumber(Object number) {
    return Intl.message(
      'Show more ($number)',
      name: 'showMoreNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Documents`
  String get documents {
    return Intl.message(
      'Documents',
      name: 'documents',
      desc: '',
      args: [],
    );
  }

  /// `Protocol entry`
  String get protocolEntry {
    return Intl.message(
      'Protocol entry',
      name: 'protocolEntry',
      desc: '',
      args: [],
    );
  }

  /// `View all`
  String get viewAll {
    return Intl.message(
      'View all',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get photo {
    return Intl.message(
      'Photo',
      name: 'photo',
      desc: '',
      args: [],
    );
  }

  /// `Material`
  String get material {
    return Intl.message(
      'Material',
      name: 'material',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get updated {
    return Intl.message(
      'Updated',
      name: 'updated',
      desc: '',
      args: [],
    );
  }

  /// `kontakieren`
  String get contact {
    return Intl.message(
      'kontakieren',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `{what} are not added`
  String areNotAdded(Object what) {
    return Intl.message(
      '$what are not added',
      name: 'areNotAdded',
      desc: '',
      args: [what],
    );
  }

  /// `{what} is not added`
  String isNotAdded(Object what) {
    return Intl.message(
      '$what is not added',
      name: 'isNotAdded',
      desc: '',
      args: [what],
    );
  }

  /// `Change status`
  String get changeStatus {
    return Intl.message(
      'Change status',
      name: 'changeStatus',
      desc: '',
      args: [],
    );
  }

  /// `Record project time`
  String get timeRecorderAppBarTitle {
    return Intl.message(
      'Record project time',
      name: 'timeRecorderAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get timeRecorderMainButtonTitle {
    return Intl.message(
      'Save',
      name: 'timeRecorderMainButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Working time`
  String get workingTime {
    return Intl.message(
      'Working time',
      name: 'workingTime',
      desc: '',
      args: [],
    );
  }

  /// `Break time`
  String get breakTime {
    return Intl.message(
      'Break time',
      name: 'breakTime',
      desc: '',
      args: [],
    );
  }

  /// `Driving time`
  String get drivingTime {
    return Intl.message(
      'Driving time',
      name: 'drivingTime',
      desc: '',
      args: [],
    );
  }

  /// `Attachment`
  String get attachment {
    return Intl.message(
      'Attachment',
      name: 'attachment',
      desc: '',
      args: [],
    );
  }

  /// `Enter your attachment`
  String get enterAttachment {
    return Intl.message(
      'Enter your attachment',
      name: 'enterAttachment',
      desc: '',
      args: [],
    );
  }

  /// `Enter your working time`
  String get enterWorkingTime {
    return Intl.message(
      'Enter your working time',
      name: 'enterWorkingTime',
      desc: '',
      args: [],
    );
  }

  /// `Enter your break time`
  String get enterBreakTime {
    return Intl.message(
      'Enter your break time',
      name: 'enterBreakTime',
      desc: '',
      args: [],
    );
  }

  /// `Enter your driving time`
  String get enterDrivingTime {
    return Intl.message(
      'Enter your driving time',
      name: 'enterDrivingTime',
      desc: '',
      args: [],
    );
  }

  /// `-- h -- m`
  String get timePlaceholder {
    return Intl.message(
      '-- h -- m',
      name: 'timePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message(
      'Optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `At least one field should be set`
  String get required {
    return Intl.message(
      'At least one field should be set',
      name: 'required',
      desc: '',
      args: [],
    );
  }

  /// `Project time`
  String get documentationTitle {
    return Intl.message(
      'Project time',
      name: 'documentationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Project times`
  String get timeDialogTitle {
    return Intl.message(
      'Project times',
      name: 'timeDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `{humanReadableTime} project time have already been recorded. \nDo you want to record more time?`
  String timeDialogContent(Object humanReadableTime) {
    return Intl.message(
      '$humanReadableTime project time have already been recorded. \nDo you want to record more time?',
      name: 'timeDialogContent',
      desc: '',
      args: [humanReadableTime],
    );
  }

  /// `Record more time`
  String get timeDialogPositiveButton {
    return Intl.message(
      'Record more time',
      name: 'timeDialogPositiveButton',
      desc: '',
      args: [],
    );
  }

  /// `Change status only`
  String get timeDialogNegativeButton {
    return Intl.message(
      'Change status only',
      name: 'timeDialogNegativeButton',
      desc: '',
      args: [],
    );
  }

  /// `Stay on page`
  String get timeDialogStay {
    return Intl.message(
      'Stay on page',
      name: 'timeDialogStay',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get timeDialogDiscard {
    return Intl.message(
      'Discard',
      name: 'timeDialogDiscard',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get accidentalTimeDialogTitle {
    return Intl.message(
      'Are you sure?',
      name: 'accidentalTimeDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Project time not is not yet saved. \nDo you really want to go back?`
  String get accidentalTimeDialogContent {
    return Intl.message(
      'Project time not is not yet saved. \nDo you really want to go back?',
      name: 'accidentalTimeDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `Project time recorded so far `
  String get projectTimeRecorded {
    return Intl.message(
      'Project time recorded so far ',
      name: 'projectTimeRecorded',
      desc: '',
      args: [],
    );
  }

  /// `Change status`
  String get changeStatusTitle {
    return Intl.message(
      'Change status',
      name: 'changeStatusTitle',
      desc: '',
      args: [],
    );
  }

  /// `Protocol`
  String get protocolAppBarTitle {
    return Intl.message(
      'Protocol',
      name: 'protocolAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `by {name}`
  String by(Object name) {
    return Intl.message(
      'by $name',
      name: 'by',
      desc: '',
      args: [name],
    );
  }

  /// `Submit approval`
  String get submitApproval {
    return Intl.message(
      'Submit approval',
      name: 'submitApproval',
      desc: '',
      args: [],
    );
  }

  /// `No documentation has been created yet`
  String get noDocumentsYet {
    return Intl.message(
      'No documentation has been created yet',
      name: 'noDocumentsYet',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer {
    return Intl.message(
      'Customer',
      name: 'customer',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Success!`
  String get success {
    return Intl.message(
      'Success!',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, one{Requirement field is empty} other{Requirement fields are empty}}`
  String signatureEmpty(num count) {
    return Intl.plural(
      count,
      one: 'Requirement field is empty',
      other: 'Requirement fields are empty',
      name: 'signatureEmpty',
      desc: '',
      args: [count],
    );
  }

  /// `This field is empty`
  String get thisFieldIsEmpty {
    return Intl.message(
      'This field is empty',
      name: 'thisFieldIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Enter your customer`
  String get enterYourCustomer {
    return Intl.message(
      'Enter your customer',
      name: 'enterYourCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Customer signature`
  String get customerSignature {
    return Intl.message(
      'Customer signature',
      name: 'customerSignature',
      desc: '',
      args: [],
    );
  }

  /// `Executor signature`
  String get executorSignature {
    return Intl.message(
      'Executor signature',
      name: 'executorSignature',
      desc: '',
      args: [],
    );
  }

  /// `Unsaved changes`
  String get popDialogTitle {
    return Intl.message(
      'Unsaved changes',
      name: 'popDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `By going back your progress will be lost. Continue?`
  String get popDialogContent {
    return Intl.message(
      'By going back your progress will be lost. Continue?',
      name: 'popDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `Stay on page`
  String get signaturePopDialogPositive {
    return Intl.message(
      'Stay on page',
      name: 'signaturePopDialogPositive',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get signaturePopDialogNegative {
    return Intl.message(
      'Discard',
      name: 'signaturePopDialogNegative',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the name of \nthe customer.`
  String get protocolDialogEnterCustomerName {
    return Intl.message(
      'Please enter the name of \nthe customer.',
      name: 'protocolDialogEnterCustomerName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your title`
  String get enterYourTitle {
    return Intl.message(
      'Enter your title',
      name: 'enterYourTitle',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your text`
  String get enterYourText {
    return Intl.message(
      'Enter your text',
      name: 'enterYourText',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get text {
    return Intl.message(
      'Text',
      name: 'text',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `More options`
  String get moreOptions {
    return Intl.message(
      'More options',
      name: 'moreOptions',
      desc: '',
      args: [],
    );
  }

  /// `Tap to refresh the screen`
  String get tapToRefresh {
    return Intl.message(
      'Tap to refresh the screen',
      name: 'tapToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Delete protocol entry`
  String get deleteProtocolEntry {
    return Intl.message(
      'Delete protocol entry',
      name: 'deleteProtocolEntry',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this protocol entry?`
  String get deleteProtocolEntryText {
    return Intl.message(
      'Are you sure you want to delete this protocol entry?',
      name: 'deleteProtocolEntryText',
      desc: '',
      args: [],
    );
  }

  /// `Created`
  String get created {
    return Intl.message(
      'Created',
      name: 'created',
      desc: '',
      args: [],
    );
  }

  /// `Saving...`
  String get saving {
    return Intl.message(
      'Saving...',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  /// `New photo`
  String get newPhoto {
    return Intl.message(
      'New photo',
      name: 'newPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `ON`
  String get on {
    return Intl.message(
      'ON',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `OFF`
  String get off {
    return Intl.message(
      'OFF',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `Bag`
  String get bag {
    return Intl.message(
      'Bag',
      name: 'bag',
      desc: '',
      args: [],
    );
  }

  /// `Bar`
  String get bar {
    return Intl.message(
      'Bar',
      name: 'bar',
      desc: '',
      args: [],
    );
  }

  /// `Bottle`
  String get bottle {
    return Intl.message(
      'Bottle',
      name: 'bottle',
      desc: '',
      args: [],
    );
  }

  /// `Box`
  String get box {
    return Intl.message(
      'Box',
      name: 'box',
      desc: '',
      args: [],
    );
  }

  /// `Bucket`
  String get bucket {
    return Intl.message(
      'Bucket',
      name: 'bucket',
      desc: '',
      args: [],
    );
  }

  /// `Bunch`
  String get bunch {
    return Intl.message(
      'Bunch',
      name: 'bunch',
      desc: '',
      args: [],
    );
  }

  /// `Cane`
  String get cane {
    return Intl.message(
      'Cane',
      name: 'cane',
      desc: '',
      args: [],
    );
  }

  /// `Canister`
  String get canister {
    return Intl.message(
      'Canister',
      name: 'canister',
      desc: '',
      args: [],
    );
  }

  /// `Cardboard`
  String get cardboard {
    return Intl.message(
      'Cardboard',
      name: 'cardboard',
      desc: '',
      args: [],
    );
  }

  /// `Cubic meter`
  String get cubicMetre {
    return Intl.message(
      'Cubic meter',
      name: 'cubicMetre',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message(
      'Days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Dozen`
  String get dozen {
    return Intl.message(
      'Dozen',
      name: 'dozen',
      desc: '',
      args: [],
    );
  }

  /// `Flat fee`
  String get flatFee {
    return Intl.message(
      'Flat fee',
      name: 'flatFee',
      desc: '',
      args: [],
    );
  }

  /// `Gram`
  String get grams {
    return Intl.message(
      'Gram',
      name: 'grams',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get hours {
    return Intl.message(
      'Hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `Kilogram`
  String get kiloGrams {
    return Intl.message(
      'Kilogram',
      name: 'kiloGrams',
      desc: '',
      args: [],
    );
  }

  /// `Kilometer`
  String get kilometer {
    return Intl.message(
      'Kilometer',
      name: 'kilometer',
      desc: '',
      args: [],
    );
  }

  /// `Kilowatt Peak`
  String get kilowattPeak {
    return Intl.message(
      'Kilowatt Peak',
      name: 'kilowattPeak',
      desc: '',
      args: [],
    );
  }

  /// `Litre`
  String get litre {
    return Intl.message(
      'Litre',
      name: 'litre',
      desc: '',
      args: [],
    );
  }

  /// `Metre`
  String get metres {
    return Intl.message(
      'Metre',
      name: 'metres',
      desc: '',
      args: [],
    );
  }

  /// `Millilitre`
  String get millilitre {
    return Intl.message(
      'Millilitre',
      name: 'millilitre',
      desc: '',
      args: [],
    );
  }

  /// `Millimetre`
  String get millimetres {
    return Intl.message(
      'Millimetre',
      name: 'millimetres',
      desc: '',
      args: [],
    );
  }

  /// `Pack`
  String get pack {
    return Intl.message(
      'Pack',
      name: 'pack',
      desc: '',
      args: [],
    );
  }

  /// `Pair`
  String get pair {
    return Intl.message(
      'Pair',
      name: 'pair',
      desc: '',
      args: [],
    );
  }

  /// `Panel`
  String get panel {
    return Intl.message(
      'Panel',
      name: 'panel',
      desc: '',
      args: [],
    );
  }

  /// `Parcel`
  String get parcel {
    return Intl.message(
      'Parcel',
      name: 'parcel',
      desc: '',
      args: [],
    );
  }

  /// `Percent`
  String get percent {
    return Intl.message(
      'Percent',
      name: 'percent',
      desc: '',
      args: [],
    );
  }

  /// `Piece`
  String get piece {
    return Intl.message(
      'Piece',
      name: 'piece',
      desc: '',
      args: [],
    );
  }

  /// `Roll`
  String get roll {
    return Intl.message(
      'Roll',
      name: 'roll',
      desc: '',
      args: [],
    );
  }

  /// `Running meter`
  String get runningMeter {
    return Intl.message(
      'Running meter',
      name: 'runningMeter',
      desc: '',
      args: [],
    );
  }

  /// `Sac`
  String get sac {
    return Intl.message(
      'Sac',
      name: 'sac',
      desc: '',
      args: [],
    );
  }

  /// `Set`
  String get set {
    return Intl.message(
      'Set',
      name: 'set',
      desc: '',
      args: [],
    );
  }

  /// `Square meter`
  String get squareMeter {
    return Intl.message(
      'Square meter',
      name: 'squareMeter',
      desc: '',
      args: [],
    );
  }

  /// `Tons`
  String get tons {
    return Intl.message(
      'Tons',
      name: 'tons',
      desc: '',
      args: [],
    );
  }

  /// `Trimming`
  String get trimming {
    return Intl.message(
      'Trimming',
      name: 'trimming',
      desc: '',
      args: [],
    );
  }

  /// `Tube`
  String get tube {
    return Intl.message(
      'Tube',
      name: 'tube',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `File is invalid`
  String get invalidFile {
    return Intl.message(
      'File is invalid',
      name: 'invalidFile',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load document data.`
  String get documentLoadingError {
    return Intl.message(
      'Couldn\'t load document data.',
      name: 'documentLoadingError',
      desc: '',
      args: [],
    );
  }

  /// `All protocol entries`
  String get allProtocolEntries {
    return Intl.message(
      'All protocol entries',
      name: 'allProtocolEntries',
      desc: '',
      args: [],
    );
  }

  /// `Project time`
  String get projectTime {
    return Intl.message(
      'Project time',
      name: 'projectTime',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get draft {
    return Intl.message(
      'Draft',
      name: 'draft',
      desc: '',
      args: [],
    );
  }

  /// `PDF`
  String get pdf {
    return Intl.message(
      'PDF',
      name: 'pdf',
      desc: '',
      args: [],
    );
  }

  /// `Approval`
  String get approval {
    return Intl.message(
      'Approval',
      name: 'approval',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
