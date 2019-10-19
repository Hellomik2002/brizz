import 'package:flutter/material.dart';
import 'package:brizz/models/Service.dart';
import 'package:provider/provider.dart';

import 'package:brizz/providers/services.dart';

class UpdatePage extends StatefulWidget {
  Service currentService;
  UpdatePage({
    Key key,
    @required this.currentService,
  }) : super(key: key);

  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleField = TextEditingController();
  Widget _buildTitleField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Заголовок'),
      validator: (String value) {
        if (value.length > 20 || value.isEmpty) {
          // return 'Заголовок не должен пустовать и не \nдолжен хранить лишь название(меньше 20 букв)';
        }
      },
      controller: _titleField,
    );
  }

  TextEditingController _descriptionField = TextEditingController();
  Widget _buildDescriptionField() {
    return TextFormField(
      maxLines: 2,
      decoration: InputDecoration(labelText: 'Описание'),
      validator: (String value) {
        if (value.length < 15) {
          // return 'Описание должно быть больше 15 символов';
        }
      },
      controller: _descriptionField,
    );
  }

  TextEditingController _detailDescField = TextEditingController();
  Widget _buildDetailDescTextField() {
    return TextFormField(
      maxLines: 4,
      controller: _detailDescField,
      decoration: InputDecoration(labelText: 'Детальное Описание'),
      validator: (String value) {
        if (value.length <= 50) {
          // return 'Длина должна превышать 50 символов';
        }
      },
    );
  }

  TextEditingController _priceField = TextEditingController();
  Widget _buildPriceTextField() {
    return TextFormField(
      controller: _priceField,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Цена от'),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          // return 'Исправьте цену';
        }
      },
    );
  }

  TextEditingController _phoneNumber = TextEditingController();
  Widget _buildPhoneNumberTextField() {
    return TextFormField(
      controller: _phoneNumber,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: 'Номер телефона'),
      validator: (String value) {},
    );
  }

  TextEditingController _addressTextField = TextEditingController();
  Widget _buildAddressTextField() {
    return TextFormField(
      controller: _addressTextField,
      decoration: InputDecoration(labelText: 'Адрес'),
      validator: (String value) {
        if (value.isEmpty) {
          // return 'Поле не должно быть пустое';
        }
      },
    );
  }

  TextEditingController _rateTextField = TextEditingController();
  Widget _buildRateTextField() {
    return TextFormField(
      controller: _rateTextField,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Рейтинг'),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value) ||
            int.parse(value) > 10 ||
            int.parse(value) < 0) {
          // return 'Рейтинг может быть лишь между 0 и 10';
        }
      },
    );
  }

  Widget _submitButton(ModelServices model) {
    return RaisedButton(
      color: Colors.deepOrange,
      child: Text('обновить'),
      textColor: Colors.white,
      onPressed: () async {
        if (!_formKey.currentState.validate()) {
          return null;
        }
        _formKey.currentState.save();
        Service oldService = widget.currentService;
        Service newService = Service(
          id: oldService.id,
          title: (_titleField.text != "") ? _titleField.text : oldService.title,
          phoneNumber: (_phoneNumber.text != "")
              ? _phoneNumber.text
              : oldService.phoneNumber,
          rating: (_rateTextField.text != "")
              ? double.parse(_rateTextField.text)
              : oldService.rating,
          description: (_descriptionField.text != "")
              ? _descriptionField.text
              : oldService.description,
          address: (_addressTextField.text != "")
              ? _addressTextField.text
              : oldService.address,
          price: (_priceField.text != "")
              ? double.parse(_priceField.text)
              : oldService.price,
          details: oldService.details,
          urlImage: oldService.urlImage
        );
        await model.updateProduct(oldService, newService);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ModelServices>(
        builder: (BuildContext context,ModelServices model, Widget child) {
          return model.isloading
              ? Center(child: CircularProgressIndicator())
              : GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          _buildTitleField(),
                          _buildDescriptionField(),
                          _buildDetailDescTextField(),
                          _buildPriceTextField(),
                          _buildPhoneNumberTextField(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _buildAddressTextField(),
                          _buildRateTextField(),
                          _submitButton(model),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
