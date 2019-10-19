import 'package:brizz/providers/services.dart';
import 'package:brizz/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:brizz/pages/search_page/search_page.dart';
import 'package:provider/provider.dart';
import '../UI_elements/product.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products';
  @override
  State<StatefulWidget> createState() {
    return _ProductsScreenState();
  }
}

class _ProductsScreenState extends State<ProductsScreen> {
  ModelServices model;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<ModelServices>(context);
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Brizz'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchPage(model));
            },
          )
        ],
      ),
      body: model.isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductCard(),
    );
  }
}
