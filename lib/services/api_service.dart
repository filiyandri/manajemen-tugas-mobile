import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {

  static const String baseUrl =
      'http://192.168.1.8:8000/api/tasks';

  Future<List<Task>> getTasks() async {

    final response =
        await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data
          .map((e) => Task.fromJson(e))
          .toList();
    }

    throw Exception(
      'Gagal mengambil data',
    );
  }

  Future<void> deleteTask(int id) async {

    final response =
        await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200) {

      throw Exception(
        'Gagal menghapus tugas',
      );

    }
  }

  Future<void> updateTask(
    int id,
    String title,
    String course,
    String deadline,
  ) async {

    final response =
        await http.put(

      Uri.parse('$baseUrl/$id'),

      body: {

        'title': title,
        'course': course,
        'deadline': deadline,
        'status': 'pending',

      },
    );

    if (response.statusCode != 200) {

      throw Exception(
        'Gagal update tugas',
      );

    }
  }
}