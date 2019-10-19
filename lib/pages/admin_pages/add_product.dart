import 'dart:io';

import 'package:brizz/providers/services.dart';
import 'package:brizz/widgets/column_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:brizz/widgets/form_input/image.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image/image.dart' as prefix0;

class ProductAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductAddPageState();
  }
}

class _ProductAddPageState extends State<ProductAddPage> {
  String title = "";
  double rating = 0;
  String detailDesc = "";
  String description = "";
  String address = "";
  double price = 0;
  File uploadPhoto;
  int rotates = 0;
  List<String> phoneNumbers = [''];
  List<Asset> uploadPhotoDes = [];
  bool _isloading = false;

  void upload(File value) {
    uploadPhoto = value;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildAddressTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Адрес'),
      onSaved: (String value) {
        address = value;
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'Поле не должно быть пустое';
        }
      },
    );
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Заголовок'),
      onSaved: (String value) {
        print(value);
        title = value;
      },
      validator: (String value) {
        if (value.length > 20 || value.isEmpty) {
          return 'Заголовок не должен пустовать и не \nдолжен хранить лишь название(меньше 20 букв)';
        }
      },
    );
  }

  Widget _buildDetailDescTextField() {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(labelText: 'Детальное Описание'),
      onSaved: (String value) {
        print(value);
        detailDesc = value;
      },
      validator: (String value) {
        if (value.length <= 50) {
          return 'Длина должна превышать 50 символов';
        }
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      maxLines: 2,
      decoration: InputDecoration(labelText: 'Описание'),
      onSaved: (String value) {
        print(value);
        description = value;
      },
      validator: (String value) {
        if (value.length < 15) {
          return 'Описание должно быть больше 15 символов';
        }
      },
    );
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Цена от'),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Исправьте цену';
        }
      },
      onSaved: (String value) {
        price = double.parse(value);
      },
    );
  }

  Widget _buildRateTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Рейтинг'),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value) ||
            int.parse(value) > 10 ||
            int.parse(value) < 0) {
          return 'Рейтинг может быть лишь между 0 и 10';
        }
      },
      onSaved: (String value) {
        rating = double.parse(value);
      },
    );
  }

  Widget _buildPhoneNumberTextField() {
    return ColumnBuilder(
      itemCount: phoneNumbers.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: 'Номер телефона'),
            validator: (String value) {
              if (value.isEmpty) {
                return "Напишите номер";
              }
            },
            onSaved: (String value) {
              phoneNumbers[index] = value;
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.remove_circle),
            onPressed: () {
              setState(() {
                phoneNumbers.removeAt(index);
              });
            },
          ),
        );
      },
    );
    () {
      // return ListView.builder(
      //   itemCount: phoneNumbers.length + 1,
      //   itemBuilder: (BuildContext context, int index) {
      //     return TextFormField(
      //       focusNode: _phoneNumberFocusNode,
      //       keyboardType: TextInputType.phone,
      //       decoration: InputDecoration(labelText: 'Номер телефона'),
      //       validator: (String value) {},
      //       onChanged: (String value){
      //         if (index == phoneNumbers.length) {
      //           phoneNumbers.add(value);
      //         }
      //         phoneNumbers[index] = value;
      //         phoneNumbers.removeWhere((String value){
      //           if (value.length == 0){
      //             return true;
      //           }
      //           return false;
      //         });
      //       },

      //     );
      //   },
      // );
    };
  }

  Future<Null> _submitForm(ModelServices model) async {
    if (!_formKey.currentState.validate()) {
      return null;
    }
    _formKey.currentState.save();

    await model.addProduct(
      title: title,
      rating: rating,
      description: description,
      address: address,
      price: price,
      phoneNumber: phoneNumbers,
      fileImage: uploadPhoto,
      detailDescription: detailDesc,
      detailFiles: uploadPhotoDes,
    );

    //
  }

  Widget _submitButton(ModelServices model) {
    return RaisedButton(
      color: Colors.deepOrange,
      child: Text('Сохранить'),
      textColor: Colors.white,
      onPressed: () => _submitForm(model),
    );
  }

  void _getImage(BuildContext context, ImageSource source) {
    MultiImagePicker.pickImages(enableCamera: true, maxImages: 30)
        .then((List<Asset> assets) async {
      uploadPhotoDes = assets;
    });
  }

  Widget _buildImagesLoaded() {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
      ),
      height: deviceWidth / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 2,
          style: BorderStyle.solid,
          color: Colors.indigo,
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: uploadPhotoDes.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == uploadPhotoDes.length) {
            return Center(
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.indigo[500],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 150.0,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text('Выберите Картину'),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              FlatButton(
                                textColor: Theme.of(context).primaryColor,
                                child: Text('Use Galery'),
                                onPressed: () {
                                  _getImage(context, ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }
          return Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border:
                  Border.all(color: Theme.of(context).accentColor, width: 2),
            ),
            child: GestureDetector(
              onDoubleTap: () {
                setState(() {
                  uploadPhotoDes.removeAt(index);
                });
              },
              onTap: () async {},
              child: Container(
                child: AssetView(uploadPhotoDes[index])
                // Image.memory(
                //   uploadPhotoDes[index].requestThumbnail(uploadPhotoDes[index].originalWidth, uploadPhotoDes[index].originalHeight),
                // )
                ,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (
        BuildContext context,
        ModelServices model,
        Widget child,
      ) {
        return model.isloading
            ? Center(child: CircularProgressIndicator())
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        //padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                        children: <Widget>[
                          _buildTitleTextField(),
                          _buildDescriptionTextField(),
                          _buildDetailDescTextField(),
                          _buildPriceTextField(),
                          Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: <Widget>[
                                _buildPhoneNumberTextField(),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    icon: Icon(Icons.add_call),
                                    onPressed: () {
                                      setState(() {
                                        phoneNumbers.add('');
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          _buildAddressTextField(),
                          _buildRateTextField(),
                          ImageInput(upload: this.upload),
                          _buildImagesLoaded(),
                          _submitButton(model),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }
}

class AssetView extends StatefulWidget {
  final Asset _asset;

  AssetView(
    this._asset, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AssetState(this._asset);
}

class AssetState extends State<AssetView> {
  Asset _asset;
  ByteData thumData;
  AssetState(this._asset);

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    thumData = await this._asset.requestThumbnail(
        this._asset.originalWidth, this._asset.originalHeight,
        quality: 70);

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (null != thumData) {
      return Image.memory(
        thumData.buffer.asUint8List(),
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
