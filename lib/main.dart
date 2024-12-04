
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:routine_management/login/welcome_screen.dart';
import 'package:routine_management/screens/home_page.dart';
import 'package:routine_management/screens/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:routine_management/screens/login_screen.dart';
import 'package:routine_management/screens/demo.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'controllers/exam_controller.dart';


import 'db/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DBHelper.init();
  await Firebase.initializeApp();



  // await FirebaseAppCheck.instance.activate(
  //   // webRecaptchaSiteKey: 'your-recaptcha-site-key', // For web
  //   androidProvider: AppCheckProvider.debug // Debug provider for Android
  // );


  runApp( MyApp());
}


class MyApp extends StatelessWidget {

  MyApp({super.key});

  // final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<String?> getSavedDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('department');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ExamController()),
          ChangeNotifierProvider(create: (_) => NoticeController()),
          ChangeNotifierProvider(create: (_) => TaskController()),
        ],
        child: GetMaterialApp(
          // theme: ThemeData(
          //
          //   // primaryColor: Colors.black,
          //   // brightness: Brightness.light,
          //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          //   useMaterial3: true,
          // ),
          debugShowCheckedModeBanner: false,
          // home: WelcomeScreen()
          home: FutureBuilder<String?>(
            future: getSavedDepartment(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return const NavigationBarApp();
              }
              return const WelcomeScreen();
            },
          ),

        ));
  }
}
