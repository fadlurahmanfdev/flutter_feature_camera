import 'dart:convert';

import 'package:example/presentation/camera_selfie_page_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';

class PreviewSelfiePageV2 extends StatefulWidget {
  const PreviewSelfiePageV2({super.key});

  @override
  State<PreviewSelfiePageV2> createState() => _PreviewSelfiePageV2State();
}

class _PreviewSelfiePageV2State extends State<PreviewSelfiePageV2> {
  String? base64Image;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CameraSelfiePageV2())).then((value) {
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
        title: const Text("Preview Selfie", style: TextStyle(color: Colors.black)),
      ),
      body: bodyLayout(),
    );
  }

  Widget bodyLayout() {
    return base64Image != null
        ? Stack(
            children: [
              Image.memory(base64.decode(base64Image ?? ''), fit: BoxFit.cover),
              IgnorePointer(
                child: CustomPaint(
                  painter: CirclePainterV2(),
                  child: Container(),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
