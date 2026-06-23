import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  bool loading = false;

  Future<void> register() async {

    if (passwordController.text !=
        confirmPasswordController.text) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Password tidak sama',
          ),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    final response = await http.post(
      Uri.parse(
        'http://192.168.1.3:8000/api/register',
      ),

      body: {
        'name':
            nameController.text,
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

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Register berhasil',
            ),
          ),
        );

        Navigator.pop(context);
      }

    } else {

      final data =
          jsonDecode(response.body);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            data['message'] ??
                'Register gagal',
          ),
        ),
      );
    }
  }

  InputDecoration inputStyle(
      String label) {

    return InputDecoration(
      labelText: label,

      labelStyle:
          const TextStyle(
        color: Colors.white70,
      ),

      filled: true,

      fillColor:
          Colors.white10,

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide:
            BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration:
            const BoxDecoration(

          gradient:
              LinearGradient(

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

              decoration:
                  BoxDecoration(

                color:
                    Colors.white10,

                borderRadius:
                    BorderRadius.circular(
                        24),
              ),

              child: Column(

                children: [

                  Container(
                    width: 90,
                    height: 90,

                    decoration:
                        BoxDecoration(

                      borderRadius:
                          BorderRadius
                              .circular(
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
                    "Daftar Akun",
                    style: TextStyle(
                      color:
                          Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 30),

                  TextField(
                    controller:
                        nameController,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),
                    decoration:
                        inputStyle(
                      "Nama Lengkap",
                    ),
                  ),

                  const SizedBox(
                      height: 15),

                  TextField(
                    controller:
                        emailController,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),
                    decoration:
                        inputStyle(
                      "Email",
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
                        inputStyle(
                      "Password",
                    ),
                  ),

                  const SizedBox(
                      height: 15),

                  TextField(
                    controller:
                        confirmPasswordController,
                    obscureText: true,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),
                    decoration:
                        inputStyle(
                      "Konfirmasi Password",
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
                              : register,

                      child: Text(
                        loading
                            ? "Loading..."
                            : "Daftar",
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 15),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context);
                    },

                    child: const Text(
                      "Sudah punya akun? Login",
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