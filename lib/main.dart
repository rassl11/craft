import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/blocs/authentication/authentication_bloc.dart';
import 'core/injection_container.dart' as ic;
import 'core/injection_container.dart';
import 'core/repositories/authentication_repository.dart';
import 'core/router/app_router.dart';
import 'core/utils/dialog_provider.dart';
import 'features/login/presentation/pages/launch_screen.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _lockOrientation();
  await ic.init();
  runApp(const MyApp());
}

Future<void> _lockOrientation() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthenticationRepository _authenticationRepository;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = sl<AuthenticationRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return RepositoryProvider.value(
            value: (context) => _authenticationRepository,
            child: BlocProvider(
              create: (context) => sl<AuthenticationBloc>(),
              child: _buildApp(),
            ),
          );
        });
  }

  MaterialApp _buildApp() {
    return MaterialApp(
        title: 'Craftboxx',
        navigatorKey: _navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          canvasColor: Colors.transparent,
        ),
        onGenerateRoute: sl<AppRouter>().onGenerateRoute,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        builder: (context, child) {
          return _listenToAuthenticationBlocChanges(child);
        });
  }

  BlocListener<AuthenticationBloc, AuthenticationState>
      _listenToAuthenticationBlocChanges(Widget? child) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        log('AuthenticationBloc. State received: $state');

        if (state.status == AuthenticationStatus.unauthenticated) {
          _showSessionExpiredAlert();
        }
      },
      child: child,
    );
  }

  void _showSessionExpiredAlert() {
    final navigatorContext = _navigator.overlay!.context;
    sl<DialogProvider>().showPlatformSpecificDialog(
      builderContext: navigatorContext,
      title: S.current.sessionExpired,
      content: S.current.logInAgain,
      positiveButtonTitle: S.current.okUppercase,
      positiveButtonAction: () {
        Navigator.of(navigatorContext).pop();
        Navigator.pushNamedAndRemoveUntil(
          navigatorContext,
          LaunchScreen.routeName,
          (route) => false,
        );
      },
    );
  }
}
