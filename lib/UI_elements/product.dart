import 'package:brizz/providers/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/detail_page.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCardState();
  }
}

class _ProductCardState extends State<ProductCard> {
  bool loading = true;

  List<Map<String, dynamic>> _products = [];
  List<Widget> _buildStars(double rate) {
    int r1 = (rate / 2).toInt();
    double r2 = rate / 2 - r1;

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
                                  model.services[index].title,
                                  style: TextStyle(
                                    fontSize: ((() {
                                              return model
                                                  .services[index].title.length;
                                            }()) <
                                            15)
                                        ? 18
                                        : 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children:
                                      _buildStars(model.services[index].rating),
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
                            model.services[index].rating.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            child: Text(
                              model.services[index].description.toString(),
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
                            child: Text(model.services[index].address),
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
                            builder: (context) => DetailPage(index)),
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
                      Text('От '),
                      Text("${model.services[index].price.toInt()} KZT")
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
    ModelServices model = Provider.of<ModelServices>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RefreshIndicator(
          onRefresh: model.fetchProducts,
          child: ListView.builder(
            itemCount: model.services.length,
            itemBuilder: (BuildContext context, int index) => Card(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailPage(index)),
                  );
                },
                child: Container(
                  height: 230,
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: CachedNetworkImage(
                          imageUrl: model.services[index].urlImage,
                          fit: BoxFit.cover,
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
        ),
      ),
    );
  }
}
