import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikum_mod_1/app/data/service/http_controller.dart';

class HttpView extends GetView<HttpController> {
  const HttpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Recipes'),
      ),
      body: Obx(() {
        // Menampilkan loading jika data masih diambil
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          );
        } else {
          // Jika data sudah tersedia, tampilkan ListView
          return ListView.builder(
            shrinkWrap: true,
            itemCount: controller.recipes.length,
            itemBuilder: (context, index) {
              var recipe = controller.recipes[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(
                    recipe.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ), // Menampilkan gambar resep
                  title: Text(recipe.title), // Menampilkan judul resep
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Waktu masak: ${recipe.readyInMinutes} menit'),
                      Text('Porsi: ${recipe.servings} porsi'),
                      const SizedBox(height: 5),
                      Text(recipe.instructions.isNotEmpty
                          ? recipe.instructions
                          : 'Instruksi tidak tersedia'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        }
      }),
    );
  }
}
