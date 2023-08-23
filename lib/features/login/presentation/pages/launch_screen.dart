import 'package:flutter/material.dart';

import '../widgets/launch_screen/login.dart';
import '../widgets/launch_screen/try_demo.dart';

class LaunchScreen extends StatelessWidget {
  static const routeName = '/';

  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Login(), TryDemo()],
      ),
    );
  }
}
