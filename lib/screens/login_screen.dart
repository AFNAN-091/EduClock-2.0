import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:routine_management/login/welcome_screen.dart';
import 'package:routine_management/screens/home_page.dart';
import 'package:routine_management/screens/semester.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // Example list of departments and images
  final List<Map<String, String>> departments = [
    {"department": "Archi", "imageUrl": "assets/images/archi.png"},
    {"department": "Anthropology", "imageUrl": "assets/images/anthropology.png"},
    {"department": "Bangla", "imageUrl": "assets/images/bangla.png"},
    {"department": "BBA", "imageUrl": "assets/images/bba.png"},
    {"department": "BMB", "imageUrl": "assets/images/bmb.png"},
    {"department": "CEE", "imageUrl": "assets/images/cee.png"},
    {"department": "CEP", "imageUrl": "assets/images/cep.png"},
    {"department": "CHEMISTRY", "imageUrl": "assets/images/chemistry.png"},

    {"department": "CSE", "imageUrl": "assets/images/cse.png"},
    {"department": "ECONOMICS", "imageUrl": "assets/images/economics.png"},

    {"department": "EEE", "imageUrl": "assets/images/eee.png"},
    {"department": "ENG", "imageUrl": "assets/images/eng.png"},
    {"department": "FET", "imageUrl": "assets/images/fet.png"},
    {"department": "GEB", "imageUrl": "assets/images/geb.png"},
    {"department": "IPE", "imageUrl": "assets/images/ipe.png"},
    {"department": "MATH", "imageUrl": "assets/images/math.png"},
    {"department": "ME", "imageUrl": "assets/images/me.png"},
    {"department": "Oceanography", "imageUrl": "assets/images/oceanography.png"},
    {"department": "PHYSICS", "imageUrl": "assets/images/physics.png"},
    {"department": "PSS", "imageUrl": "assets/images/pss.png"},
    {"department": "Social Work", "imageUrl": "assets/images/social work.png"},
    {"department": "Sociology", "imageUrl": "assets/images/sociology.png"},
    {"department": "Statistics", "imageUrl": "assets/images/statistics.png"},
    {"department": "SWE", "imageUrl": "assets/images/swe.png"},

    // {"department": "History", "imageUrl": "assets/images/history.png"},
    // {"department": "Islamic Studies", "imageUrl": "assets/images/islamic.png"},
    // {"department": "Philosophy", "imageUrl": "assets/images/philosophy.png"},
    // {"department": "Political Science", "imageUrl": "assets/images/political.png"},
    // {"department": "Public Administration", "imageUrl": "assets/images/public.png"},

  ];

  final departmentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(
           automaticallyImplyLeading: false,
           title: const Text("Select Your Department",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
             textAlign: TextAlign.left,
           ),
            backgroundColor: Colors.white,
            elevation: 0,
           actions: [
              IconButton(
                onPressed: () async {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Get.to(() => WelcomeScreen());
                },
                icon: const FaIcon(FontAwesomeIcons.rightFromBracket, color: Colors.black),
              ),
           ],
         ),
         body: Padding(

           padding: const EdgeInsets.all(10),

             child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3
              ),
             itemCount: departments.length,
             itemBuilder: (BuildContext context, int index) {
               return deptList(
                 context,
                 department: departments[index]["department"]!,
                 imageUrl: departments[index]["imageUrl"]!,
                 onTap: () async {
                   final prefs = await SharedPreferences.getInstance();
                   await prefs.setString('department', departments[index]["department"]!);

                   Get.to(() =>  Semester());

                 },
               );
             },

           )
         ),
      );
  }

  Widget deptList(
      BuildContext context,{
        required String department,
        required String imageUrl,
        required onTap,

  })  {
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
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(imageUrl,
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Text(department, style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
            )),
          ],
        ),
      ),
    );
  }

}


