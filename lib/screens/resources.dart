import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart'; // For downloading files
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:routine_management/resources/pdf_view.dart';
import 'package:routine_management/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/image_viewer.dart';
import '../resources/video_player.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  String _currentPath = ''; // Track current folder path
  List<Map<String, dynamic>> _filesAndFolders = [];// Store files and folders

  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredFilesAndFolders = [];


  bool _isLoading = true;
  String departmentName = '';
  String semesterName = '';

  @override
  void initState() {
    super.initState();
    _loadDepartmentAndSemester(); // Load files and folders when screen initializes
  }

  @override
  void dispose() {
    // Cancel ongoing work or listeners
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDepartmentAndSemester() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDepartmentName = prefs.getString('department');
    String? savedSemesterName = prefs.getString('semester');

    if (savedDepartmentName != null && savedSemesterName != null) {
      setState(() {
        departmentName = savedDepartmentName;
        semesterName = savedSemesterName;
        _currentPath = 'resources/$departmentName/$semesterName/';
        debugPrint('Current path: $_currentPath');
      });

      // Initialize default folders after department and semester are set
      // await _initializeDefaultFolders();
      _loadFilesAndFolders(); // Load files and folders
    } else {
      // Handle the case where the department or semester is not set
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Department and Semester not set in preferences.')));
    }
  }

  Future<void> _initializeDefaultFolders() async {
    await _createFolder('Books');
    await _createFolder('Notes');
    await _createFolder('Questions');
  }

  Future<void> _loadFilesAndFolders() async {
    if (mounted) {
      try {
        // Get the list of files and folders at the current path
        final ListResult result =
            await FirebaseStorage.instance.ref(_currentPath).listAll();
        final List<Map<String, dynamic>> items = [];

        for (var prefix in result.prefixes) {
          items.add({'name': prefix.name, 'isFolder': true, 'ref': prefix});
        }

        for (var file in result.items) {
          final String url = await file.getDownloadURL();
          final String fileName = file.name;
          final String fileExtension = fileName.split('.').last.toLowerCase();

          final fullMetadata = await file.getMetadata();
          final fileSize = fullMetadata.size ?? 0; // In bytes

          // Determine file type based on extension
          bool isPdf = fileExtension == 'pdf';
          bool isImage = ['jpg', 'jpeg', 'png'].contains(fileExtension);
          bool isVideo = ['mp4', 'avi', 'mov'].contains(fileExtension);
          bool isDoc = ['doc', 'docx'].contains(fileExtension);
          bool isPpt = ['ppt', 'pptx'].contains(fileExtension);
          bool isExcel = ['xls', 'xlsx'].contains(fileExtension);
          bool isZip = fileExtension == 'zip';

          items.add({
            'name': fileName,
            'isFolder': false,
            'url': url,
            'size': fileSize,
            'isPdf': isPdf,
            'isImage': isImage,
            'isVideo': isVideo,
            'isDoc': isDoc,
            'isPpt': isPpt,
            'isExcel': isExcel,
            'isZip': isZip,
          });
        }

        setState(() {
          _filesAndFolders = items;
          _isLoading = false;
        });
      } catch (e) {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text('Failed to load items: $e')
        // )
    // );
      }
    }
  }

  Future<void> _pickAndUploadImagesVideos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
      allowMultiple: true,
    );

    if (result != null) {
      List<PlatformFile> selectedFiles = result.files;

      Get.snackbar("Uploaded", "Images/Videos uploaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: Icon(Icons.check_circle, color: Colors.white));

      for (var file in selectedFiles) {
        File fileToUpload = File(file.path!);
        String fileName = fileToUpload.path.split('/').last;
        await _uploadFile(fileToUpload, fileName); // Upload images/videos
      }

    }
  }

  Future<void> _pickAndUploadDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf', 'doc', 'docx', 'txt', // Existing document types
        'zip', 'xls', 'xlsx', 'ppt', 'pptx' // New file types
      ],
      allowMultiple: true,
    );

    if (result != null) {
      List<PlatformFile> selectedFiles = result.files;

      Get.snackbar("Uploaded", "File uploaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: Icon(Icons.check_circle, color: Colors.white));

      for (var file in selectedFiles) {
        File fileToUpload = File(file.path!);
        String fileName = fileToUpload.path.split('/').last;
        await _uploadFile(fileToUpload, fileName); // Upload documents
      }

    }
  }

  Future<void> _uploadFile(File file, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('$_currentPath/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);

      // Show upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        debugPrint('Upload is $progress% complete.');
      });

      await uploadTask;
      _loadFilesAndFolders(); // Reload the files and folders after upload
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload file: $e')),
      );
    }
  }


  Future<void> _createFolder(String folderName) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('$_currentPath/$folderName/');
      final ListResult folderList = await storageRef.listAll();

      if (folderList.items.isEmpty && folderList.prefixes.isEmpty) {
        // Folder does not exist, create it by adding a dummy file
        await storageRef.child('.dummy').putString('');
        debugPrint('Created folder: $folderName');
      } else {
        debugPrint('Folder already exists: $folderName');
      }
      // Create an empty file to simulate a folder
      // await storageRef.child('.dummy').putString('');
      _loadFilesAndFolders(); // Reload the files and folders after creating the folder
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to create folder: $e')));
    }
  }

  void _navigateToFolder(String folderName) {
    setState(() {
      _currentPath = '$_currentPath$folderName/';
      _loadFilesAndFolders();
    });
  }

  Future<void> _goBack() async {
    if (_currentPath != 'resources/$departmentName/$semesterName/') {
      final parts = _currentPath.split('/');
      parts.removeLast(); // Remove the trailing slash
      parts.removeLast(); // Remove the folder name
      setState(() {
        _currentPath = parts.join('/') + '/';
        _loadFilesAndFolders();
      });
    }
  }

  Future<void> _openOrDownloadFile(
      String url, bool isPdf, String fileName) async {
    if (isPdf) {
      debugPrint('Opening PDF: $url');
      // Open PDF in a viewer screen
      Get.to(() => PdfViewerScreen(pdfUrl: url, fileName: fileName));
    } else {
      final fileExtension = fileName.split('.').last.toLowerCase();

      if (fileExtension == 'jpg' ||
          fileExtension == 'jpeg' ||
          fileExtension == 'png') {
        // Handle image files
        await _downloadAndSaveFile(url, fileName);

        Get.to(() => ImageViewerScreen(imageUrl: url, fileName: fileName));
      } else if (fileExtension == 'mp4') {
        // Handle video files
        await _downloadAndSaveFile(url, fileName);

        Get.to(() => VideoPlayerScreen(videoUrl: url));
      } else if (fileExtension == 'doc' ||
          fileExtension == 'docx' ||
          fileExtension == 'ppt' ||
          fileExtension == 'pptx' ||
          fileExtension == 'xls' ||
          fileExtension == 'xlsx' ||
          fileExtension == 'zip') {
        // Handle document files
        await _downloadAndSaveFile(url, fileName);
        OpenFile.open('url.$fileExtension');
      } else {
        // Handle unknown file types
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File type not supported')),
        );
      }
    }
  }

  Future<void> _deleteFileOrFolder(String name, bool isFolder) async {
    try {
      if (isFolder) {
        // Delete all files and subfolders in the folder
        final folderRef = FirebaseStorage.instance.ref('$_currentPath/$name');
        final ListResult result = await folderRef.listAll();

        for (var file in result.items) {
          await file.delete();
        }

        for (var folder in result.prefixes) {
          await _deleteFileOrFolder(folder.name, true);
        }

        // Delete the folder itself
        await folderRef.delete();
      } else {
        // Delete a file
        final fileRef = FirebaseStorage.instance.ref('$_currentPath/$name');
        await fileRef.delete();
      }

      Get.snackbar(
        'Deleted',
        'Item deleted successfully',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: Icon(Icons.delete_forever_rounded,
            color: Colors.white,
        ),
      );

      _loadFilesAndFolders(); // Reload the files and folders after deleting
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete item: $e')));
    }
  }

  Future<void> _downloadAndSaveFile(String url, String fileName) async {
    try {
      Dio dio = Dio();
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      await dio.download(url, filePath);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Downloaded $fileName to $filePath')),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download file: $e')),
      );
    }
  }


  Future<void> _downloadSaveFile(String url, String fileName) async {
    try {
      Dio dio = Dio();
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Download the file to the app's document directory
      await dio.download(url, filePath);

      // Check file extension to determine if it's an image or video
      final fileExtension = fileName.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
        // Save image to the gallery
        bool? success = await GallerySaver.saveImage(filePath);
        if (success != null && success) {
          debugPrint('Image saved to gallery');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image saved to gallery: $fileName')),
          );
        } else {
          debugPrint('Failed to save image to gallery');
        }
      } else if (['mp4', 'mov'].contains(fileExtension)) {
        // Save video to the gallery
        bool? success = await GallerySaver.saveVideo(filePath);
        if (success != null && success) {
          debugPrint('Video saved to gallery');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Video saved to gallery: $fileName')),
          );
        } else {
          debugPrint('Failed to save video to gallery');
        }
      } else {
        // Handle non-media files (PDF, docx, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded $fileName to $filePath')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download file: $e')),
      );
    }
  }

  void _filterFilesAndFolders(String query) {
    setState(() {
      _filteredFilesAndFolders = _filesAndFolders
          .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


  void _sortFilesByName() {
    setState(() {
      _filesAndFolders.sort((a, b) => a['name'].compareTo(b['name']));
    });
  }


  Widget _buildContent() {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      // Show loading indicator while fetching files
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_filesAndFolders.isEmpty) {
      // Show no files message if the list is empty
      return Center(
        child: Text('No files or folders yet.',
            style: TextStyle(fontSize: screenWidth * 0.05)
        ),
      );
      }

    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
        //   child: TextField(
        //     controller: _searchController,
        //     decoration: InputDecoration(
        //       hintText: 'Search files and folders',
        //       suffixIcon: Icon(Icons.search, size: screenWidth * 0.06), // Responsive icon size
        //       contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        //     ),
        //     onChanged: _filterFilesAndFolders,
        //   ),
        // ),
        Expanded(
          child: ListView.builder(
                  itemCount: _filesAndFolders.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _filesAndFolders.length) {
                      // Bottom padding widget
                      return SizedBox(height: screenHeight * 0.1); // Adjust this height as needed
                    }
                    final item = _filesAndFolders[index];
                    return ListTile(
                      title: Text(item['name'],
                          style: TextStyle(
                            fontSize: screenWidth * 0.045, // Responsive font size
                            fontWeight: FontWeight.w500,
                          )
                      ),
                      leading: item['isFolder'] == true
                          ? const FaIcon(FontAwesomeIcons.solidFolder,
                              color: Color.fromARGB(255, 248, 215, 117))
                          : FaIcon(
                              item['isPdf'] == true
                                  ? FontAwesomeIcons.solidFilePdf
                                  : item['isImage'] == true
                                      ? FontAwesomeIcons.solidImage
                                      : item['isVideo'] == true
                                          ? FontAwesomeIcons.film
                                          : item['isDoc'] == true
                                              ? FontAwesomeIcons.fileWord
                                              : item['isPpt'] == true
                                                  ? Icons.slideshow
                                                  : item['isExcel'] == true
                                                      ? Icons.table_chart
                                                      : item['isZip'] == true
                                                          ? FontAwesomeIcons
                                                              .solidFileZipper
                                                          : Icons
                                                              .file_copy, // Default icon for unknown files
                              color: item['isPdf'] == true
                                  ? Colors.red
                                  : item['isImage'] == true
                                      ? Colors.green
                                      : item['isVideo'] == true
                                          ? Colors.red
                                          : item['isDoc'] == true
                                              ? Colors.blue
                                              : item['isPpt'] == true
                                                  ? Colors.purple
                                                  : item['isExcel'] == true
                                                      ? Colors.teal
                                                      : item['isZip'] == true
                                                          ? Colors.brown
                                                          : Colors
                                                              .grey, // Default color for unknown files
                            ),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_rounded,  size: screenWidth * 0.06),
                        onSelected: (value) {
                          switch (value) {
                            case 'delete':
                              _deleteFileOrFolder(
                                  item['name'], item['isFolder']);
                              break;
                            case 'download':
                              _downloadSaveFile(item['url'], item['name']);
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'download',
                            child: Text('Download', style: TextStyle(fontSize: screenWidth * 0.04)),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete', style: TextStyle(fontSize: screenWidth * 0.04)),
                          ),
                        ],
                      ),
                      onTap: item['isFolder']
                          ? () => _navigateToFolder(item['name'])
                          : () => _openOrDownloadFile(
                                item['url'],
                                item['isPdf'],
                                item['name'],
                              ),
                    );
                  },
                ),
        ),
      ],
    );

  }

  void _showCreateFolderDialog() {
    final TextEditingController folderController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Create Folder'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: folderController,
                decoration: const InputDecoration(hintText: 'Folder Name'),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Create'),
                onPressed: () {
                  _createFolder(folderController.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: Text('Resources', style: subHeadingStyle),
          leading: _currentPath != 'resources/$departmentName/$semesterName/'
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: _goBack,
                )
              : null,
          backgroundColor: Colors.white,
        ),
      ),
      body: _buildContent(),
      floatingActionButton: SizedBox(
        height: screenHeight * 0.06, // Responsive height
        width: screenWidth * 0.23,
        child: FloatingActionButton(
          onPressed: () {
            _showBottomSheet(context);
          },
          backgroundColor: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add,size: screenWidth * 0.06, color: Colors.white),
                SizedBox(width: screenWidth * 0.02),
                Text('Add', style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.create_new_folder),
                title: const Text('Create Folder'),
                onTap: () {
                  Navigator.pop(context);
                  _showCreateFolderDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_upload),
                title: const Text('Upload File'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUploadDocuments();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Upload Images/Videos'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndUploadImagesVideos(); // Handle image/video uploads
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

