import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:brizz/pages/edit/update_service.dart';

import 'package:brizz/providers/services.dart';
import 'package:provider/provider.dart';

class ProductsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductsListState();
  }
}

class _ProductsListState extends State<ProductsList> {
  Widget _buildEditButton(
      BuildContext context, int index, ModelServices model) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        //model.check(true);
        await model.deleteProduct(id: model.services[index].id);
        // await FirebaseDatabase.instance
        //     .reference()
        //     .child('recent')
        //     .child('id')
        //     .child(model.services[index].id)
        //     .remove();
        
        model.services.removeAt(index);
        
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Consumer<ModelServices>(
        builder: (BuildContext context, ModelServices model, Widget child) {
          return model.isloading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: model.services.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return UpdatePage(
                            currentService: model.services[index],
                          );
                        }));
                      },
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(model.services[index].urlImage),
                            ),
                            title: Text(model.services[index].title),
                            subtitle: Text(
                                '\$${model.services[index].price.toString()}'),
                            trailing: _buildEditButton(context, index, model),
                          ),
                          Divider()
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
