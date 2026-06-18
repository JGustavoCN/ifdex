import 'package:flutter/material.dart';
import 'package:ifdex/features/auth/presentation/auth_gate.dart';
import 'package:ifdex/features/home/presentation/home_view.dart';
import 'package:ifdex/shared/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IFdex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AuthGate(child: HomeView()),
    );
  }
}
