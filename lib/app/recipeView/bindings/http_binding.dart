import 'package:get/get.dart';
import 'package:praktikum_mod_1/app/data/service/http_controller.dart';

class HttpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HttpController>(
      () => HttpController(),
    );
  }
}
