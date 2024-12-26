import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:praktikum_mod_1/app/microfon/controllers/microphone_controller.dart';
import 'package:praktikum_mod_1/app/recipeView/views/recipe_view.dart';
import 'package:praktikum_mod_1/app/routes/app_pages.dart';
import '../../modules/login/controllers/auth_controller.dart';
import '../camera/controllers/profile_controller.dart';
import '../controllers/connection_controller.dart';
import '../controllers/home_controller.dart';
import 'dart:io';
import 'package:praktikum_mod_1/app/home/controllers/crud_controller.dart'; // Import CrudController

class HomeView extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();
  final CrudController crudController =
      Get.find<CrudController>(); // Inisialisasi CrudController

  // Menambahkan controller untuk search text
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final connectionController = Get.find<ConnectionController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaBites'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // Tombol profil dinamis
          Obx(() {
            final imageFile = Get.find<ProfileController>().imageFile.value;
            return IconButton(
              icon: imageFile != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(imageFile),
                    )
                  : const Icon(Icons.person),
              onPressed: () {
                Get.toNamed(Routes.PROFILE); // Navigasi ke halaman profil
              },
            );
          }),
          // Tombol logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.find<AuthController>().logout();
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar dengan ikon microphone
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            controller:
                                searchController, // Pake search controller
                            decoration: const InputDecoration(
                              hintText: 'Mau resep apa bro?',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              crudController.searchRecipes(value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.mic), // Ikon Microphone
                          onPressed: () {
                            Get.to(
                                MicrophoneView()); // Navigasi ke halaman MicrophoneView
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: const Image(
                      image: AssetImage('assets/recomend2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.AUDIO); // Navigasi ke halaman Audio
                    },
                    child: const Text('Go to Audio Player'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.restaurant, 'Makanan'),
                  _buildIconButton(Icons.local_dining, 'Hidangan'),
                  _buildIconButton(Icons.local_drink, 'Minuman'),
                  _buildIconButton(Icons.emoji_food_beverage, 'Snack'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu Rekomendasi',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          child: GestureDetector(
                            child: const Image(
                              image: AssetImage('assets/rekomen1.jpg'),
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              Get.to(RecipeView(
                                  url:
                                      'https://cookpad.com/id/cari/nasi%20goreng'));
                            },
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ClipRRect(
                          child: GestureDetector(
                            child: const Image(
                              image: AssetImage('assets/cover.jpg'),
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              Get.to(RecipeView(
                                  url:
                                      'https://cookpad.com/id/cari/bubur%20ayam'));
                            },
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.HTTP);
                    },
                    child: const Text('Lebih banyak'),
                  ),
                ],
              ),
            ),
            // Daftar Resep yang ditampilkan berdasarkan query
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resep Tersedia',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Obx(() {
                    if (crudController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (crudController.filteredRecipes.isEmpty) {
                        return const Center(child: Text('Belum ada resep.'));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: crudController.filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe =
                                crudController.filteredRecipes[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 5,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text(
                                  recipe['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(recipe['description']),
                              ),
                            );
                          },
                        );
                      }
                    }
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Gambar dari Galeri',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (image != null) {
                        File imageFile = File(image.path);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.file(imageFile),
                                  const SizedBox(height: 16.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Pilih Gambar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'NusaBites',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        // Menampilkan tombol 'Tambah' hanya untuk admin
        if (controller.isAdmin.value) {
          return FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.CRUD);
            },
            child: const Icon(Icons.add),
            tooltip: 'Tambah Resep',
          );
        }
        return SizedBox.shrink(); // Tidak ada tombol FAB untuk user biasa
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.tealAccent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            icon,
            size: 30.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(label),
      ],
    );
  }
}
