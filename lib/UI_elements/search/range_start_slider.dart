import 'package:flutter/material.dart';
import 'package:brizz/scoped_model/connected_services.dart';
import 'package:scoped_model/scoped_model.dart';

class MyRatingRangeSlider extends StatefulWidget {
  final FilterModel model;
  MyRatingRangeSlider(this.model);

  _MyRatingRangeSliderState createState() => _MyRatingRangeSliderState();
}

class _MyRatingRangeSliderState extends State<MyRatingRangeSlider> {
  double maxRange = 10;
  final _formKey = GlobalKey<FormState>();
  RangeValues _rangeValues = RangeValues(0, 1);
  TextEditingController startRange;
  TextEditingController endRange;
  @override
  void initState() {
    startRange = TextEditingController(
      text: '${widget.model.minRating.toInt()}',
    );
    endRange = TextEditingController(
      text: '${widget.model.maxRating.toInt()}',
    );
    double newStartValue = widget.model.minRating / maxRange;
    double newEndValue = widget.model.maxRating / maxRange;

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
                              setState(
                                () {
                                  print("hey");
                                  if (!_formKey.currentState.validate()) {
                                    return null;
                                  }
                                  double newStartValue =
                                      double.parse(newValue) / maxRange;
                                  double newEndValue = _rangeValues.end;
                                  print(newStartValue);
                                  print(newEndValue);
                                  _rangeValues =
                                      RangeValues(newStartValue, newEndValue);
                                  model.setRating(double.parse(startRange.text),
                                      double.parse(endRange.text));
                                },
                              );
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
                              if (double.parse(value) <
                                  double.parse(startRange.text)) {
                                return 'Такого интервала не существует';
                              }
                            },
                            onChanged: (String newValue) {
                              setState(
                                () {
                                  // End
                                  print("Hey");
                                  if (!_formKey.currentState.validate()) {
                                    return null;
                                  }
                                  double newStartValue = _rangeValues.start;
                                  double newEndValue =
                                      double.parse(newValue) / maxRange;
                                  print(newStartValue);
                                  print(newEndValue);
                                  _rangeValues =
                                      RangeValues(newStartValue, newEndValue);
                                  model.setRating(double.parse(startRange.text),
                                      double.parse(endRange.text));
                                },
                              );
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
                        startRange.text =
                            (newValues.start * maxRange).toInt().toString();
                        endRange.text =
                            (newValues.end * maxRange).toInt().toString();
                        _rangeValues = newValues;
                        _formKey.currentState.validate();
                        model.setRating(double.parse(startRange.text),
                            double.parse(endRange.text));
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
