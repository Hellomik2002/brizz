import 'package:brizz/providers/services.dart';
import 'package:flutter/material.dart';
import 'package:brizz/UI_elements/search/range_slider.dart';
import 'package:brizz/UI_elements/search/range_start_slider.dart';
import 'package:brizz/models/Service.dart';
import 'package:brizz/scoped_model/connected_services.dart';
import 'package:brizz/UI_elements/search/indexedProductList.dart';
import 'package:scoped_model/scoped_model.dart';

bool isitOke(FilterModel model, Service service) {
  if (model.minRating <= service.rating &&
      service.rating <= model.maxRating &&
      model.minPrice <= service.price &&
      service.price <= model.maxPrice) {
    return true;
  }
  return false;
}

class SearchPage extends SearchDelegate {
  final ModelServices model;
  FilterModel _filterModel = FilterModel();
  SearchPage(this.model);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          this.query = '';
        },
      ),
      IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              // final double deviceHeight = MediaQuery.of(context).size.height;
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                      constraints: BoxConstraints(),
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.all(10.0),
                      child: ScopedModel<FilterModel>(
                        model: _filterModel,
                        child: Column(children: <Widget>[
                           MyRangeSlider(_filterModel),
                          MyRatingRangeSlider(_filterModel),
                        ]),
                      ),
                    )
                  ,
              );
            },
          );
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<int> indexes = [];
    for (int i = 0; i < model.services.length; ++i) {
      if (model.services[i].title.substring(0, query.length) == query &&
          isitOke(_filterModel, model.services[i])) {
        indexes.add(i);
      } else if (isitOke(_filterModel, model.services[i]) &&
          query.length == 0) {
        indexes.add(i);
      }
    }
    return indexes.length != 0 ? ProductCardIndexed(indexes) : Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Container();
  }
}
