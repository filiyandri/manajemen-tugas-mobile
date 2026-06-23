import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {

  static const String baseUrl =
      'http://192.168.1.7:8000/api';

  Future<bool> login(
    String email,
    String password,
  ) async {

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    return response.statusCode == 200;
  }

  Future<bool> register(
    String name,
    String email,
    String password,
  ) async {

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    return response.statusCode == 200;
  }
}