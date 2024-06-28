import 'package:example/data/dto/model/feature_model.dart';
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
                  break;
                case "STREAM_IMAGE":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StreamCameraPage()));
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
