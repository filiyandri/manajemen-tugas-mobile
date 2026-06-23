import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskScreen> createState() =>
      _EditTaskScreenState();
}

class _EditTaskScreenState
    extends State<EditTaskScreen> {

  late TextEditingController title;
  late TextEditingController course;
  late TextEditingController deadline;

  String selectedStatus = 'pending';

  @override
  void initState() {
    super.initState();

    title = TextEditingController(
      text: widget.task.title,
    );

    course = TextEditingController(
      text: widget.task.course,
    );

    deadline = TextEditingController(
      text: widget.task.deadline,
    );

    selectedStatus = widget.task.status;
  }

  InputDecoration fieldStyle(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,

      labelStyle: const TextStyle(
        color: Colors.white70,
      ),

      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),

      filled: true,
      fillColor: Colors.white10,

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor:
            const Color(0xff0F172A),

        elevation: 0,

        title: const Text(
          "Edit Tugas",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Container(

          padding:
              const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white10,

            borderRadius:
                BorderRadius.circular(24),
          ),

          child: Column(

            children: [

              TextField(
                controller: title,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: fieldStyle(
                  "Judul Tugas",
                  Icons.task_alt,
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: course,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: fieldStyle(
                  "Mata Kuliah",
                  Icons.book,
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: deadline,

                readOnly: true,

                style: const TextStyle(
                  color: Colors.white,
                ),

                onTap: () async {

                  DateTime? picked =
                      await showDatePicker(

                    context: context,

                    initialDate:
                        DateTime.now(),

                    firstDate:
                        DateTime(2024),

                    lastDate:
                        DateTime(2030),

                  );

                  if (picked != null) {

                    deadline.text =
                        picked
                            .toString()
                            .split(' ')[0];

                  }

                },

                decoration: fieldStyle(
                  "Deadline",
                  Icons.calendar_month,
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: selectedStatus,

                dropdownColor:
                    const Color(
                        0xff1E293B),

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: fieldStyle(
                  "Status",
                  Icons.flag,
                ),

                items: const [

                  DropdownMenuItem(
                    value: 'pending',
                    child: Text(
                      'Pending',
                    ),
                  ),

                  DropdownMenuItem(
                    value: 'selesai',
                    child: Text(
                      'Selesai',
                    ),
                  ),

                ],

                onChanged: (value) {

                  setState(() {

                    selectedStatus =
                        value!;

                  });

                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              16),
                    ),
                  ),

                  onPressed: () async {

                    await ApiService()
                        .updateTask(

                      widget.task.id,

                      title.text,

                      course.text,

                      deadline.text,

                      selectedStatus,

                    );

                    if (mounted) {

                      Navigator.pop(
                        context,
                        true,
                      );

                    }
                  },

                  child: const Text(
                    "UPDATE TUGAS",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}