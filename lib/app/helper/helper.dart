import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

String name = 'Please Scan ID First';
String id = '###########';
String dept = '###';
String intake = '##';
String section = '##';
double balance = 0;

String scannedBarcode = '';

Map<String, int> cartItems = {};

List<Map<String, dynamic>> studentData = [];

const ordersKey = 'orders';

class Order {
  final String studentId;
  final List<MapEntry<String, int>>
      items; // Change items to List<MapEntry<String, int>>
  final double totalPrice;
  final DateTime timestamp;

  Order(
      {required this.studentId,
      required this.items,
      required this.totalPrice,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'items': items
          .map((entry) => {'foodId': entry.key, 'quantity': entry.value})
          .toList(), // Convert items to a list of maps
      'totalPrice': totalPrice, // Add totalPrice
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      studentId: map['studentId'],
      items: (map['items'] as List)
          .map(
              (item) => MapEntry<String, int>(item['foodId'], item['quantity']))
          .toList(), // Parse items from list of maps
      totalPrice: map['totalPrice'], // Parse totalPrice
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

class OrderManager {
  static Future<void> saveOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedOrders = orders.map((order) => order.toMap()).toList();
    await prefs.setString(ordersKey, jsonEncode(encodedOrders));
  }

  static Future<List<Order>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ordersString = prefs.getString(ordersKey);
    if (ordersString == null) {
      return [];
    }
    final List<dynamic> decodedOrders = jsonDecode(ordersString);
    return decodedOrders.map<Order>((order) => Order.fromMap(order)).toList();
  }
}
