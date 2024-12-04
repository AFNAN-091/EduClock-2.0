import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:routine_management/screens/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class Semester extends StatelessWidget {
  Semester({super.key});

  final List<String> semesters = [
    " 1/1",
    " 1/2",
    " 2/1",
    " 2/2",
    " 3/1",
    " 3/2",
    " 4/1",
    " 4/2"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft),
          color: Colors.black,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(

        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Select your semester",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3
                  ),
                  itemCount: semesters.length,
                  itemBuilder: (BuildContext context, int index) {
                    return semesterList(
                      context,
                      semester: semesters[index],
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('semester', semesters[index]);
                        Get.to(() => const NavigationBarApp());
                      },
                    );
                  },
                        ),
            ),
          ),
        ],
      ));
  }

  Widget semesterList(
    BuildContext context,{
      required String semester,
      required onTap,
    }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: Colors.blueGrey,
              width: 0.5,
          ),

        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          const Icon(
          Icons.school,
          ),
            const SizedBox(width: 10),
            Text(
              semester,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
}

}
