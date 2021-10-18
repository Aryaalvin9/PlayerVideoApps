import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';
import 'helper/utils.dart';
import 'package:intl/intl.dart';

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

  late ChewieController _chewieController;

  late Future <void> _initialize;

  String durationTotal = "";
  String duration = "";
  bool isBufring = false;
  bool isMute = false;


  var _isShowingWidgetOutline = false;
  var _isFullWatch = false;

  @override
  void initState() {
     _controller = VideoPlayerController.network("https://api.dacast.com/v2/vod/1140446/download?apikey=137797_ae2ee525d4a1ab988984&_format=JSON");
     _initialize = _controller.initialize();
      _controller.addListener(() {
        setState(() {
          if(_controller.value.isBuffering){
            isBufring = true;
          }else{
            isBufring = false;
          }
        });
      });
     _controller.setLooping(true);
     _controller.setVolume(1.0);
     durationTotal = formatDuration(_controller.value.duration);
     duration = formatDuration(_controller.value.position);
     if(duration == durationTotal) {
        _isFullWatch = true;
     }
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
                  child: Stack(
                    children: <Widget>[
                      VideoPlayer(_controller),
                      Visibility(
                        child: Center(child: CircularProgressIndicator(),),
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: isBufring,
                      )
                    ],
                  )
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                ); 
              }
            },
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child:  IconButton(
                onPressed: (){
                  setState(() {
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
              Container(
                height: 35,
                child: Stack(
                children: <Widget>[
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child:Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(formatDuration(_controller.value.position), 
                                        style: TextStyle(
                                        fontSize: 12,),
                                    )
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("/",
                                   style: TextStyle(
                                   fontSize: 12,),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(formatDuration(_controller.value.duration),
                                        style: TextStyle(
                                        fontSize: 12,),
                                    )
                                   ),
                          )
                       
                      ],
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                    width: 200,
                    child: FutureBuilder(
                      future: _initialize,
                      builder: (context, isFullWatch){
                        checkVideo();
                        if(_isFullWatch){
                          return VideoProgressIndicator(_controller, allowScrubbing: _isFullWatch);
                        }else{
                          return VideoProgressIndicator(_controller, allowScrubbing: _isFullWatch);
                        }
                      },
                    ),
                    // 
                  ),
                  )
              ],
              ),
              ),
              Container(
                width: 20,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child:  Align(
                  alignment: Alignment.center,
                  child:  IconButton(
                    onPressed: (){
                      setState(() {
                        if(_controller.value.volume == 1){
                          isMute = true;
                          _controller.setVolume(0);
                        } else{
                          isMute = false;
                          _controller.setVolume(1);
                        }
                      });
                    }, 
                    icon: Icon(isMute ? Icons.volume_off : Icons.volume_up)
                  ),
                )
              ),
              Container(
                  width: 20,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child:  Align(
                    alignment: Alignment.center,
                    child:  IconButton(
                      onPressed: (){
                        setState(() {
                        });
                      }, 
                      icon: Icon(Icons.settings)
                    ),
                  )
              ),
              Container(
                width: 20,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child:  Align(
                  alignment: Alignment.center,
                  child:  IconButton(
                    onPressed: (){
                      setState(() {
                      });
                    }, 
                    icon: Icon(Icons.fullscreen)
                  ),
                )
              ),
            ],
          ),
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
    if(duration == durationTotal) {
      _isFullWatch == true;
    }
  }
}
