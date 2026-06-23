import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTaskScreen extends StatefulWidget {
const AddTaskScreen({super.key});

@override
State<AddTaskScreen> createState() =>
    _AddTaskScreenState();
}

class _AddTaskScreenState
    extends State<AddTaskScreen> {

final titleController = TextEditingController();
final courseController = TextEditingController();
final deadlineController = TextEditingController();
final descriptionController = TextEditingController();
String selectedStatus = 'pending';


Future saveTask() async {

final response = await http.post(
  Uri.parse('http://192.168.1.3:8000/api/tasks'),
  body: {
  'title': titleController.text,
  'course': courseController.text,
  'deadline': deadlineController.text,
  'description': descriptionController.text,
  'status': selectedStatus,
},
);
print(response.statusCode);
print(response.body);
if(response.statusCode == 200 ||
    response.statusCode == 201){

  if(mounted){
    Navigator.pop(context, true);
  }
}

}

InputDecoration fieldStyle(
String label,
IconData icon) {

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
      "Tambah Tugas",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),

  body: SingleChildScrollView(

    padding:
        const EdgeInsets.all(20),

    child: Column(

      children: [

        Container(

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
                controller:
                    titleController,

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
                controller:
                    courseController,

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
  controller: deadlineController,

  readOnly: true,

  style: const TextStyle(
    color: Colors.white,
  ),

  onTap: () async {

    DateTime? picked =
        await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2024),

      lastDate: DateTime(2030),

    );

    if (picked != null) {

      deadlineController.text =
          picked.toString().split(' ')[0];

    }
  },

  decoration: fieldStyle(
    "Deadline",
    Icons.calendar_month,
  ),
),

              DropdownButtonFormField<String>(
value: selectedStatus,

dropdownColor: const Color(0xff1E293B),

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
  child: Text('Pending'),
),

DropdownMenuItem(
  value: 'selesai',
  child: Text('Selesai'),
),

],

onChanged: (value) {

setState(() {

  selectedStatus = value!;

});

},

),

const SizedBox(height: 15),

TextField(
controller:
descriptionController,

maxLines: 3,

style: const TextStyle(
color: Colors.white,
),

decoration: fieldStyle(
"Deskripsi",
Icons.description,
),
),


              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,

                height: 55,

                child: ElevatedButton(

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),

                  onPressed: saveTask,

                  child: const Text(
                    "SIMPAN TUGAS",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              )

            ],
          ),
        ),

      ],
    ),
  ),
);

}
}