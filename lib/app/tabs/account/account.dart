import 'package:flutter/material.dart';
import 'package:cashless_cafe/app/components/food_card.dart';
import 'package:cashless_cafe/app/helper/helper.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Order> _orders = [];

  @override
  void initState() {
    _tabController = TabController(
      length: 1,
      initialIndex: 0,
      vsync: this,
    );
    loadOrdersForStudent(scannedBarcode);
    super.initState();
  }

  Future<void> loadOrdersForStudent(String studentId) async {
    _orders = await OrderManager.loadOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    // Filter orders for the scanned student ID
    int orderCount =
        _orders.where((order) => order.studentId == scannedBarcode).length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Existing profile information
            const Text(
              'Profile',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
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
                      size: 16.0,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    'Dept.: $dept, Intake: $intake, Section: $section',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25.0,
                horizontal: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        orderCount.toString(),
                        style: TextStyle(
                          fontSize: 18.0,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        'Orders',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        balance.toString(),
                        style: TextStyle(
                          fontSize: 18.0,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        'Balance',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: theme.primaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: theme.primaryColor,
                labelStyle: const TextStyle(fontSize: 20.0),
                unselectedLabelColor: Colors.black,
                tabs: const <Widget>[
                  Tab(text: 'Recent Orders'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Container(
                    child: ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        if (_orders[index].studentId == scannedBarcode) {
                          return ListTile(
                            title: Text(
                                'Order ID: ${_orders[index].timestamp.hashCode} - ${_orders[index].studentId}'),
                            subtitle:
                                Text('Total: BDT ${_orders[index].totalPrice}'),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
