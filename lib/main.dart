import 'package:client/screens/ListApp.dart';
import 'package:client/screens/LoginScreen.dart';
import 'package:client/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FamCare());
}

class FamCare extends StatelessWidget {
  const FamCare({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/list': (context) => NotesPage(),
      },
    );
  }
}
