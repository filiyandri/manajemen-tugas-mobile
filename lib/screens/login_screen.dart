import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  Future<void> login() async {

    setState(() {
      loading = true;
    });

    try {

      final response = await http.post(

        Uri.parse(
          'http://192.168.1.3:8000/api/login',
        ),

        body: {

          'email':
              emailController.text,

          'password':
              passwordController.text,

        },

      );

      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        final prefs =
            await SharedPreferences
                .getInstance();

        await prefs.setBool(
          'isLoggedIn',
          true,
        );

        await prefs.setString(
          'userName',
          data['user']['name'],
        );

        if (mounted) {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const DashboardScreen(),
            ),
          );

        }

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              'Login gagal',
            ),
          ),

        );

      }

    } catch (e) {

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),

      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [

              Color(0xff0F172A),
              Color(0xff1E1B4B),
              Color(0xff312E81),

            ],

          ),

        ),

        child: Center(

          child: SingleChildScrollView(

            padding:
                const EdgeInsets.all(24),

            child: Container(

              padding:
                  const EdgeInsets.all(24),

              decoration: BoxDecoration(

                color:
                    Colors.white10,

                borderRadius:
                    BorderRadius.circular(24),

              ),

              child: Column(

                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  Container(

                    width: 90,
                    height: 90,

                    decoration:
                        BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(
                              20),

                      gradient:
                          const LinearGradient(

                        colors: [

                          Color(
                              0xff6366F1),

                          Color(
                              0xff8B5CF6),

                        ],

                      ),

                    ),

                    child: const Icon(

                      Icons.menu_book,

                      color:
                          Colors.white,

                      size: 40,

                    ),

                  ),

                  const SizedBox(
                      height: 20),

                  const Text(

                    "Manajemen Tugas Kuliah",

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(

                      color:
                          Colors.white,

                      fontSize: 24,

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),

                  const SizedBox(
                      height: 8),

                  const Text(

                    "Kelola tugas kuliahmu dengan lebih terorganisir",

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      color:
                          Colors.white70,
                    ),

                  ),

                  const SizedBox(
                      height: 30),

                  TextField(

                    controller:
                        emailController,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        InputDecoration(

                      labelText:
                          "Email",

                      labelStyle:
                          const TextStyle(
                        color:
                            Colors.white70,
                      ),

                      filled: true,

                      fillColor:
                          Colors.white10,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                                15),

                        borderSide:
                            BorderSide.none,

                      ),

                    ),

                  ),

                  const SizedBox(
                      height: 15),

                  TextField(

                    controller:
                        passwordController,

                    obscureText: true,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        InputDecoration(

                      labelText:
                          "Password",

                      labelStyle:
                          const TextStyle(
                        color:
                            Colors.white70,
                      ),

                      filled: true,

                      fillColor:
                          Colors.white10,

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                                15),

                        borderSide:
                            BorderSide.none,

                      ),

                    ),

                  ),

                  const SizedBox(
                      height: 25),

                  SizedBox(

                    width:
                        double.infinity,

                    height: 50,

                    child:
                        ElevatedButton(

                      onPressed:
                          loading
                              ? null
                              : login,

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            const Color(
                                0xff6366F1),

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(
                                  15),

                        ),

                      ),

                      child: Text(

                        loading
                            ? "Loading..."
                            : "Login",

                        style:
                            const TextStyle(

                          color:
                              Colors.white,

                          fontWeight:
                              FontWeight.bold,

                        ),

                      ),

                    ),

                  ),

                  const SizedBox(
                      height: 15),

                  TextButton(

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              const RegisterScreen(),

                        ),

                      );

                    },

                    child: const Text(

                      "Belum punya akun? Daftar",

                      style: TextStyle(
                        color:
                            Colors.white,
                      ),

                    ),

                  ),

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

}
