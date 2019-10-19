import 'package:brizz/widgets/column_builder.dart';
import 'package:flutter/material.dart';

import 'package:brizz/UI_elements/all_img.dart' as prefix1;
import 'package:brizz/UI_elements/build_star.dart' as prefix0;
import 'package:provider/provider.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:brizz/providers/services.dart';
// import '../scoped_model/connected_services.dart';

class DetailContent extends StatelessWidget {
  List<String> url_list = [];
  int index;
  DetailContent(this.index);

  Widget _buildMainContent(
      BuildContext context, ModelServices model, int index) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListView(
        children: <Widget>[
          Container(
            height: deviceHeight / 2 * 0.9,
            child: prefix1.AllImages(model.services[index].details.urls_images,
                model.services[index].urlImage),
          ),
          SizedBox(
            height: 20.0,
            child: Center(
              child: Container(
                  margin: EdgeInsetsDirectional.only(start: 2.0, end: 2.0),
                  height: 1.0,
                  color: Colors.black),
            ),
          ),
          Container(
            height: deviceHeight * 0.1, //title
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          model.services[index].title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          prefix0.BuildStarRaiting(
                            model.services[index].rating,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).accentColor,
                            ),
                            padding: EdgeInsets.all(5.0),
                            child: Center(
                              child: Text(
                                model.services[index].rating.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  model.services[index].details.description,
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ), // Row()
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.favorite_border),
                      iconSize: 30,
                      color: Colors.red,
                      onPressed: () {},
                    ),
                    SizedBox(width: 10.0),
                    IconButton(
                      icon: Icon(Icons.phone),
                      iconSize: 30,
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ConstrainedBox(
                                constraints: BoxConstraints(minHeight: deviceHeight *0.1,maxHeight: deviceHeight *0.2),
                                child: ListView.builder(
                                  itemCount:
                                      model.services[index].phoneNumber.length,
                                  itemBuilder: (BuildContext context, int ind) {
                                    return OutlineButton(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Color.fromRGBO(1, 1, 1, 0)),
                                      onPressed: () async {
                                        String localnumber = '+7' +
                                            model.services[index]
                                                .phoneNumber[ind];
                                        if (await canLaunch(
                                            "tel:$localnumber")) {
                                          await launch("tel:$localnumber");
                                        } else {
                                          throw 'Could not launch $localnumber';
                                        }
                                      },
                                      child: FittedBox(
                                        child: Text(
                                          '+7${model.services[index].phoneNumber[ind]}',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 20
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            });
                      },
                    ),
                    SizedBox(width: 10.0),
                    IconButton(
                      icon: Icon(Icons.share),
                      iconSize: 30,
                      onPressed: () {
                        Share.share(
                            'https://play.google.com/store/apps/details?id=com.hellomik.brizz');
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'От ' +
                          model.services[index].price.toInt().toString() +
                          ' KZT',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              )
            ],
          ),
          () {
            // return Expanded(
            //   flex: 1,
            //   child: Column(
            //     children: <Widget>[
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Center(
            //           child: Text(
            //             model.services[index].details.description,
            //             style: TextStyle(fontSize: 16),
            //           ),
            //         ),
            //       ),
            //       Container(
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: <Widget>[
            //             Padding(
            //               padding: const EdgeInsets.only(left: 20.0),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: <Widget>[
            //                   IconButton(
            //                     icon: Icon(Icons.favorite_border),
            //                     iconSize: 30,
            //                     color: Colors.red,
            //                     onPressed: () {},
            //                   ),
            //                   SizedBox(width: 10.0),
            //                   IconButton(
            //                     icon: Icon(Icons.phone),
            //                     iconSize: 30,
            //                     color: Theme.of(context).accentColor,
            //                     onPressed: () {
            //                       showModalBottomSheet(
            //                           context: context,
            //                           builder: (BuildContext context) {
            //                             return ConstrainedBox(
            //                               constraints:
            //                                   BoxConstraints(minHeight: 100),
            //                               child: Row(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.center,
            //                                 children: <Widget>[
            //                                   OutlineButton(
            //                                     borderSide: BorderSide(
            //                                         width: 1,
            //                                         color: Color.fromRGBO(
            //                                             1, 1, 1, 0)),
            //                                     onPressed: () async {
            //                                       String localnumber = '+7' +
            //                                           model.services[index]
            //                                               .phoneNumber;
            //                                       if (await canLaunch(
            //                                           "tel:$localnumber")) {
            //                                         await launch(
            //                                             "tel:$localnumber");
            //                                       } else {
            //                                         throw 'Could not launch $localnumber';
            //                                       }
            //                                     },
            //                                     child: Text(
            //                                       '+7${model.services[index].phoneNumber}',
            //                                       style: TextStyle(
            //                                         color: Colors.blue,
            //                                         fontSize: 24,
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ],
            //                               ),
            //                             );
            //                           });
            //                     },
            //                   ),
            //                   SizedBox(width: 10.0),
            //                   IconButton(
            //                     icon: Icon(Icons.share),
            //                     iconSize: 30,
            //                     onPressed: () {
            //                       Share.share(
            //                           'https://play.google.com/store/apps/details?id=com.hellomik.brizz');
            //                     },
            //                     color: Theme.of(context).primaryColor,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(right: 10.0),
            //               child: Row(
            //                 children: <Widget>[
            //                   Text(
            //                     'От ' +
            //                         model.services[index].price
            //                             .toInt()
            //                             .toString() +
            //                         ' KZT',
            //                     style: TextStyle(fontSize: 17),
            //                   ),
            //                 ],
            //               ),
            //             )

            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // );

            return Container();
          }()
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
          return _buildMainContent(context, model, index);
        },
      ),
    );
  }
}
