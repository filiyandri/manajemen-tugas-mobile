import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Task>> tasks;
  String userName = "Setiyo";
Future<void> loadUser() async {

  final prefs =
      await SharedPreferences.getInstance();

  setState(() {

    userName =
        prefs.getString('userName') ??
        "Setiyo";

  });
}
 @override
void initState() {
  super.initState();

  tasks = ApiService().getTasks();

  loadUser();
}

  void refreshTasks() {
    setState(() {
      tasks = ApiService().getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTaskScreen(),
            ),
          );

          if (result == true) {
            refreshTasks();
          }
        },
      ),

     appBar: AppBar(
  backgroundColor: const Color(0xff0F172A),
  elevation: 0,

  title: const Text(
    "Manajemen Tugas Kuliah",
    style: TextStyle(
      color: Colors.white,
    ),
  ),

  actions: [

    IconButton(

      icon: const Icon(
        Icons.logout,
        color: Colors.white,
      ),

      onPressed: () async {

        final prefs =
            await SharedPreferences.getInstance();

        await prefs.clear();

        if(mounted){

          Navigator.pushAndRemoveUntil(

            context,

            MaterialPageRoute(
              builder: (_) =>
                  const LoginScreen(),
            ),

            (route) => false,

          );

        }

      },
    ),

  ],
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
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          final data = snapshot.data ?? [];

          final total = data.length;

          final pending = data
              .where((e) => e.status == 'pending')
              .length;

          final selesai = data
              .where((e) => e.status == 'selesai')
              .length;

          final progress =
              total == 0 ? 0.0 : selesai / total;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
  "Halo $userName 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [

                    Expanded(
                      child: statCard(
                        "Total",
                        total.toString(),
                        Colors.blue,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: statCard(
                        "Pending",
                        pending.toString(),
                        Colors.orange,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: statCard(
                        "Selesai",
                        selesai.toString(),
                        Colors.green,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        "Progress ${(progress * 100).toInt()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        borderRadius:
                            BorderRadius.circular(10),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Daftar Tugas",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ...data.map((task) {

                  return Card(
                    color: Colors.white10,

                    child: ListTile(

  onTap: () async {

    final result =
        await Navigator.push(

      context,

      MaterialPageRoute(
        builder: (_) =>
            EditTaskScreen(
          task: task,
        ),
      ),
    );

    if(result == true){

      refreshTasks();

    }
  },

                      title: Text(
                        task.title,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      subtitle: Text(
                        "${task.course}\n${task.deadline}",
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,

                        children: [

                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: task.status ==
                                      "selesai"
                                  ? Colors.green
                                  : Colors.orange,

                              borderRadius:
                                  BorderRadius.circular(20),
                            ),

                            child: Text(
                              task.status,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),

                            onPressed: () async {

                              await ApiService()
                                  .deleteTask(task.id);

                              refreshTasks();
                            },
                          ),

                        ],
                      ),
                    ),
                  );

                }).toList(),

              ],
            ),
          );
        },
      ),
    );
  }

  Widget statCard(
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(
        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}