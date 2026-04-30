import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'views/home_view.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

<<<<<<< HEAD
  // Injeta as chaves secretas (do Web e Android) no seu aplicativo
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
=======
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
>>>>>>> fc8ab80 (feat: implementa MVP do IFDEX com listagem, cadastro, edição e gamificação)

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
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
=======
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeView(),
>>>>>>> fc8ab80 (feat: implementa MVP do IFDEX com listagem, cadastro, edição e gamificação)
    );
  }
}
