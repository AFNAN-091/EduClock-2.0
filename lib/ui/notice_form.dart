import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:routine_management/ui/widget/button.dart';
import 'package:routine_management/ui/widget/input_field.dart';
import 'package:routine_management/ui/widget/notice_input.dart';

import '../db/data_base_helper.dart';
import '../models/notice_model.dart';

class NoticeFormScreen extends StatefulWidget {
  const NoticeFormScreen({super.key});
  @override
  State<NoticeFormScreen> createState() => _NoticeFormScreenState();
}

class _NoticeFormScreenState extends State<NoticeFormScreen> {

  final FirebaseService _firebaseService = FirebaseService();


  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  File? _noticeImage;
  File? _pdfFile;


  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _noticeImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text  = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }


  bool _isLoading = false;

  Future<void> _uploadNotice() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Upload logic
      int color = getRandomInt(0, 5);

      // Upload image to Firebase Storage
      String imageUrl = '';
      if (_noticeImage != null) {
        final storageRef = FirebaseStorage.instance.ref().child('notice_images/${DateTime.now().millisecondsSinceEpoch}');
        await storageRef.putFile(_noticeImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Create notice data
      Notice notice = Notice(
        title: _titleController.text,
        description: _detailsController.text,
        date: _selectedDate.toString(),
        imageUrl: imageUrl,
        type: "notice",
        color: color,
      );

      await _firebaseService.addNotice(notice);
      Get.back();
    } catch (e) {
      // Handle errors
      Get.snackbar("Error", "Failed to upload notice: $e",
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildImageWidget() {
    if (_noticeImage == null) {
      return GestureDetector(
        onTap: _pickImage,
        child: const Row(
          children: [
            Icon(
              Icons.photo_library_rounded,
              color: Colors.green,
              size: 25,
            ),
            SizedBox(width: 5),
            Text(
              'Photos/Videos',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.file(
                    _noticeImage!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _noticeImage = null;
                      });
                    },
                    child: Container(

                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,

                      ),
                      child: const Icon(Icons.delete_forever_outlined, color: Colors.white),

                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Row(
              children: [
                Icon(
                  Icons.photo_library_rounded,
                  color: Colors.green,
                  size: 25,
                ),
                SizedBox(width: 5),
                Text(
                  'Photos/Videos',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  Widget _buildPDFWidget() {
    if (_pdfFile == null) {
      return GestureDetector(
        onTap: _pickPDF,
        child: const Row(
          children: [
            Icon(
              Icons.picture_as_pdf,
              color: Colors.red,
              size: 25,
            ),
            SizedBox(width: 5),
            Text(
              'Upload PDF',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Stack(
            children: [
              Container(
                width: 150,
                height: 150,
                color: Colors.red.withOpacity(0.1),
                child: const Center(
                  child: Icon(
                    Icons.picture_as_pdf,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _pdfFile = null;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Row(
            children: [
              Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
                size: 25,
              ),
              SizedBox(width: 5),
              Text(
                'Upload PDF',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      );
    }
  }




  @override
  Widget build(BuildContext context) {

    double containerWidth = MediaQuery.of(context).size.width * 0.4;
    double containerHeight = containerWidth * (3 / 4); // 4:3 aspect ratio


    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Form',
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),

        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 20,
            color: Colors.blueGrey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildImageWidget(),
              const SizedBox(height: 8),
              _buildPDFWidget(),
              NoticeInput(title: "Title", hint: "Enter Title", isRequired: true, isDescription: false, controller: _titleController),
              const SizedBox(height: 8.0),
              MyInputField(
                  title: "Date",
                  hint: "27-06-2024",
                  controller: _dateController,
                  isRequired: true,
                  isDescription: false,
                  widget: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined,
                        color: Colors.grey),
                    onPressed: () {
                      _selectDate(context);
                    },
                  )),
              const SizedBox(height: 8.0),
              NoticeInput(title: "Details", hint: "Enter Details", isRequired: false, isDescription: true, controller: _detailsController),
              const SizedBox(height: 32.0),

              // const SizedBox(height: 16.0),
              MyButton(label: "POST NOTICE",
                  onTap: (){
                    _validData();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min);
  }



  _validData() {
    if (_titleController.text.isEmpty) {
      Get.snackbar("Required", "Course Title is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
    else if(_dateController.text.isEmpty){
      Get.snackbar("Required", "Date is required",
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
    else{
      _uploadNotice();
    }
  }

}