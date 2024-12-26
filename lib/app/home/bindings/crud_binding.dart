import 'package:get/get.dart';
import 'package:praktikum_mod_1/app/home/controllers/crud_controller.dart';

class CrudBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrudController>(() => CrudController());
  }
}
