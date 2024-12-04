import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/notice_model.dart';

class DetailedNoticeScreen extends StatefulWidget {
  final Notice notice;
  DetailedNoticeScreen({super.key, required this.notice});

  @override
  _DetailedNoticeScreenState createState() => _DetailedNoticeScreenState();

}

class _DetailedNoticeScreenState extends State<DetailedNoticeScreen> {
  late PhotoViewController controller;
  double scaleCopy = 0;

  @override
  void initState() {
    super.initState();
    controller = PhotoViewController()
      ..outputStateStream.listen(listener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener(PhotoViewControllerValue value) {
    setState(() {
      scaleCopy = value.scale!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        elevation: 0.5,
        title: const Text(
          "Detailed Notice",
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const FaIcon(FontAwesomeIcons.angleLeft)
          
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(widget.notice.title ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12,),
              widget.notice.imageUrl!.isEmpty ? Container() : Container(
                height: 250,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: PhotoView(
                        imageProvider: CachedNetworkImageProvider(widget.notice.imageUrl!),
                        controller: controller,
                        loadingBuilder: (context, event) => Center(
                          child: event == null
                              ? const CircularProgressIndicator()
                              : CircularProgressIndicator(value: event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1)),
                        ),
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.error, size: 50, color: Colors.red),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 5,),
                  Text(
                    widget.notice.date?.substring(0,10) ?? "",
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              widget.notice.description!.isNotEmpty ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Notice:",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SelectableText(widget.notice.description!,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
