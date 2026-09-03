import 'package:get/get.dart';
import 'account_details_controller.dart';

class AccountDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountDetailsController());
  }
}
