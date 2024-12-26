import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:praktikum_mod_1/api/firebase_api.dart';
import 'package:praktikum_mod_1/app/home/camera/controllers/profile_controller.dart';
import 'package:praktikum_mod_1/app/home/controllers/connection_controller.dart';
import 'package:praktikum_mod_1/app/routes/app_pages.dart';
import 'package:praktikum_mod_1/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/home/controllers/crud_controller.dart';
import 'app/modules/login/controllers/auth_controller.dart';

final navigatorKey = GlobalKey<NavigatorState>();
// Inisialisasi pesan Firebase
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// Tangani pesan saat aplikasi tidak aktif
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await GetStorage.init();

  Get.put(ProfileController());

  Get.put(CrudController());
  Get.put(AuthController());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
