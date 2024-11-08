import 'package:example/data/dto/model/feature_model.dart';
import 'package:example/data/enum/preview_type.dart';
import 'package:example/presentation/preview_id_card_page_v2.dart';
import 'package:example/presentation/preview_image_page.dart';
import 'package:example/presentation/preview_selfie_page_v2.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

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
      title: 'Selfie Camera V2',
      desc: 'Selfie Camera V2',
      key: 'SELFIE_CAMERA_V2',
    ),
    FeatureModel(
      title: 'ID Card Camera_V2',
      desc: 'ID Card Camera_V2',
      key: 'ID_CARD_CAMERA_V2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Example')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: features.length,
        itemBuilder: (_, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: () async {
              switch (feature.key) {
                case "CAPTURE_IMAGE":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PreviewImagePage(previewType: PreviewType.capture)));
                  break;
                case "STREAM_IMAGE":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PreviewImagePage(previewType: PreviewType.stream)));
                  break;
                case "SELFIE_CAMERA_V2":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PreviewSelfiePageV2()));
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
