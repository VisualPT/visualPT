import 'package:flutter/material.dart';
import 'package:visualpt/UI/video_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Video Recorder App',
      home: VideoPage(),
    );
  }
}
