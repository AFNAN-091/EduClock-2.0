import 'package:flutter/material.dart';
import 'package:routine_management/resources/home_screen.dart';
import 'package:routine_management/screens/resources.dart';

import '../ui/theme.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List courses = [
    {
      'name': 'CSE 101',
      'description': 'Introduction to Computer Science',
      'credits': '3',
      'colors': 5, // Add this line
      'instructor': 'Dr. John Doe',
    },
    {
      'name': 'CSE 102',
      'description': 'Data Structures and Algorithms',
      'credits': '3',
      'colors': 6, // Add this line
      'instructor': 'Dr. Jane Doe',
    },
    {
      'name': 'CSE 103',
      'description': 'Computer Networks',
      'credits': '3',
      'colors': 4, // Add this line
      'instructor': 'Dr. John Doe',
    },
    {
      'name': 'CSE 104',
      'description': 'Database Management Systems',
      'credits': '3',
      'colors': 5, // Add this line
      'instructor': 'Dr. Jane Doe',
    },
    {
      'name': 'CSE 105',
      'description': 'Software Engineering',
      'credits': '3',
      'colors': 2, // Add this line
      'instructor': 'Dr. John Doe',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          print(courses[index]['colors']);
          return Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(8),
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.cyan, // Change this line
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: ListTile(
              title: Text(courses[index]['description']),
              subtitle: Text(courses[index]['name']),
              trailing: Text('${courses[index]['credits']} credits'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                    // builder: (context) => ResourcesScreen(
                    //   department: courses[index]['name'],
                    // ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  }
_getBGClr(int no) {
  switch (no) {
    case 0:
      return yellowDarkColor;
    case 1:
      return pinkishColor;
    case 2:
      return pink;
    case 3:
      return sky;
    case 4:
      return lightGreen;
    default:
      return light;
  }

}
