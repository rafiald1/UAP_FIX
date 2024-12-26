import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({super.key});

  @override
  _AudioPlayerViewState createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentAudio = '';

  // URL audio
  final String audioUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void playAudio() async {
    if (!isPlaying) {
      try {
        await _audioPlayer.play(UrlSource(audioUrl)); // Perbaikan di sini
        setState(() {
          isPlaying = true;
          currentAudio = 'Playing Audio...';
        });
      } catch (e) {
        print('Error playing audio: $e');
      }
    }
  }

  void pauseAudio() async {
    if (isPlaying) {
      try {
        await _audioPlayer.pause(); // Tidak ada nilai return
        setState(() {
          isPlaying = false;
          currentAudio = 'Audio Paused';
        });
      } catch (e) {
        print('Error pausing audio: $e');
      }
    }
  }

  void stopAudio() async {
    try {
      await _audioPlayer.stop(); // Tidak ada nilai return
      setState(() {
        isPlaying = false;
        currentAudio = 'Audio Stopped';
      });
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentAudio.isEmpty ? 'Press Play to Start' : currentAudio,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: playAudio,
                  child: const Text('Play'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: pauseAudio,
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: stopAudio,
                  child: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
