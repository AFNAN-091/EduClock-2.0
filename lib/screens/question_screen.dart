import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'exam_screen.dart';
import 'home_page.dart';
import 'login_screen.dart';
import 'notice_screen.dart';

class QuestionScreen extends StatefulWidget {

  // final String department;
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: context.theme.primaryColor,
        title: const Text('Question Bank',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        centerTitle: true,

      ),
      // drawer: _buildDrawer(),
      body: const Center(
        child: Text('Question Screen'),
      ),
    );
  }





}
