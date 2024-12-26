import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioController extends GetxController {
  final RxString currentAudio = 'No Audio Playing'.obs;
  final RxBool isPlaying = false.obs;

  late AudioPlayer _audioPlayer;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
  }

  Future<void> playAudio(String url) async {
    try {
      await _audioPlayer.play(UrlSource(url));
      isPlaying.value = true;
      currentAudio.value = 'Playing Audio...';
    } catch (e) {
      currentAudio.value = 'Error Playing Audio: $e';
    }
  }

  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
      isPlaying.value = false;
      currentAudio.value = 'Audio Paused';
    } catch (e) {
      currentAudio.value = 'Error Pausing Audio: $e';
    }
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      isPlaying.value = false;
      currentAudio.value = 'Audio Stopped';
    } catch (e) {
      currentAudio.value = 'Error Stopping Audio: $e';
    }
  }
}
