import 'package:get/get.dart';
import 'package:praktikum_mod_1/app/audio/bindings/audio_binding.dart';
import 'package:praktikum_mod_1/app/audio/views/audio_view.dart';
import 'package:praktikum_mod_1/app/audio/views/audioplayer_view.dart';
import 'package:praktikum_mod_1/app/home/bindings/crud_binding.dart';
import 'package:praktikum_mod_1/app/home/bindings/home_binding.dart';
import 'package:praktikum_mod_1/app/home/views/crud_view.dart';
import 'package:praktikum_mod_1/app/home/views/home_view.dart';
import 'package:praktikum_mod_1/app/modules/login/bindings/auth_binding.dart';
import 'package:praktikum_mod_1/app/modules/login/views/register_view.dart';
import 'package:praktikum_mod_1/app/recipeView/bindings/http_binding.dart';
import 'package:praktikum_mod_1/app/recipeView/views/http_view.dart';
import 'package:praktikum_mod_1/app/recipeView/views/recipe_view.dart';
import '../home/bindings/connection_binding.dart';
import '../home/camera/bindings/profile_binding.dart';
import '../home/camera/views/edit_profile_view.dart';
import '../home/camera/views/profile_view.dart';
import '../map/bindings/location_binding.dart';
import '../map/views/location_view.dart';
import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: ConnectionBinding(), // Pastikan binding dipasang dengan benar
    ),
    GetPage(
      name: _Paths.HTTP,
      page: () => HttpView(),
      binding: HttpBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.CRUD,
      page: () => CrudView(),
      binding: CrudBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.AUDIO,
      page: () => AudioView(),
      binding: AudioBinding(),
    ),
    GetPage(
      name: Routes.AUDIO,
      page: () => const AudioPlayerView(),
    ),
    GetPage(
      name: Routes.LOCATION,
      page: () => LocationView(),
      binding: LocationBinding(),
    ),
    GetPage(
      name: '/edit_profile',
      page: () => EditProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
