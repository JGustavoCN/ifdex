import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  // Garante que o motor do Flutter esteja rodando antes de chamar o código nativo
  WidgetsFlutterBinding.ensureInitialized();

  // Injeta as chaves secretas (do Web e Android) no seu aplicativo
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IFdex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green, // Cor base sugerida (verde do IF)
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('Fundação do IFdex Pronta!')),
      ),
    );
  }
}
