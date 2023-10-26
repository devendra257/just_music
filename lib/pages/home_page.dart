import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AudioPlayer player;
  Duration? totalDuration = Duration.zero;
  Duration? currentDuration = Duration.zero;
  Duration? bufferDuration = Duration.zero;

  bool isLoading = false;

  String audioUrl = 'https://infusevalue.com/public/music/song/17.mp3';

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    getSetMusic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Music'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProgressBar(
                    progress: currentDuration!,
                    total: totalDuration!,
                    baseBarColor: Colors.grey,
                    progressBarColor: Colors.red,
                    thumbColor: Colors.red,
                    thumbGlowColor: Colors.red.withOpacity(0.3),
                    bufferedBarColor: Colors.red.shade100,
                    buffered: bufferDuration,
                    onSeek: (value) {
                      player.seek(value);
                      setState(() {});
                    },
                  ),
                  InkWell(
                    onTap: () {
                      if (player.playing) {
                        player.pause();
                      } else {
                        player.play();
                      }

                      setState(() {});
                    },
                    child: player.playing
                        ? const Icon(
                            Icons.pause,
                            size: 30,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            size: 30,
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  void getSetMusic() async {
    try {
      totalDuration = await player.setUrl(audioUrl);

      player.playerStateStream.listen(
        (event) {
          if (event.processingState == ProcessingState.loading) {
            isLoading = true;
            setState(() {});
          } else if (event.processingState == ProcessingState.completed) {
            isLoading = false;
            setState(() {});
          }
        },
      );

      //CHeck position of all second
      player.positionStream.listen((event) {
        print(event.inSeconds);
        currentDuration = event;
        setState(() {});
      });

      //* this is work buffer stream
      player.bufferedPositionStream.listen((event) {
        bufferDuration = event;
        setState(() {});
      });

      player.play();
      setState(() {});
    } catch (e) {
      print("Error is $e");
    }
  }
}
