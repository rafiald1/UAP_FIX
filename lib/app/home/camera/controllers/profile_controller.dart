import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';

class ProfileController extends GetxController {
  final imageFile = Rx<File?>(null); // Untuk gambar atau video
  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? videoPlayerController; // Controller untuk video

  // Ambil gambar dari galeri
  Future<void> pickImageFromGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
      box.write('profile_image', pickedImage.path);
      _disposeVideoPlayer(); // Pastikan video player dihapus
    }
  }

  // Ambil gambar dari kamera
  Future<void> pickImageFromCamera() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
      box.write('profile_image', pickedImage.path);
      _disposeVideoPlayer(); // Pastikan video player dihapus
    }
  }

  // Ambil video dari galeri
  Future<void> pickVideoFromGallery() async {
    final XFile? pickedVideo =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      imageFile.value = File(pickedVideo.path);
      box.write('profile_video', pickedVideo.path);
      _initializeVideoPlayer(pickedVideo.path);
    }
  }

  // Ambil video dari kamera
  Future<void> pickVideoFromCamera() async {
    final XFile? pickedVideo =
        await _picker.pickVideo(source: ImageSource.camera);
    if (pickedVideo != null) {
      imageFile.value = File(pickedVideo.path);
      box.write('profile_video', pickedVideo.path);
      _initializeVideoPlayer(pickedVideo.path);
    }
  }

  // Inisialisasi Video Player
  Future<void> _initializeVideoPlayer(String videoPath) async {
    videoPlayerController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        videoPlayerController!.setLooping(true);
        videoPlayerController!.play();
        update(); // Update tampilan
      });
  }

  // Hapus video player
  void _disposeVideoPlayer() {
    videoPlayerController?.dispose();
    videoPlayerController = null;
  }

  // Hapus file
  void deleteFile() {
    imageFile.value = null;
    box.remove('profile_image');
    box.remove('profile_video');
    _disposeVideoPlayer();
  }

  @override
  void onInit() {
    super.onInit();
    // Load data dari storage
    String? savedFile = box.read('profile_image') ?? box.read('profile_video');
    if (savedFile != null) {
      imageFile.value = File(savedFile);
      if (savedFile.endsWith('.mp4')) {
        _initializeVideoPlayer(savedFile);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    _disposeVideoPlayer();
  }
}
