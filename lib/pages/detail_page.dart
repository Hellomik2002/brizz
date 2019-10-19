import 'package:flutter/material.dart';
import 'package:brizz/UI_elements/detail_content.dart';

class DetailPage extends StatelessWidget {
  int index;
  DetailPage(this.index);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Product Details'),
        ),
        body: DetailContent(index),
      );
  }
}


