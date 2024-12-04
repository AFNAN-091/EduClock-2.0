import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:routine_management/controllers/exam_controller.dart';
import 'package:routine_management/ui/theme.dart';
import '../ui/notice_bar.dart';
import '../ui/notice_form.dart';
import 'detailed_notice_screen.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  late NoticeController _noticeController;

  @override
  void initState() {
    super.initState();
    _noticeController = Provider.of<NoticeController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _noticeController.fetchNotices();
    });
  }

  Future<void> _refreshNotices() async {
    _noticeController = Provider.of<NoticeController>(context, listen: false);
    await _noticeController.fetchNotices();
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.08),
        child: AppBar(
          title: Text(
            'Notices',
            style: subHeadingStyle.copyWith(
              fontSize: screenWidth * 0.05,
            ),
          ),
          backgroundColor: Colors.white,
        ),
      ),
      body: Consumer<NoticeController>(
        builder: (context, noticeController, _) {
          if (noticeController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (noticeController.noticeList.isEmpty) {
            return Center(
              child: Text('No available notices at the moment.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.red,
                  ),
              textAlign: TextAlign.center,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshNotices,
            child: _showNotice(noticeController),
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: screenHeight * 0.05, // Responsive FloatingActionButton height
        width: screenWidth * 0.23,
        child: FloatingActionButton(
          onPressed: () async {
            await Get.to(() => const NoticeFormScreen());
            _refreshNotices();
          },
          backgroundColor: primaryColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01, horizontal: screenWidth * 0.01),
            child: Row(
              children: [
                Icon(Icons.add, size: screenWidth * 0.06, color: Colors.white),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'New',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showNotice(NoticeController noticeController) {
    noticeController.noticeList.sort((a, b) {
      DateTime dateA = DateTime.parse(a.date!);
      DateTime dateB = DateTime.parse(b.date!);
      return dateB.compareTo(dateA);
    });

    return ListView.builder(
      itemCount: noticeController.noticeList.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 1000),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: GestureDetector(
                onTap: () {
                  Get.to(() => DetailedNoticeScreen(
                    notice: noticeController.noticeList[index],
                  ));
                },
                child: NoticeBar(
                  notice: noticeController.noticeList[index],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
