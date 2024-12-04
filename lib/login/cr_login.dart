import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/login_screen.dart';

class CrLogin extends StatelessWidget {
  CrLogin({Key? key}) : super(key: key);

  final departmentController = TextEditingController();
  final semesterController = TextEditingController();
  final passwordController = TextEditingController();

  Widget login(IconData icon, String label, {Function()? onPressed}){
    return Container(
      height: 50,
      width: 140,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.8), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          TextButton(
              onPressed: onPressed,
              child: Text(label,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 132, 175, 90)))),
        ],
      ),
    );
  }

  Widget userInput(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade400,
          borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 15, right: 25),
        child: TextField(
          controller: userInput,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: false,
          decoration: InputDecoration.collapsed(
            hintText: hintTitle,
            hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontStyle: FontStyle.italic),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
              image: AssetImage('assets/images/profile1.png')),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 570,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 45),
                    userInput(departmentController, 'Department',
                        TextInputType.text),
                    userInput(semesterController, 'Semester',
                        TextInputType.text),
                    userInput(passwordController, 'Password',
                        TextInputType.visiblePassword),
                    Container(
                      height: 55,

                      padding:
                          const EdgeInsets.only(top: 5, left: 70, right: 70),
                      child: ElevatedButton(
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        // color: Colors.indigo.shade800,
                        onPressed: () {
                          print(departmentController);
                          print(semesterController);
                          print(passwordController);
                          // Provider.of<Auth>(context, listen: false).login(emailController.text, passwordController.text);
                          // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SuccessfulScreen()));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(246, 147, 24, 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          login(Icons.add, "G.Student", onPressed: () {
                            Get.to(() => LoginScreen());
                          },
                          ),
                          login(Icons.book_online, "CR.", onPressed: () {
                          },
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 0, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
