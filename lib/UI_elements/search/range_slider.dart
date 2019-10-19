import 'dart:math';

import 'package:flutter/material.dart';
import 'package:brizz/scoped_model/connected_services.dart';
import 'package:scoped_model/scoped_model.dart';

class MyRangeSlider extends StatefulWidget {
  FilterModel model;
  MyRangeSlider(this.model);

  _MyRangeSliderState createState() => _MyRangeSliderState();
}

class _MyRangeSliderState extends State<MyRangeSlider> {
  double maxRange = 10000000;
  final _formKey = GlobalKey<FormState>();
  RangeValues _rangeValues = RangeValues(0, 1);
  TextEditingController startRange = TextEditingController(
    text: '0',
  );
  TextEditingController endRange = TextEditingController(
    text: '10000000',
  );

  @override
  void initState() {
    startRange = TextEditingController(
      text: '${widget.model.minPrice.toInt()}',
    );
    endRange = TextEditingController(
      text: '${widget.model.maxPrice.toInt()}',
    );
    double newStartValue = pow(widget.model.minPrice / maxRange, 1 / 4);
    
    double newEndValue = pow(widget.model.maxPrice / maxRange, 1 / 4);

    _rangeValues = RangeValues(newStartValue, newEndValue);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FilterModel>(
      builder: (BuildContext context, Widget child, FilterModel model) {
        return Form(
          key: _formKey,
          child: Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            controller: startRange,
                            onChanged: (String newValue) {
                              // Start
                              setState(() {
                                if (!_formKey.currentState.validate()) {
                                  return null;
                                }
                                double newStartValue = pow(
                                    double.parse(newValue) / maxRange, 1 / 4);
                                double newEndValue = _rangeValues.end;

                                _rangeValues =
                                    RangeValues(newStartValue, newEndValue);
                                model.setPrice(double.parse(startRange.text),
                                    double.parse(endRange.text));
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            controller: endRange,
                            validator: (String value) {
                              if (double.parse(value) <=
                                  double.parse(startRange.text)) {
                                return 'Такого интервала не существует';
                              }
                            },
                            onChanged: (String newValue) {
                              setState(() {
                                // End

                                if (!_formKey.currentState.validate()) {
                                  return null;
                                }
                                double newStartValue = _rangeValues.start;
                                double newEndValue = pow(
                                    double.parse(newValue) / maxRange, 1 / 4);

                                _rangeValues =
                                    RangeValues(newStartValue, newEndValue);
                                model.setPrice(double.parse(startRange.text),
                                    double.parse(endRange.text));
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RangeSlider(
                    values: _rangeValues,
                    onChanged: (RangeValues newValues) {
                      setState(() {
                        startRange.text = (pow(newValues.start, 4) * maxRange)
                            .toInt()
                            .toString();
                        endRange.text = (pow(newValues.end, 4) * maxRange)
                            .toInt()
                            .toString();
                        _rangeValues = newValues;
                        model.setPrice(double.parse(startRange.text),
                            double.parse(endRange.text));
                        _formKey.currentState.validate();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
