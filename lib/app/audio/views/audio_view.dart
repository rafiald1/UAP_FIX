import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_controller.dart';

class AudioView extends GetView<AudioController> {
  const AudioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioUrlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Input URL audio with styled box
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: audioUrlController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Enter audio URL',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    prefixIcon: const Icon(Icons.link, color: Colors.teal),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              // Dynamic Play/Pause Button
              Obx(() {
                return ElevatedButton.icon(
                  onPressed: () {
                    if (controller.isPlaying.value) {
                      controller.pauseAudio();
                    } else {
                      controller.playAudio(audioUrlController.text);
                    }
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      controller.isPlaying.value
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      key: ValueKey(controller.isPlaying.value),
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  label: Text(
                    controller.isPlaying.value ? 'Pause' : 'Play',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 25.0),
                    backgroundColor: Colors.green,
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20.0),

              // Current Status Message
              Obx(
                () => Text(
                  controller.currentAudio.value.isEmpty
                      ? "Ready to play"
                      : "Playing: ${controller.currentAudio.value}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30.0),

              // Audio Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _controlButton(
                    icon: Icons.play_arrow,
                    label: 'Play',
                    onPressed: () {
                      controller.playAudio(audioUrlController.text);
                    },
                  ),
                  const SizedBox(width: 10),
                  _controlButton(
                    icon: Icons.pause,
                    label: 'Pause',
                    onPressed: controller.pauseAudio,
                  ),
                  const SizedBox(width: 10),
                  _controlButton(
                    icon: Icons.stop,
                    label: 'Stop',
                    onPressed: controller.stopAudio,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom control button for reusability
  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        backgroundColor: Colors.green,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
