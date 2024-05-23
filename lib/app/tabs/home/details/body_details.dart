import 'package:cashless_cafe/app/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:cashless_cafe/app/components/custom_header.dart';

Widget iconBadge({required IconData icon, required Color iconColor}) {
  return Container(
    padding: const EdgeInsets.all(4.0),
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4.0,
          offset: Offset(3.0, 3.0),
        )
      ],
      shape: BoxShape.circle,
      color: Colors.white,
    ),
    child: Icon(
      icon,
      size: 20.0,
      color: iconColor,
    ),
  );
}

Widget detailsTab() {
  return Container(
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut enim leo. In sagittis velit nibh. Morbi sollicitudin lorem vitae nisi iaculis,sit amet suscipit orci mollis. Ut dictum lectus eget diam vestibulum, at eleifend felis mattis. Sed molestie congue magna at venenatis. In mollis felis ut consectetur consequat.',
          ),
        ),
      ],
    ),
  );
}

class BodyDetails extends StatefulWidget {
  @override
  _BodyDetailsState createState() => _BodyDetailsState();
}

class _BodyDetailsState extends State<BodyDetails>
    with TickerProviderStateMixin {
  int quantity = 0;
  int screenTab = 0;
  late TabController _tabController;

  @override
  void initState() {
    this._tabController = TabController(
      initialIndex: 0,
      length: 1,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map screenArguments =
        (ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>);
    Map product = screenArguments['product'];
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    void addToCart() {
      quantity++;
      setState(() {
        cartItems[product['id']] = (cartItems[product['id']] ?? 0) + quantity;
      });
    }

    void removeFromCart() {
      quantity--;
      setState(() {
        cartItems[product['id']] = (cartItems[product['id']] ?? 0) - quantity;
      });
    }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CustomHeader(
            title: '',
            quantity: this.quantity,
            internalScreen: true,
          ),
          Container(
            margin: EdgeInsets.only(
              top: size.width * 0.55,
              left: 50.0,
              right: 50.0,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 65.0, bottom: 10.0, top: 45.0),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 50.0),
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              width: size.width - 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            product['name'],
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          Text(
                            '\BDT ${product['price']}',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: removeFromCart,
                          child: const Icon(
                            Icons.remove,
                            size: 30.0,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 8.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: GestureDetector(
                            onTap: addToCart,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 8.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 0.0,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Text(
                                'Add Item',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: addToCart,
                          child: Icon(
                            Icons.add,
                            size: 30.0,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TabBar(
                      controller: this._tabController,
                      labelColor: theme.primaryColor,
                      labelPadding: const EdgeInsets.all(0),
                      indicatorColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontSize: 18.0,
                      ),
                      tabs: [
                        Container(
                          height: 25.0,
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'DETAILES',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: this._tabController,
                      children: [
                        detailsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
