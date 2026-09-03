import 'package:get/get.dart';
import 'new_order_controller.dart';

class NewOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewOrderController());
  }
}
