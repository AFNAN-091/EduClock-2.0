import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:routine_management/login/cr_login.dart';

import '../screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen's size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              // color: Color.fromARGB(255, 132, 175, 90),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/images/monitor.png'),
                  fit: BoxFit.cover ,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.1, // Responsive padding
                      left: screenWidth * 0.05, // Responsive padding
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\nWelcome to EduClock!',
                          style: TextStyle(
                            fontSize: screenWidth * 0.07, // Responsive font size
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: screenHeight * 0.02), // Responsive spacing
                        Text(
                          'Let\'s manage your time efficiently, one notification at a time!',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045, // Responsive font size
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight * 0.12, // Responsive button height
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06, // Responsive padding
                          vertical: screenHeight * 0.03, // Responsive padding
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            print("Student");
                            Get.to(() => LoginScreen());
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 132, 175, 90),
                            ),
                          ),
                          child: Text(
                            'G. Student',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05, // Responsive font size
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.12, // Responsive button height
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06, // Responsive padding
                          vertical: screenHeight * 0.03, // Responsive padding
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            print("CR");
                            Get.to(() => CrLogin());
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          child: Text(
                            'C.R.',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05, // Responsive font size
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(220, 132, 175, 90),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
