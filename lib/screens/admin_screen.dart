import 'package:brizz/pages/admin_pages/ProductsList.dart';
import 'package:brizz/pages/admin_pages/add_product.dart';
import 'package:brizz/widgets/drawer.dart';
import 'package:flutter/material.dart';

class  AdminScreen extends StatefulWidget {
  static const routeName = '/admin';

  @override
  State<StatefulWidget> createState() {
    return _AdminScreenState();
  }
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Admin Page'),
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          children: <Widget>[
            ProductAddPage(),
            ProductsList(),
          ],
        ),
      ),
    );
  }
}
