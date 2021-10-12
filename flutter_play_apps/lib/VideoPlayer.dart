import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerApp extends StatefulWidget{
  VideoPlayerApp(VideoPlayerController playercontroller) : super();

  final String title = "Video Player";

  @override
  VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer>{
  
  late VideoPlayerController _playercontroller;
  late Future<void> _VideoPlayerFuture;

  @override
  void initState() {

    _playercontroller = VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
    _playercontroller.addListener(checkVideo);
    _VideoPlayerFuture = _playercontroller.initialize();
    _playercontroller.setLooping(true);
    _playercontroller.setVolume(1.0);
    super.initState();
    
  }

  @override
  void dispose() {
    _playercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Demo"),
      ),
      body: FutureBuilder(
        future: _VideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: AspectRatio(
                aspectRatio: _playercontroller.value.aspectRatio,
                child: VideoPlayer(_playercontroller),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_playercontroller.value.isPlaying) {
              _playercontroller.pause();
            } else {
              _playercontroller.play();
            }
          });
        },
        child:
            Icon(_playercontroller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  void checkVideo(){
    if(_playercontroller.value.position == Duration(seconds: 0, minutes: 0, hours: 0)){
      print('video Started');
    }
    if(_playercontroller.value.position == _playercontroller.value.duration) {
      print('video Ended');
    }
  }
}