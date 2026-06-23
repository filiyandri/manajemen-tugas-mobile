import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLogin() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getBool(
            'isLoggedIn') ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      title:
          'Manajemen Tugas Kuliah',

      home: FutureBuilder<bool>(
        future: checkLogin(),

        builder:
            (context, snapshot) {

          if (!snapshot.hasData) {

            return const Scaffold(
              body: Center(
                child:
                    CircularProgressIndicator(),
              ),
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}