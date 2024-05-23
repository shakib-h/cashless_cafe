import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Cashless Cafe",
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Obx(() => Text(
                  'Student ID: ${controller.scannedBarcode.value}',
                  style: const TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              "#ff6666",
              'Cancel',
              true,
              ScanMode.BARCODE,
            );
            controller.scannedBarcode.value = barcodeScanRes;
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
