import 'package:get/instance_manager.dart';

import 'controller/scan_controller2.dart';
class GlobalBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<ScanController2>(() => ScanController2());
  }
}