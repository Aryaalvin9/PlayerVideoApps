import 'package:flutter/material.dart';
import 'package:flutter_play_apps/VideoPlayer.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoPlayerApp(VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4")),
    );
  }
}