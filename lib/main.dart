import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ifdex/firebase_options.dart';
import 'package:ifdex/app/app.dart';
import 'package:ifdex/app/app_provider_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      observers: kDebugMode ? [AppProviderObserver()] : const [],
      child: const MyApp(),
    ),
  );
}
