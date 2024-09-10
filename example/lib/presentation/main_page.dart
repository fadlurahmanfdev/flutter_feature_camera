import 'package:example/data/dto/model/feature_model.dart';
import 'package:example/presentation/camera_id_card_page.dart';
import 'package:example/presentation/camera_selfie_page.dart';
import 'package:example/presentation/capture_image_page.dart';
import 'package:example/presentation/preview_id_card_page_v2.dart';
import 'package:example/presentation/preview_selfie_page.dart';
import 'package:example/presentation/preview_selfie_page_v2.dart';
import 'package:example/presentation/stream_camera_page.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<FeatureModel> features = [
    FeatureModel(
      title: 'Capture Image',
      desc: 'Capture Image',
      key: 'CAPTURE_IMAGE',
    ),
    FeatureModel(
      title: 'Stream Image',
      desc: 'Stream Image',
      key: 'STREAM_IMAGE',
    ),
    FeatureModel(
      title: 'Selfie Camera',
      desc: 'Selfie Camera',
      key: 'SELFIE_CAMERA',
    ),
    FeatureModel(
      title: 'Selfie Camera V2',
      desc: 'Selfie Camera V2',
      key: 'SELFIE_CAMERA_V2',
    ),
    FeatureModel(
      title: 'ID Card Camera',
      desc: 'ID Card Camera',
      key: 'ID_CARD_CAMERA',
    ),
    FeatureModel(
      title: 'ID Card Camera_V2',
      desc: 'ID Card Camera_V2',
      key: 'ID_CARD_CAMERA_V2',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: features.length,
        itemBuilder: (_, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: () async {
              switch (feature.key) {
                case "CAPTURE_IMAGE":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CaptureImagePage()));
                  break;
                case "STREAM_IMAGE":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StreamCameraPage()));
                  break;
                case "SELFIE_CAMERA":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PreviewSelfiePage()));
                  break;
                case "SELFIE_CAMERA_V2":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PreviewSelfiePageV2()));
                  break;
                case "ID_CARD_CAMERA":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CameraIdCardPage()));
                  break;
                case "ID_CARD_CAMERA_V2":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PreviewIdCardPage2()));
                  break;
              }
            },
            child: ItemFeatureWidget(feature: feature),
          );
        },
      ),
    );
  }
}
