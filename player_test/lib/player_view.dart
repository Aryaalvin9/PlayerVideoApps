import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';

class VideoPlayerBuild extends StatelessWidget {
  VideoPlayerBuild({Key? key}) : super(key: key);

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeVariation>(
      valueListenable: themeNotifier, 
      builder: (context, value, child){
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: value.color, brightness: value.brightness
          ),
          home: VideoPlayerView(),
        );
      }
    );
  }
}

var themeNotifier = ValueNotifier<ThemeVariation>(
  const ThemeVariation(Colors.blue, Brightness.light),
);

class ThemeVariation{
  const ThemeVariation(this.color, this.brightness);
  final MaterialColor color;
  final Brightness brightness;
}

class VideoPlayerView extends StatefulWidget {
  VideoPlayerView({Key? key}) : super(key: key);

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  
  late VideoPlayerController _controller;

  late Future <void> _initialize;

  var _isShowingWidgetOutline = false;
  var _isFullWatch = false;

  @override
  void initState() {
     _controller = VideoPlayerController.network("https://api.dacast.com/v2/vod/1140446/download?apikey=137797_ae2ee525d4a1ab988984&_format=JSON");
     _initialize = _controller.initialize();
     _controller.setLooping(false);
     _controller.setVolume(1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget> [
          FutureBuilder(
            future: _initialize,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                ); 
              }
            },
          ),
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child:  IconButton(
                    onPressed: (){
                      setState(() {
                        checkVideo();
                        if(_controller.value.isPlaying){
                          _controller.pause();
                        } else{
                          _controller.play();
                        }
                      });
                    }, 
                    icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow_sharp)
                  ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("00:00"),)
                      ],
                    )
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                        children: <Widget>[
                          SizedBox(height: 25,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("00:00"),)
                        ],
                    )
                  )
                ]
              ),
              VideoProgressIndicator(_controller, allowScrubbing: _isFullWatch),
            ],
          )
        ]
      ),
    );
  }

  BoxDecoration _widgetBorder() {
    return BoxDecoration(
      border: _isShowingWidgetOutline
          ? Border.all(color: Colors.red)
          : Border.all(color: Colors.transparent),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkVideo(){
    if(_controller.value.position == _controller.value.duration) {
      _isFullWatch = true;
      _controller.pause();
    }
  }
}