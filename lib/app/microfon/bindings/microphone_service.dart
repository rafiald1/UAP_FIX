import 'package:speech_to_text/speech_to_text.dart';

class MicrophoneService {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;

  Future<void> init() async {
    await _speech.initialize();
  }

  Future<void> startListening(Function(String) onResult) async {
    _isListening = true;
    await _speech.listen(onResult: (result) {
      onResult(result.recognizedWords);
    });
  }

  void stopListening() {
    _isListening = false;
    _speech.stop();
  }

  bool get isListening => _isListening;
}
