import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CrudController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  File? imageFile;

  RxList<DocumentSnapshot> recipes = RxList<DocumentSnapshot>([]);
  RxList<DocumentSnapshot> filteredRecipes = RxList<DocumentSnapshot>(
      []); // Daftar resep yang difilter sesuai pencarian
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes(); // Ambil daftar resep saat inisialisasi
  }

  // Mengambil resep-resep dari Firestore
  Future<void> fetchRecipes() async {
    isLoading.value = true;
    final snapshot = await firestore.collection('recipe').get();
    recipes.value = snapshot.docs; // Simpan semua resep di dalam `recipes`
    filteredRecipes.value =
        recipes.value; // Awalnya, filter juga menampilkan semua resep
    isLoading.value = false;
  }

  // Fungsi pencarian resep berdasarkan judul
  void searchRecipes(String query) {
    if (query.isEmpty) {
      filteredRecipes.value =
          recipes.value; // Menampilkan semua resep saat query kosong
    } else {
      filteredRecipes.value = recipes
          .where((recipe) =>
              recipe['title'].toLowerCase().contains(query.toLowerCase()))
          .toList(); // Menyaring resep berdasarkan query
    }
  }

  // Memilih gambar dari galeri
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update(); // Update untuk merender ulang UI
    }
  }

  // Menambah resep baru ke Firestore
  Future<void> addRecipe() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      await firestore.collection('recipe').add({
        'title': titleController.text,
        'description': descriptionController.text,
        // Tambahkan field lain sesuai kebutuhan
      });

      titleController.clear();
      descriptionController.clear();
      imageFile = null;
      update(); // Merender ulang UI setelah menambah resep
      fetchRecipes(); // Ambil daftar resep terbaru dari Firestore
      Get.back(); // Kembali ke halaman sebelumnya
    } else {
      Get.snackbar('Error',
          'Please fill all fields'); // Peringatan jika ada field kosong
    }
  }

  // Memperbarui resep yang sudah ada
  Future<void> updateRecipe(String id) async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      await firestore.collection('recipe').doc(id).update({
        'title': titleController.text,
        'description': descriptionController.text,
        // Tambahkan field lain sesuai kebutuhan
      });

      titleController.clear();
      descriptionController.clear();
      imageFile = null;
      update(); // Merender ulang UI setelah update
      fetchRecipes(); // Ambil daftar resep terbaru setelah update
      Get.back(); // Kembali ke halaman sebelumnya
    } else {
      Get.snackbar('Error',
          'Please fill all fields'); // Peringatan jika ada field kosong
    }
  }

  // Menghapus resep berdasarkan ID
  Future<void> deleteRecipe(String id) async {
    await firestore.collection('recipe').doc(id).delete();
    fetchRecipes(); // Ambil daftar resep terbaru setelah dihapus
  }
}
