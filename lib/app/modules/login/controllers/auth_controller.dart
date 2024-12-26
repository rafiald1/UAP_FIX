import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();
  final Connectivity _connectivity = Connectivity();

  // Menambahkan variable untuk menyimpan nama dan email
  var userName = ''.obs;
  var userEmail = ''.obs;
  var isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUserInfo();
    _checkStoredData(); // Memastikan data tersimpan offline dikirim saat online
  }

  // Mengecek koneksi internet
  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print('DEBUG: Connectivity Result = $connectivityResult');

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      print('DEBUG: Koneksi Internet Terdeteksi.');
      return true;
    }

    print('DEBUG: Tidak Ada Koneksi.');
    return false;
  }

  // Inisialisasi user info
  Future<void> _initializeUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? 'No Name';
      userEmail.value = user.email ?? 'No Email';
    }
  }

  // Fungsi untuk mengecek dan mengirim data offline ke Firestore saat koneksi kembali
  Future<void> _checkStoredData() async {
    if (await isConnected()) {
      final localData = _storage.read('offlineData');
      if (localData != null) {
        await _firestore.collection('users').add(localData);
        _storage.remove(
            'offlineData'); // Hapus data lokal setelah berhasil disimpan
      }
    }
  }

  Future<void> register(String email, String password) async {
    try {
      // Cek apakah email adalah admin
      if (email == 'admin@gmail.com') {
        Get.snackbar(
            'Error', 'Email admin tidak dapat digunakan untuk registrasi');
        return;
      }

      if (!(await isConnected())) {
        // Simpan data lokal jika offline
        _storage.write('offlineData', {"email": email, "password": password});
        Get.snackbar(
            'Offline', 'Data Anda disimpan, akan dikirim saat online.');
        return;
      }

      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection('users').add({"email": email});

      Get.snackbar('Success', 'Akun berhasil dibuat');
      await _initializeUserInfo();
      Get.toNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Error: ${e.toString()}');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      if (!(await isConnected())) {
        Get.snackbar('No Internet', 'Maaf, koneksi anda hilang.');
        return;
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Mengecek apakah pengguna adalah admin
      if (email == 'admin@gmail.com' && password == 'admin123') {
        isAdmin.value = true;
      } else {
        isAdmin.value = false;
      }

      Get.snackbar('Success', 'Login berhasil');
      await _initializeUserInfo();
      Get.toNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Email atau Password salah!');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    userName.value = '';
    userEmail.value = '';
    Get.snackbar('Success', 'Logout berhasil');
  }

  // Fungsi untuk memperbarui email dan password
  Future<void> updateUserProfile({
    required String email,
    required String password,
  }) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        Get.snackbar('Error',
            'Anda harus login terlebih dahulu untuk memperbarui profil.');
        return;
      }

      if (!(await isConnected())) {
        Get.snackbar('Error', 'Tidak ada koneksi internet.');
        return;
      }

      if (email.isEmpty && password.isEmpty) {
        Get.snackbar('Error', 'Tidak ada perubahan untuk disimpan.');
        return;
      }

      // Update email
      if (email.isNotEmpty && email != userEmail.value) {
        if (!email.contains('@')) {
          Get.snackbar('Error', 'Email tidak valid.');
          return;
        }

        await user.verifyBeforeUpdateEmail(email).then((_) {
          Get.snackbar('Success',
              'Verifikasi email telah dikirim ke $email. Selesaikan verifikasi untuk melanjutkan.');
        }).catchError((e) {
          throw Exception('Gagal mengirim email verifikasi. ${e.toString()}');
        });

        // Tunggu verifikasi sebelum update
        print(
            'DEBUG: Email baru harus diverifikasi sebelum melanjutkan perubahan.');
      }

      // Update password
      if (password.isNotEmpty) {
        if (password.length < 6) {
          Get.snackbar('Error', 'Password harus minimal 6 karakter.');
          return;
        }
        await user.updatePassword(password);
        Get.snackbar('Success', 'Password berhasil diperbarui');
      }

      // Simpan data baru ke Firestore
      if (email.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({"email": email});
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
    }
  }
}
