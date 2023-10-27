import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class SaavanPage extends StatefulWidget {
  const SaavanPage({super.key});

  @override
  State<SaavanPage> createState() => _SaavanPageState();
}

class _SaavanPageState extends State<SaavanPage> {
  late AudioPlayer player;
  Duration? totalDuration = Duration.zero;
  Duration? currentDuration = Duration.zero;
  Duration? bufferDuration = Duration.zero;

  bool isLoading = false;
  bool isLoop = false;
  bool isShuffle = false;

  final _playList = ConcatenatingAudioSource(children: [
    AudioSource.uri(
      Uri.parse('https://jio-saavan-unofficial.p.rapidapi.com/getsong'),
      headers: {
        'content-type': 'application/json',
        'X-RapidAPI-Key': '5540573682msh745a8da3017a2e1p10998fjsn1a730dc4f846',
        'X-RapidAPI-Host': 'jio-saavan-unofficial.p.rapidapi.com'
      },
      tag: MediaItem(
        id: '0',
        title: 'song1',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1695064823570-3a72b0a7daf6?auto=format&fit=crop&q=80&w=3203&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
  ]);

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
                  StreamBuilder(
                    stream: player.sequenceStateStream,
                    builder: (_, snapshot) {
                      var state = snapshot.data;

                      if (state!.sequence.isNotEmpty) {
                        var metadata = state.currentSource!.tag;
                        return Column(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 4),
                                    blurRadius: 4,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: "${metadata.artUri}",
                                  fit: BoxFit.cover,
                                  width: 300,
                                  height: 300,
                                ),
                              ),
                            ),
                            Text(
                              metadata.title != '' ? metadata.title : '',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      } else if (state.sequence.isEmpty) {
                        return const CircularProgressIndicator();
                      }
                      return Container();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProgressBar(
                      progress: currentDuration!,
                      total: player.duration ?? totalDuration!,
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (isLoop = !isLoop) {
                            player.setLoopMode(LoopMode.all);
                          } else {
                            player.setLoopMode(LoopMode.off);
                          }
                          setState(() {});
                        },
                        child: Icon(
                          Icons.loop,
                          color: isLoop ? Colors.red : Colors.black,
                          size: 35,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.seekToPrevious();
                        },
                        child: const Icon(
                          Icons.skip_previous,
                          size: 40,
                        ),
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
                        child: currentDuration!.inSeconds == 0
                            ? CircularProgressIndicator()
                            : player.playing
                                ? const Icon(
                                    Icons.pause,
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    size: 40,
                                  ),
                      ),
                      InkWell(
                        onTap: () async {
                          await player.seekToNext();
                        },
                        child: const Icon(
                          Icons.skip_next,
                          size: 40,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await player
                              .setShuffleModeEnabled(isShuffle = !isShuffle);
                          setState(() {});
                        },
                        child: Icon(
                          Icons.shuffle,
                          color: isShuffle ? Colors.red : Colors.black,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  void getSetMusic() async {
    try {
      totalDuration = await player.setAudioSource(
        _playList,
        initialIndex: 0,
      );

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
