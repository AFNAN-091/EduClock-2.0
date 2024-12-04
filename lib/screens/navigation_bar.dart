import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:routine_management/screens/exam_screen.dart';
import 'package:routine_management/screens/home_page.dart';
import 'package:routine_management/screens/login_screen.dart';
import 'package:routine_management/screens/notice_screen.dart';
import 'package:routine_management/screens/resources.dart';
import 'package:routine_management/screens/table_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.white, // Set NavigationBar background color
          indicatorColor: Color.fromARGB(255, 255, 198, 115),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  late FirebaseMessaging messaging;
  int currentPageIndex = 0;
  late String dept = "";
  late String semester = "";

  @override
  void initState() {
    super.initState();
    getSavedDepartment();
    messaging = FirebaseMessaging.instance;

    // Request notification permissions
    messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Subscribe to topics
    subscribeToTopics();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Access the message title and body
        final title = message.notification?.title ?? 'Notification';
        final body = message.notification?.body ?? 'You have a new notification';

        // Show Snackbar
        Get.snackbar(title, body,
          backgroundColor: Colors.grey[800],
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.check_circle,
            color: Colors.green,
          ),
        );
      }
    });


    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  }

  Future<void> subscribeToTopics() async {
    final prefs = await SharedPreferences.getInstance();
    String? department = prefs.getString('department');
    String? semester = prefs.getString('semester');

    if (department != null && semester != null) {
      try {
        await messaging.subscribeToTopic(department);
        // await messaging.subscribeToTopic('semester_$semester');
        print("Subscribed to topics department_$department");
      } catch (e) {
        print("Error subscribing to topics: $e");
      }
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  Future<void> getSavedDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dept = prefs.getString("department") ?? "";
      semester = prefs.getString("semester") ?? "";
    });
    print("Department: $dept");
    print("Semester: $semester");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.08;
    double iconSize = screenWidth * 0.07;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: appBarHeight,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(iconSize / 2),
              child: dept.isNotEmpty ? Image.asset(
                'assets/images/${dept.toLowerCase()}.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ) : const Icon(Icons.image_not_supported, size: 40),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(dept.isNotEmpty ? dept.toUpperCase() : "Department",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          child: Icon(Icons.arrow_drop_down, size: screenWidth * 0.08),
                          onTap: () {
                            Get.to(() => const LoginScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                  Text(semester.isNotEmpty ? semester : "Semester",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(()=> TableScreen());                  // Navigator.pushNamed(context, '/result');
                },
                child: Padding(padding: EdgeInsets.only(right: screenWidth * 0.02),
                  child: Image.asset('assets/images/result.png',
                    height: screenHeight * 0.03,
                    width: screenWidth * 0.07,
                  )
                ),
              ),
              IconButton(
                icon: Icon(Icons.shield_moon_outlined,
                  color: Colors.black,
                    size: screenWidth * 0.07
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.white,
        height: screenHeight * 0.09,
        elevation: 0.5,
        indicatorColor: const Color.fromARGB(255, 255, 198, 115),
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.schedule, size: iconSize),
            icon: Icon(Icons.schedule_outlined, size: iconSize),
            label: 'Routine',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.assignment, size: iconSize),
            icon: Icon(Icons.assignment_outlined, size: iconSize),
            label: 'Exams',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications, size: iconSize),
            icon: Icon(Icons.notifications_none_outlined, size: iconSize),
            label: 'Notices',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.book, size: iconSize),
            icon: Icon(Icons.book_outlined, size: iconSize),
            label: 'Resources',
          ),
        ],
      ),
      body: <Widget>[
        const HomePage(), // Routine Screen
        ExamScreen(), // Exam Screen
        const NoticeScreen(), // Notice Screen
        const ResourcesScreen(), // Resources Screen
      ][currentPageIndex],
    );
  }
}
