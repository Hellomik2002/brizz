import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class AllImages extends StatelessWidget {
  List<String> url_list;
  String main_url;
  AllImages(this.url_list, this.main_url);

  Widget _buildAllImagesListView() {
    Widget imageList;
    if (url_list.length >= 0) {
      imageList = ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => Row(
          children: <Widget>[
            Container(
              height: double.infinity,
              child: Image.network(
                url_list[index],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
          ],
        ),
        itemCount: url_list.length,
      );
    } else {
      imageList = Center(child: Text('There is no any image'));
    }
    return imageList;
  }

  Widget _buildAllImagesPageview() {
    Widget imageList;
    imageList = PageView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: Container(
                height: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    imageUrl: main_url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        index = index - 1;
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Container(
              height: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: // url_list[index] 
                CachedNetworkImage(
                    imageUrl: url_list[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                    ),
                  ),
              ),
            ),
          ),
        );
      },
      itemCount: url_list.length + 1,
      controller: PageController(viewportFraction: 0.85),
    );

    return imageList;
  }

  @override
  Widget build(BuildContext context) {
    return _buildAllImagesPageview();
  }
}
