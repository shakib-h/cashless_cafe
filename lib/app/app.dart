import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cashless_cafe/app/tabs/account/account.dart';
import 'package:cashless_cafe/app/tabs/cart/cart.dart';
import 'package:cashless_cafe/app/tabs/home/home.dart';
import 'package:flutter/services.dart';
import 'package:cashless_cafe/app/helper/helper.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Future<void> updateAccountData(String idCardNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String studentData = prefs.getString('student_data') ?? '[]';
    List<dynamic> data = jsonDecode(studentData);

    for (var student in data) {
      if (student['ID'] == idCardNo) {
        setState(() {
          name = student['Name'];
          id = student['ID'];
          dept = student['Dept.'];
          intake = student['Intake'];
          section = student['Section'];
          balance = student['Balance'];
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: theme.primaryColor,
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Scan ID'),
          onPressed: () async {
            try {
              final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                "#ff6666",
                'Cancel',
                true,
                ScanMode.BARCODE,
              );
              scannedBarcode = barcodeScanRes;
              // scannedBarcode = "21225103509";
              updateAccountData(scannedBarcode);
              cartItems.clear();
              balance = 1500;
              debugPrint(scannedBarcode);
            } catch (e) {
              print(e);
            }
          },
        ),
        body: TabBarView(
          children: <Widget>[
            Home(),
            Cart(),
            Account(),
          ],
        ),
        bottomNavigationBar: Material(
          color: Colors.white,
          child: TabBar(
            labelPadding: const EdgeInsets.only(bottom: 10),
            labelStyle: const TextStyle(fontSize: 16.0),
            indicatorColor: Colors.transparent,
            labelColor: theme.primaryColor,
            unselectedLabelColor: Colors.black54,
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.home, size: 28),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.card_travel, size: 28),
                text: 'Cart',
              ),
              Tab(
                icon: Icon(Icons.person_outline, size: 28),
                text: 'Student',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
