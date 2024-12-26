import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/microphone_view.dart';

class MicrophoneView extends StatelessWidget {
  final MicrophoneController controller = Get.put(MicrophoneController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Microphone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan teks yang dikenali
            Obx(() => Text(
                  controller.recognizedText.value,
                  style: TextStyle(fontSize: 24),
                )),
            SizedBox(height: 20),
            // Tombol untuk Start/Stop Listening
            ElevatedButton(
              onPressed: () {
                // Memulai atau menghentikan pendengaran
                if (controller.recognizedText.value.isEmpty) {
                  controller.startListening();
                } else {
                  controller.stopListening();
                }
              },
              child: Text(
                controller.recognizedText.value.isEmpty
                    ? 'Start Listening' // Jika tidak ada teks, tombol akan bertuliskan 'Start Listening'
                    : 'Stop Listening', // Jika ada teks yang dikenali, tombol akan bertuliskan 'Stop Listening'
              ),
            ),
            SizedBox(height: 20),
            // Tombol Microphone dengan ikon
            IconButton(
              icon: Icon(Icons.mic, size: 40),
              onPressed: () {
                if (controller.recognizedText.value.isEmpty) {
                  controller.startListening();
                } else {
                  controller.stopListening();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
