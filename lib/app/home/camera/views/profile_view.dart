import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../modules/login/controllers/auth_controller.dart';
import '../../controllers/connection_controller.dart';
import '../controllers/profile_controller.dart';
import 'package:video_player/video_player.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController =
        Get.find<AuthController>(); // Mengakses AuthController

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan Avatar dan Pop-Up Menu
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Stack(
                children: [
                  Row(
                    children: [
                      // Menampilkan avatar
                      Obx(() {
                        if (controller.imageFile.value == null) {
                          return const CircleAvatar(
                            radius: 40,
                            child: Icon(Icons.person, size: 40),
                          );
                        } else if (controller.imageFile.value!.path
                            .endsWith('.mp4')) {
                          return const CircleAvatar(
                            radius: 40,
                            child: Icon(Icons.video_file),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                FileImage(controller.imageFile.value!),
                          );
                        }
                      }),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Menggunakan Obx untuk menampilkan nama dan email yang diambil dari AuthController
                          Obx(() {
                            return Text(
                              authController.userName.value,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                          Obx(() {
                            return Text(authController.userEmail.value);
                          }),
                        ],
                      ),
                    ],
                  ),
                  // Ikon Kamera pada Profil
                  Positioned(
                    bottom: 0,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        // Menampilkan Pop-Up Menu
                        _showPickOptions(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  // Tombol Delete
                  if (controller.imageFile.value != null) // Pastikan gambar ada
                    Positioned(
                      bottom: 0,
                      left: 50,
                      child: GestureDetector(
                        onTap: () {
                          controller.deleteFile(); // Hapus gambar profil
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Menu Pengaturan (Tetap Sama)
            _buildSectionTitle('Account Settings'),
            _buildListTile(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                Get.toNamed('/edit_profile'); // Arahkan ke halaman Edit Profile
              },
            ),
            _buildListTile(
              icon: Icons.account_balance,
              title: 'Bank Data',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.contacts,
              title: 'Contacts',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Preferences'),
            _buildListTile(
              icon: Icons.color_lens,
              title: 'Theme',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.help,
              title: 'Help',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            // Menambahkan menu Logout di bawah
            _buildSectionTitle('Logout'),
            _buildListTile(
              icon: Icons.exit_to_app,
              title: 'Logout',
              onTap: () {
                authController.logout(); // Memanggil fungsi logout
                Get.offAllNamed('/login'); // Arahkan ke halaman login
              },
            ),
          ],
        ),
      ),
    );
  }

  // Pop-Up Menu untuk Pilihan Ambil Gambar/Video
  void _showPickOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo from Camera'),
              onTap: () {
                Get.find<ProfileController>().pickImageFromCamera();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_camera_back),
              title: const Text('Take Video from Camera'),
              onTap: () {
                Get.find<ProfileController>().pickVideoFromCamera();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick Photo from Gallery'),
              onTap: () {
                Get.find<ProfileController>().pickImageFromGallery();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Pick Video from Gallery'),
              onTap: () {
                Get.find<ProfileController>().pickVideoFromGallery();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Widget untuk Judul Section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget untuk ListTile
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}
