import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class PlayList extends StatefulWidget {
  const PlayList({super.key});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  late AudioPlayer player;
  Duration? totalDuration = Duration.zero;
  Duration? currentDuration = Duration.zero;
  Duration? bufferDuration = Duration.zero;

  bool isLoading = false;
  bool isLoop = false;
  bool isShuffle = false;

  final _playList = ConcatenatingAudioSource(children: [
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/17.mp3'),
      tag: MediaItem(
        id: '0',
        title: 'song1',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1695064823570-3a72b0a7daf6?auto=format&fit=crop&q=80&w=3203&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/2.mp3'),
      tag: MediaItem(
        id: '1',
        title: 'song2',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1682695796497-31a44224d6d6?auto=format&fit=crop&q=60&w=900&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxMXx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/3.mp3'),
      tag: MediaItem(
        id: '2',
        title: 'song3',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1682685795463-0674c065f315?auto=format&fit=crop&q=80&w=3426&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/4.mp3'),
      tag: MediaItem(
        id: '3',
        title: 'song4',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1696793011067-5ecdb0d1c936?auto=format&fit=crop&q=60&w=900&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyM3x8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/5.mp3'),
      tag: MediaItem(
        id: '4',
        title: 'song5',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1696793234753-69edbade524e?auto=format&fit=crop&q=80&w=3387&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/6.mp3'),
      tag: MediaItem(
        id: '5',
        title: 'song6',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1696861072510-58ff60b10bee?auto=format&fit=crop&q=80&w=2000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/7.mp3'),
      tag: MediaItem(
        id: '6',
        title: 'song7',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1682685794690-dea7c8847a50?auto=format&fit=crop&q=80&w=3542&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/8.mp3'),
      tag: MediaItem(
        id: '7',
        title: 'song8',
        artUri: Uri.parse(
            'https://plus.unsplash.com/premium_photo-1686685571557-9af36440276c?auto=format&fit=crop&q=80&w=3368&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/9.mp3'),
      tag: MediaItem(
        id: '8',
        title: 'song9',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1697452527087-61ab9007802b?auto=format&fit=crop&q=80&w=3435&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/10.mp3'),
      tag: MediaItem(
        id: '9',
        title: 'song10',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1682687220509-61b8a906ca19?auto=format&fit=crop&q=80&w=3540&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/11.mp3'),
      tag: MediaItem(
        id: '10',
        title: 'song11',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1698216885906-bcc92f91596a?auto=format&fit=crop&q=80&w=3387&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/12.mp3'),
      tag: MediaItem(
        id: '11',
        title: 'song12',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1695064823570-3a72b0a7daf6?auto=format&fit=crop&q=80&w=3203&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/13.mp3'),
      tag: MediaItem(
        id: '12',
        title: 'song13',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1695064823570-3a72b0a7daf6?auto=format&fit=crop&q=80&w=3203&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/14.mp3'),
      tag: MediaItem(
        id: '13',
        title: 'song14',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1695064823570-3a72b0a7daf6?auto=format&fit=crop&q=80&w=3203&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/15.mp3'),
      tag: MediaItem(
        id: '14',
        title: 'song15',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1695064823570-3a72b0a7daf6?auto=format&fit=crop&q=80&w=3203&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/16.mp3'),
      tag: MediaItem(
        id: '15',
        title: 'song16',
        artUri: Uri.parse(
            'https://images.unsplash.com/photo-1695064823570-3a72b0a7daf6?auto=format&fit=crop&q=80&w=3203&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
      ),
    ),
    AudioSource.uri(
      Uri.parse('https://infusevalue.com/public/music/song/17.mp3'),
      tag: MediaItem(
        id: '16',
        title: 'song17',
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
