import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const customSwatch = MaterialColor(
    0xFFFF5252,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFFF5252),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIDEO PLAYER',
      theme: ThemeData(
        primarySwatch: customSwatch,
      ),
      debugShowCheckedModeBanner: false,
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late List<VideoPlayerController> videoPlayerControllers;
  List<ChewieController?> chewieControllers = [];

  @override
  void initState() {
    super.initState();
    _initPlayers();
  }

  void _initPlayers() async {
    List<String> videoUrls = [
      'https://www.youtube.com/watch?v=mqL5SG49TWc',
      'https://www.youtube.com/watch?v=Tjsshi8l-fM'
    ];

    videoPlayerControllers =
        videoUrls.map((url) => VideoPlayerController.network(url)).toList();

    chewieControllers = videoPlayerControllers
        .map((controller) => ChewieController(
              videoPlayerController: controller,
              autoPlay: true,
              looping: true,
              additionalOptions: (context) {
                return <OptionItem>[
                  OptionItem(
                    onTap: () => debugPrint('Option 1 pressed!'),
                    iconData: Icons.chat,
                    title: 'Option 1',
                  ),
                  OptionItem(
                    onTap: () => debugPrint('Option 2 pressed!'),
                    iconData: Icons.share,
                    title: 'Option 2',
                  ),
                ];
              },
            ))
        .toList();

    await Future.wait(
        videoPlayerControllers.map((controller) => controller.initialize()));
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in videoPlayerControllers) {
      controller.dispose();
    }
    for (var chewieController in chewieControllers) {
      chewieController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
      ),
      body: videoPlayerControllers.isNotEmpty
          ? ListView.builder(
              itemCount: videoPlayerControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Chewie(
                    controller: chewieControllers[index]!,
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
