import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerBuild extends StatelessWidget {
  VideoPlayerBuild({Key? key}) : super(key: key);

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Align(
        alignment: Alignment.center,
        child: VideoPlayerView(),
      ),
    );
  }
}

class VideoPlayerView extends StatefulWidget {
  VideoPlayerView({Key? key}) : super(key: key);

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network("https://api.dacast.com/v2/vod/1140446/download?apikey=137797_ae2ee525d4a1ab988984&_format=JSON");
    _controller
      ..setLooping(true)
      ..initialize()
      ..setVolume(1.0)
      ..addListener(() {
        setState(() {
          _controller.play();
        });
      });

  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          ),
        child: AspectRatio(
          aspectRatio: 16/9,
          child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : Container(
            color: Colors.black,
          ),
          ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void checkVideo(){
    if(_controller.value.position == Duration(seconds: 0, minutes: 0, hours: 0)){
      print('video Started');
    }
    if(_controller.value.position == _controller.value.duration) {
      print('video Ended');
    }
  }
}


// class VideoPlayerView extends StatefulWidget {
//   const VideoPlayerView{Key? key}) : super(key: key);

//   final String title = "Video Player";

//   @override
//   _VideoPlayerState createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<VideoPlayer> {

// late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network('dataSource');
    
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: _controller.value.isInitialized
//       ? AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: VideoPlayer(_controller),
//           )
//       : Container(),
//       )
//     );
//   }
// }