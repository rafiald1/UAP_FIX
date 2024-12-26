import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikum_mod_1/app/home/controllers/crud_controller.dart';

import '../controllers/connection_controller.dart';

class AddEditRecipeView extends GetView<CrudController> {
  final String? recipeId;
  const AddEditRecipeView({Key? key, this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeId == null ? 'Tambah Resep' : 'Edit Resep'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(
                labelText: 'Judul Resep',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: controller.descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi Resep',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: controller.pickImage,
              child: const Text('Pilih Gambar'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                textStyle: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 16.0),
            GetBuilder<CrudController>(
              builder: (controller) {
                return controller.imageFile != null
                    ? Image.file(controller.imageFile!)
                    : const Text('No image selected');
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (recipeId == null) {
                  controller.addRecipe();
                } else {
                  controller.updateRecipe(recipeId!);
                }
              },
              child:
                  Text(recipeId == null ? 'Tambah Resep' : 'Simpan Perubahan'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                textStyle: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
