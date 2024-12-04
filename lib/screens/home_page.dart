import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:routine_management/controllers/exam_controller.dart';
import 'package:routine_management/ui/theme.dart';
import 'package:routine_management/ui/widget/button.dart';
import 'package:routine_management/ui/add_task_bar.dart';
import '../ui/task_tile.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TaskController _taskController;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskController = Provider.of<TaskController>(context, listen: false);
    _taskController.fetchTasks(); // Fetch tasks from Firebase
  }

  Future<void> _refreshTasks() async {
    _taskController.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0, vertical: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _marqueeText(),
            _addTaskBar(),
            _addDateBar(),
            _showTasks(),
          ],
        ),
      ),

    );
  }

  Widget _showTasks() {
    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Prevent ListView from scrolling
          itemCount: taskController.taskList.length,
          itemBuilder: (_, index) {
            if (taskController.taskList[index].date ==
                DateFormat.yMd().format(selectedDate)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Implement your onTap functionality here
                          },
                          child: TaskTile(taskController.taskList[index]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  Widget _marqueeText() {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      height: screenWidth * 0.05, // Adjust height based on screen width
      child: Marquee(
        text: '"উত্তরা ও আশেপাশের সকল স্কুল, কলেজ ,বিশ্ববিদ্যালয়ের ছাত্র ও সাধারণ জনতাকে  আগামীকাল ২৯.০৭.২০২৪ , সোমবার সকাল ১১ টায় উত্তরা BNS Center এ উপস্থিত হওয়ার অনুরোধ করা হচ্ছে।সময়: সকাল ১১.০০ টা "',
        style: TextStyle(
          fontSize: screenWidth * 0.04, // Adjust font size based on screen width
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        blankSpace: screenWidth * 0.1, // Adjust blank space based on screen width
        velocity: 60.0,
        startPadding: screenWidth * 0.02, // Adjust start padding based on screen width
        accelerationCurve: Curves.linear,
      ),
    );
  }

  TextStyle get responsiveTextStyle {
    double screenWidth = MediaQuery.of(context).size.width;
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: screenWidth * 0.05, // Adjust font size based on screen width
        fontWeight: FontWeight.w600,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _addDateBar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.115, // Adjust height based on screen size
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.015),
      child: DatePicker(
          DateTime.now(),
          height: MediaQuery.of(context).size.height * 0.1, // Adjust height based on screen size
          width: MediaQuery.of(context).size.width * 0.15,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryColor,
          selectedTextColor: Colors.white,
          dayTextStyle: responsiveTextStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.03),
          monthTextStyle: responsiveTextStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.04),
          dateTextStyle: responsiveTextStyle,
          onDateChange: (date) {
            setState(() {
              selectedDate = date;
            });
          },
        ),

    );
  }

  Widget _addTaskBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: MyButton(
              label: "+ Add Class",
              onTap: () async {
                await Get.to(() => const AddTaskPage());
                _refreshTasks();
              },
            ),
          ),
        ],
      ),
    );
  }
}
