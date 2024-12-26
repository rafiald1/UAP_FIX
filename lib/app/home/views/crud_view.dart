import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikum_mod_1/app/home/controllers/crud_controller.dart';
import 'package:praktikum_mod_1/app/home/views/add_edit_recipe_view.dart';

import '../controllers/connection_controller.dart';

class CrudView extends GetView<CrudController> {
  const CrudView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Resep'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => const AddEditRecipeView()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (controller.recipes.isEmpty) {
            return const Center(
                child: Text('Belum ada resep yang ditambahkan.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: controller.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = controller.recipes[index];
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              controller.titleController.text = recipe['title'];
                              controller.descriptionController.text =
                                  recipe['description'];
                              Get.to(
                                  () => AddEditRecipeView(recipeId: recipe.id));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.deleteRecipe(recipe.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
      }),
    );
  }
}
