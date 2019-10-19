import 'package:brizz/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth.dart';

import 'package:brizz/screens/admin_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    Auth userInfo = Provider.of<Auth>(context, listen: false);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              userInfo.status == Status.Admin
                  ? ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Manage Products'),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, AdminScreen.routeName);
                      },
                    )
                  : Container(),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Product List'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, ProductsScreen.routeName);
                },
              ),
            ],
          ),
          Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.feedback),
                title: Text('Обратная связь'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Наши контакты"),
                          content: Container(
                            height: deviceHeight * 0.15,
                            child: Column(
                              children: <Widget>[
                                OutlineButton(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromRGBO(1, 1, 1, 0)),
                                  onPressed: () async {
                                    String localnumber = '+77778204455';
                                    if (await canLaunch("tel:$localnumber")) {
                                      await launch("tel:$localnumber");
                                    } else {
                                      throw 'Could not launch $localnumber';
                                    }
                                  },
                                  child: Text(
                                    '+77778204455',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                OutlineButton(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromRGBO(1, 1, 1, 0)),
                                  onPressed: () async {
                                    String localnumber = '+77017788114';
                                    if (await canLaunch("tel:$localnumber")) {
                                      await launch("tel:$localnumber");
                                    } else {
                                      throw 'Could not launch $localnumber';
                                    }
                                  },
                                  child: Text(
                                    '+77778204455',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Ok"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Выйти'),
                onTap: () {
                  userInfo.logout();
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
