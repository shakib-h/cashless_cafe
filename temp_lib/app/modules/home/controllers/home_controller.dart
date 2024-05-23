import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable variable to store scanned data
  final scannedBarcode = ''.obs;

  //TODO: Implement other functionalities (if needed)

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
