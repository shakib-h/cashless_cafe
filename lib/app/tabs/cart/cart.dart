import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cashless_cafe/app/components/custom_header.dart';
import 'package:cashless_cafe/app/helper/helper.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> foodItems =
      []; // List to store food items from JSON

  @override
  void initState() {
    this._tabController = TabController(
      initialIndex: 0,
      length: 1,
      vsync: this,
    );
    loadFoodItems();
    initPrefs();
    super.initState();
  }

  late SharedPreferences _prefs;
  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void checkout() {
    double totalPrice = calculateTotalPrice(cartItems);
    deductAmount(scannedBarcode, totalPrice);
    saveOrder(scannedBarcode, cartItems, totalPrice);
    setState(() {
      cartItems.clear();
    });
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

  Future<void> saveOrder(
      String studentId, Map<String, int> items, double totalPrice) async {
    // Load existing orders from SharedPreferences
    List<Order> orders = await loadOrders();

    // Add new order to the list
    Order newOrder = Order(
        studentId: studentId,
        items: items.entries.toList(),
        totalPrice: totalPrice,
        timestamp: DateTime.now());
    orders.add(newOrder);

    // Save updated orders to SharedPreferences
    await OrderManager.saveOrders(orders);
  }

  double calculateTotalPrice(Map<String, int> cartItems) {
    double total = 0.0;
    cartItems.forEach((foodId, quantity) {
      // Find food details in foodItems list by matching IDs
      Map<String, dynamic> foodDetails = foodItems.firstWhere(
        (food) => food['id'] == foodId,
        orElse: () => {},
      );
      double price = double.tryParse(foodDetails['price'] ?? '0.0') ?? 0.0;
      total += price * quantity;
    });
    return total;
  }

  void deductAmount(String scannedBarcode, double totalPrice) {
    // Deduct total price from student's balance
    setState(() {
      studentData.forEach((student) {
        if (student['ID'] == scannedBarcode) {
          student['Balance'] = (student['Balance'] ?? 0) - totalPrice;
        }
      });
      balance = balance - totalPrice;
    });

    // Save updated student data to SharedPreferences
    _prefs.setString('student_data', jsonEncode(studentData));
  }

  Future<void> loadFoodItems() async {
    String jsonString = await rootBundle.loadString('data/fooditems.json');
    List<dynamic> decodedData = jsonDecode(jsonString);
    setState(() {
      foodItems = decodedData.cast<Map<String, dynamic>>();
    });
  }

  Widget renderCartList(Map<String, int> cartItems) {
    ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (BuildContext context, int index) {
        String foodId = cartItems.keys.elementAt(index);
        int quantity = cartItems.values.elementAt(index);
        // Find food details in foodItems list by matching IDs
        Map<String, dynamic> foodDetails = foodItems.firstWhere(
          (food) => food['id'] == foodId,
          orElse: () => {},
        );
        Color primaryColor = theme.primaryColor;
        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: Card(
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(foodDetails['image'] ?? ''),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(foodDetails['name'] ?? ''),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                setState(() {
                                  // Remove the item from cartItems
                                  cartItems.remove(foodId);
                                });
                              },
                            ),
                          ],
                        ),
                        Text('BDT ${foodDetails['price'] ?? ''}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (cartItems.containsKey(foodId)) {
                                    if (cartItems[foodId]! > 1) {
                                      if (cartItems[foodId] != null) {
                                        cartItems[foodId] =
                                            cartItems[foodId]! - 1;
                                      }
                                    } else {
                                      cartItems.remove(
                                          foodId); // Remove item if quantity becomes zero
                                    }
                                  }
                                });
                              },
                              child: const Icon(Icons.remove),
                            ),
                            Container(
                              color: primaryColor,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 3.0,
                                horizontal: 12.0,
                              ),
                              child: Text(
                                '$quantity',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (cartItems.containsKey(foodId)) {
                                    if (cartItems.containsKey(foodId)) {
                                      cartItems[foodId] =
                                          cartItems[foodId]! + 1;
                                    }
                                  } else {
                                    cartItems[foodId] = 1;
                                  }
                                });
                              },
                              child: Icon(
                                Icons.add,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: <Widget>[
          CustomHeader(
            title: 'Cart',
            quantity: cartItems.isEmpty
                ? 0
                : cartItems.values.reduce((a, b) => a + b),
            internalScreen: false,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10.0,
            ),
            child: TabBar(
              controller: this._tabController,
              indicatorColor: theme.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black87,
              tabs: const <Widget>[
                Tab(text: 'Confirm Order'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TabBarView(
                controller: this._tabController,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: renderCartList(cartItems), // Pass cartItems here
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Total:  ${calculateTotal(cartItems).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 45.0),
                        child: ElevatedButton(
                          onPressed: () {
                            checkout();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: theme.primaryColor,
                          ),
                          child: const Text(
                            'CHECKOUT',
                            style: TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  double calculateTotal(Map<String, int> cartItems) {
    double total = 0.0;
    cartItems.forEach((foodId, quantity) {
      // Find food details in foodItems list by matching IDs
      Map<String, dynamic> foodDetails = foodItems.firstWhere(
        (food) => food['id'] == foodId,
        orElse: () => {},
      );
      double price = double.tryParse(foodDetails['price'] ?? '0.0') ?? 0.0;
      total += price * quantity;
    });
    return total;
  }
}
