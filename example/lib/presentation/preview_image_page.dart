import 'dart:convert';

import 'package:example/data/enum/preview_type.dart';
import 'package:example/presentation/capture_image_page.dart';
import 'package:example/presentation/stream_camera_page.dart';
import 'package:flutter/material.dart';

class PreviewImagePage extends StatefulWidget {
  final PreviewType previewType;
  const PreviewImagePage({
    super.key,
    required this.previewType,
  });

  @override
  State<PreviewImagePage> createState() => _PreviewImagePageState();
}

class _PreviewImagePageState extends State<PreviewImagePage> {
  String? base64Image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_){
        if(widget.previewType == PreviewType.stream){
          return const StreamCameraPage();
        }else{
          return const CaptureImagePage();
        }
      })).then((value) {
        if (value is String) {
          if (context.mounted) {
            setState(() {
              base64Image = value;
            });
          }
        } else {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Preview Image", style: TextStyle(color: Colors.black)),
      ),
      body: bodyLayout(),
    );
  }

  Widget bodyLayout() {
    return base64Image != null
        ? Stack(
            children: [
              Image.memory(base64.decode(base64Image ?? ''), fit: BoxFit.cover),
            ],
          )
        : const SizedBox.shrink();
  }
}
