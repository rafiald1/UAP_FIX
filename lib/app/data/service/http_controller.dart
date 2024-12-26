import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:praktikum_mod_1/app/data/models/recipe.dart';

class HttpController extends GetxController {
  static const String _baseUrl = 'https://api.spoonacular.com/recipes/random';
  static const String _apiKey =
      '653ab336c6414ff68efe3466bf736da9'; //Ganti ke API KEY yang sudah didapat
  RxList<Recipe> recipes = RxList<Recipe>([]);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes(); // Memanggil fetchRecipes saat controller diinisialisasi
  }

  Future<void> fetchRecipes() async {
    try {
      isLoading.value = true;
      // Mengambil data dari API dengan jumlah 10 resep
      final response = await http.get(
        Uri.parse('$_baseUrl?apiKey=$_apiKey&number=10'),
      );

      if (response.statusCode == 200) {
        // Memparsing data JSON
        final jsonData = response.body;
        final recipesResult = Recipes.fromJson(json.decode(jsonData));
        // Mengisi recipes dengan hasil dari API
        recipes.value = recipesResult.recipes;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
