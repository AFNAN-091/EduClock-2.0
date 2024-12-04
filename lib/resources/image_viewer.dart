import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageViewerScreen extends StatefulWidget {
  final String imageUrl;// Changed from `imagePath` to `imageUrl` for clarity
  final String fileName;
  ImageViewerScreen({required this.imageUrl, required this.fileName});

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
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
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(widget.imageUrl), // Use NetworkImage
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
        ),


      ],
    );
  }
}
