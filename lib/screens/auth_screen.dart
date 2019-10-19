import 'dart:io';

import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

enum AuthMode { Login, Signup }

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _heightTextForm = GlobalKey<FormFieldState>();
  AuthMode _authMode = AuthMode.Login;
  AnimationController _controller;
  Animation opacityAnimation;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _againPassword = TextEditingController();

  bool isLoading = false;
  Future<void> _submit() async {
    print('sdad');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Signup) {
        await Provider.of<Auth>(context, listen: false).signup(
          _email.text,
          _password.text,
        );
      } else {
        await Provider.of<Auth>(context, listen: false).login(
          _email.text,
          _password.text,
        );
      }
    } on HttpException catch (err) {
      var errorMessage = 'Authentication failed';
      if (err.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Пароль или логин не совпадают';
      } else if (err.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'E-mail не поддерживается';
      } else if (err.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Пароль слишком слабый';
      } else if (err.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Пароль или логин не совпадают';
      } else if (err.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Недействительный пароль';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Something went wrong';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _email.dispose();
    _password.dispose();
    _againPassword.dispose();

    super.dispose();
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        validator: (String value) {
          if (value.isEmpty || !value.contains('@')) {
            return 'Напишите свою почту';
          }
          for (int i = 0; i < value.length; ++i) {
            if (value[i] == ' ') {
              return 'Уберите пробелы';
            }
          }
        },
        decoration: InputDecoration(
          labelText: "E-Mail",
          icon: Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (String value) {
          if (value.length < 6) {
            return 'Пароль не должен быть меньше 6';
          }
        },
        obscureText: true,
        controller: _password,
        key: _heightTextForm,
        decoration: InputDecoration(
          labelText: "Пароль",
          icon: Icon(Icons.lock),
        ),
      ),
    );
  }

  Widget _showAgainPasswordInput() {
    return AnimatedContainer(
      constraints: BoxConstraints(
        maxHeight: _authMode == AuthMode.Login
            ? 0.0
            : () {
                if (_heightTextForm.currentContext == null) {
                  return 0.0;
                }
                double localheight = (_heightTextForm.currentContext
                            .findRenderObject() as RenderBox)
                        .size
                        .height *
                    1.5;
                return localheight;
              }(),
      ),
      curve: Curves.linear,
      duration: Duration(milliseconds: 300),
      child: FadeTransition(
        opacity: opacityAnimation,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (String value) {
              if (value != _password.text && _authMode == AuthMode.Signup) {
                return 'Пароли не совпадают';
              }
            },
            obscureText: true,
            controller: _againPassword,
            decoration: InputDecoration(
              labelText: "Потвердите пароль",
              icon: Icon(Icons.lock_open),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showSecondaryButton() {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: deviceWidth * 0.6,
        child: FlatButton(
          onPressed: () {
            setState(() {
              if (_authMode == AuthMode.Login) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
              _authMode = _authMode == AuthMode.Login
                  ? AuthMode.Signup
                  : AuthMode.Login;
            });
          },
          child: FittedBox(
            child: _authMode == AuthMode.Login
                ? Text("Создать аккаунт")
                : Text("Войти"),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
              child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            key: _formKey,
            child: Container(
              child: ListView(
                children: <Widget>[
                  FittedBox(
                    child: Icon(
                      Icons.account_circle,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showAgainPasswordInput(),
                  if (isLoading == false)
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20.0,
                          ),
                          child: RaisedButton(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Theme.of(context).accentColor,
                            onPressed: _submit,
                            child: _authMode == AuthMode.Login
                                ? Text('Войти')
                                : Text('Зарегистрироваться '),
                          ),
                        ),
                        _showSecondaryButton(),
                      ],
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Произошла ошибка'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
