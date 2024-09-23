import 'dart:convert';
import 'package:cashless_cafe/app/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cashless_cafe/app/components/food_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> foodItems = [];
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    loadFoodItems();
    loadOrdersForStudent(scannedBarcode);
    initPrefs();
  }

  late SharedPreferences _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    loadStudentData();
  }

  Future<void> loadOrdersForStudent(String studentId) async {
    _orders = await OrderManager.loadOrders();
    setState(() {});
  }

  Future<void> loadStudentData() async {
    String? jsonString = _prefs.getString('student_data');
    if (jsonString == null || jsonString.isEmpty) {
      // If student_data is empty in SharedPreferences, load data from JSON
      String jsonData = await rootBundle.loadString('data/student_data.json');
      _prefs.setString(
          'student_data', jsonData); // Save JSON data to SharedPreferences
      jsonString = jsonData; // Update jsonString with loaded JSON data
    }
    setState(() {
      studentData = jsonDecode(jsonString!).cast<Map<String, dynamic>>();
    });
  }

  Future<void> loadFoodItems() async {
    String jsonString = await rootBundle.loadString('data/fooditems.json');
    List<dynamic> decodedData = jsonDecode(jsonString);

    // IDs to include
    List<String> popularItems = ['0', '1', '2', '3', '4', '5', '6'];

    setState(() {
      foodItems = decodedData.where((item) {
        return popularItems.contains(item['id']);
      }).toList();
    });

    // Debugging statement
    print('Loaded food items: $foodItems');
  }

  final List<Map<String, String>> foodOptions = [
    {
      'name': 'Chicken',
      'image': 'images/Icon-001.png',
    },
    {
      'name': 'Burger',
      'image': 'images/Icon-002.png',
    },
    {
      'name': 'Fastfood',
      'image': 'images/Icon-003.png',
    },
    {
      'name': 'Salads',
      'image': 'images/Icon-004.png',
    },
    {
      'name': 'Drinks',
      'image': 'images/Icon-003.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Cashless Cafe - BUBT',
                    style: TextStyle(fontSize: 21.0),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 0.0,
                left: 20.0,
                right: 20.0,
              ),
              child: name == '' || name == 'Please Scan ID First'
                  ? Container(
                      margin: const EdgeInsets.only(
                        top: 30.0,
                        bottom: 30.0,
                      ),
                      child: const Text(
                        'Please scan your ID card to view your profile',
                        style: TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                            top: 30.0,
                            bottom: 15.0,
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            radius: 35.0,
                            child: Icon(
                              Icons.person,
                              size: 30.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                        Text(
                          'ID: $id',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(
                                  Icons.school,
                                  size: 20.0,
                                ),
                              ),
                              Text(
                                dept,
                                style: const TextStyle(fontSize: 15.0),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(
                                  Icons.diversity_3,
                                  size: 20.0,
                                ),
                              ),
                              Text(
                                intake,
                                style: const TextStyle(fontSize: 15.0),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(
                                  Icons.people,
                                  size: 20.0,
                                ),
                              ),
                              Text(
                                section,
                                style: const TextStyle(fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(
                                  Icons.account_balance_wallet,
                                  size: 20.0,
                                ),
                              ),
                              Text(
                                'BDT $balance',
                                style: const TextStyle(fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              height: 105,
              margin: const EdgeInsets.only(
                top: 20.0,
                bottom: 25.0,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                    left: 20.0,
                  ),
                  itemCount: this.foodOptions.length,
                  itemBuilder: (context, index) {
                    Map<String, String> option = this.foodOptions[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 35.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 70,
                            height: 70,
                            margin: const EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  option['image']!,
                                ),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10.0,
                                  color: Colors.grey[300] ?? Colors.grey,
                                  offset: const Offset(6.0, 6.0),
                                )
                              ],
                            ),
                          ),
                          Text(
                            option['name']!,
                            style: const TextStyle(fontSize: 17.0),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: Text(
                'Available Items',
                style: TextStyle(fontSize: 21.0),
              ),
            ),
            Container(
              height: 220.0,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: this.foodItems.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> product = this.foodItems[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'details',
                        arguments: {
                          'product': product,
                          'index': index,
                        },
                      );
                    },
                    child: Hero(
                      tag: 'detail_food$index',
                      child: FoodCard(
                        width: size.width / 2 - 30.0,
                        primaryColor: theme.primaryColor,
                        productName: product['name']!,
                        productPrice: product['price']!,
                        productUrl: product['image']!,
                        productInventory: product['inventory']!,
                        productRate: product['rate']!,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                bottom: 10.0,
                top: 35.0,
              ),
              child: Text(
                'Recent Orders',
                style: TextStyle(fontSize: 21.0),
              ),
            ),
            Container(
              height: 200.0,
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  if (_orders.isNotEmpty) {
                    return ListTile(
                      title: Text(
                          'Order ID: ${_orders[index].timestamp.hashCode} - ${_orders[index].studentId}'),
                      subtitle: Text('Total: BDT ${_orders[index].totalPrice}'),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
