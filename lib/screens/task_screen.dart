import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = ApiService().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tugasku"),
      ),

      body: FutureBuilder<List<Task>>(
        future: tasks,
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {

              final task = data[index];

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  title: Text(task.title),

                  subtitle: Text(
                    "${task.course}\n${task.deadline}",
                  ),

                  trailing: Text(task.status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}