import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/assignments/presentation/pages/assignment_details_screen.dart';
import '../../features/assignments/presentation/pages/assignments_home_screen.dart';
import '../../features/assignments/presentation/pages/time_recorder_screen.dart';
import '../../features/assignments/presentation/pages/time_recorder_viewer_screen.dart';
import '../../features/documents/presentation/pages/documents_list_screen.dart';
import '../../features/login/presentation/pages/forgot_password_screen.dart';
import '../../features/login/presentation/pages/launch_screen.dart';
import '../../features/login/presentation/pages/login_screen.dart';
import '../../features/protocol/presentation/pages/draft_screen.dart';
import '../../features/protocol/presentation/pages/note_editor_screen.dart';
import '../../features/protocol/presentation/pages/note_screen.dart';
import '../../features/protocol/presentation/pages/photo_editor_screen.dart';
import '../../features/protocol/presentation/pages/photo_screen.dart';
import '../../features/protocol/presentation/pages/protocol_screen.dart';
import '../../features/protocol/presentation/pages/signature_screen.dart';
import '../../features/protocol/presentation/pages/submit_approval_screen.dart';
import '../screens/media_viewer.dart';
import '../shared_prefs.dart';

class AppRouter {
  final SharedPrefs _sharedPrefs;

  const AppRouter(this._sharedPrefs);

  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    final routeSettingsName = routeSettings.name;
    final assignmentsHomeRoute =
        _getRoute(const AssignmentsHomeScreen(), routeSettings);
    if (routeSettingsName == LaunchScreen.routeName &&
        _sharedPrefs.token.isNotEmpty) {
      return assignmentsHomeRoute;
    }

    switch (routeSettingsName) {
      case LaunchScreen.routeName:
        return _getRoute(const LaunchScreen(), routeSettings);
      case LoginScreen.routeName:
        return _getRoute(const LoginScreen(), routeSettings);
      case ForgotPasswordScreen.routeName:
        return _getRoute(const ForgotPasswordScreen(), routeSettings);
      case AssignmentDetailsScreen.routeName:
        return _getRoute(const AssignmentDetailsScreen(), routeSettings);
      case TimeRecordsScreen.routeName:
        return _getRoute(const TimeRecordsScreen(), routeSettings);
      case TimeRecordsViewerScreen.routeName:
        return _getRoute(const TimeRecordsViewerScreen(), routeSettings);
      case DocumentsListScreen.routeName:
        return _getRoute(const DocumentsListScreen(), routeSettings);
      case MediaViewer.routeName:
        return _getRoute(const MediaViewer(), routeSettings);
      case ProtocolScreen.routeName:
        return _getRoute(const ProtocolScreen(), routeSettings);
      case SubmitApprovalScreen.routeName:
        return _getRoute(const SubmitApprovalScreen(), routeSettings);
      case SignatureScreen.routeName:
        return _getRoute(const SignatureScreen(), routeSettings);
      case NoteScreen.routeName:
        return _getRoute(const NoteScreen(), routeSettings);
      case NoteEditorScreen.routeName:
        return _getRoute(const NoteEditorScreen(), routeSettings);
      case DraftScreen.routeName:
        return _getRoute(const DraftScreen(), routeSettings);
      case PhotoScreen.routeName:
        return _getRoute(const PhotoScreen(), routeSettings);
      case PhotoEditorScreen.routeName:
        return _getRoute(const PhotoEditorScreen(), routeSettings);
      case AssignmentsHomeScreen.routeName:
        return assignmentsHomeRoute;
      default:
        return null;
    }
  }

  Route<dynamic> _getRoute(Widget screen, RouteSettings routeSettings) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        settings: routeSettings,
        builder: (_) => screen,
      );
    }

    return MaterialPageRoute(
      settings: routeSettings,
      builder: (_) => screen,
    );
  }
}
