import 'package:flutter/material.dart';
import 'package:brizz/pages/detail_page.dart';
import 'package:provider/provider.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:brizz/providers/services.dart';

class ProductCardIndexed extends StatefulWidget {
  final List<int> productsListIndex;
  ProductCardIndexed(this.productsListIndex);
  @override
  State<StatefulWidget> createState() {
    return _ProductCardIndexedState();
  }
}

class _ProductCardIndexedState extends State<ProductCardIndexed> {
  List<Widget> _buildStars(double rate) {
    int r1 = (rate / 2).toInt();
    double r2 = rate / 2 - r1;
    print(r1);
    print(r2);
    List<Widget> stars = [];
    for (int i = 1; i <= 5; ++i) {
      if (i <= r1) {
        stars.add(Icon(
          Icons.star,
          size: 20,
        ));
      } else if (i - r1 <= 1 && r2 >= 0.5) {
        stars.add(Icon(Icons.star_half, size: 20));
      } else {
        stars.add(Icon(Icons.star_border, size: 20));
      }
    }
    return stars;
  }

  Widget _secondPart(BuildContext context, ModelServices model, int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  model
                                      .services[widget.productsListIndex[index]]
                                      .title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: _buildStars(model
                                      .services[widget.productsListIndex[index]]
                                      .rating),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Icon(
                      Icons.favorite_border,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Theme.of(context).accentColor,
                          ),
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            model.services[widget.productsListIndex[index]]
                                .rating
                                .toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            child: Text(
                              model.services[widget.productsListIndex[index]]
                                  .description
                                  .toString(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.location_on),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            child: Text(model
                                .services[widget.productsListIndex[index]]
                                .address),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    // Within the `FirstRoute` widget
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailPage(widget.productsListIndex[index])),
                      );
                    },
                    child: Text(
                      'Детали',
                      style: TextStyle(
                          fontSize: 15, color: Theme.of(context).accentColor),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text('KZ | '),
                      Text(
                          "${model.services[widget.productsListIndex[index]].price.toInt()} tg")
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Consumer<ModelServices>(
        builder: (BuildContext context, ModelServices model, Widget child) {
          return RefreshIndicator(
            onRefresh: model.fetchProducts,
            child: ListView.builder(
              itemCount: widget.productsListIndex.length,
              itemBuilder: (BuildContext context, int index) => Card(
                //widget.productsListIndex[index]
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(widget.productsListIndex[index])),
                    );
                  },
                  child: Container(
                    height: 260,
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: CachedNetworkImage(
                            imageUrl: model.services[index].urlImage,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                            ),
                          ),
                          width: 190,
                          decoration: BoxDecoration(
                            color: const Color(0xff7c94b6),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            child: _secondPart(context, model, index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
