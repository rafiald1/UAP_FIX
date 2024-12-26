import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../home/controllers/connection_controller.dart';

// Controller untuk mengelola pengenalan suara
class MicrophoneController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  var recognizedText = ''.obs;
  var isListening = false.obs;

  // Inisialisasi pengenalan suara
  Future<void> initializeSpeech() async {
    try {
      await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
    } catch (e) {
      print('Error initializing speech recognition: $e');
    }
  }

  // Mulai mendengarkan suara
  Future<void> startListening() async {
    if (!_speech.isAvailable) {
      await initializeSpeech();
    }
    if (_speech.isAvailable) {
      isListening.value = true;
      _speech.listen(onResult: (result) {
        recognizedText.value = result.recognizedWords;
      });
    }
  }

  // Berhenti mendengarkan suara
  void stopListening() {
    isListening.value = false;
    _speech.stop();
  }

  @override
  void onClose() {
    _speech.stop();
    super.onClose();
  }
}

// View untuk pengenalan suara
class MicrophoneView extends StatelessWidget {
  final MicrophoneController controller = Get.put(MicrophoneController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Assistant"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        leading: const Icon(Icons.mic),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade700, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header Text
            const Text(
              "Voice Command Interface",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Recognized Text Display
            Obx(() => Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    controller.recognizedText.value.isEmpty
                        ? "Tap the button and speak"
                        : controller.recognizedText.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                )),
            const SizedBox(height: 30),

            // Microphone Button
            Obx(() => InkWell(
                  onTap: () {
                    controller.isListening.value
                        ? controller.stopListening()
                        : controller.startListening();
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: controller.isListening.value
                            ? [Colors.red.shade600, Colors.redAccent]
                            : [Colors.indigo.shade400, Colors.indigoAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      controller.isListening.value ? Icons.mic : Icons.mic_none,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                )),
            const SizedBox(height: 30),

            // Instruction Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Press the microphone to start or stop listening. Recognized text will appear above.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
