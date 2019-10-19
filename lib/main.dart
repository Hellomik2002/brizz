import 'package:brizz/helpers/custom_route.dart';
import 'package:brizz/providers/auth.dart';
import 'package:brizz/providers/services.dart';
import 'package:brizz/screens/admin_screen.dart';
import 'package:brizz/screens/auth_screen.dart';
import 'package:brizz/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:permission/permission.dart';

import 'package:flutter/rendering.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final ModelServices modelServices = ModelServices();

  @override
  void initState() {
    modelServices.fetchProducts();
    askPermission();
    super.initState();
  }

  askPermission() async {
    await Permission.requestPermissions([PermissionName.Storage
    , PermissionName.Camera
    ]);
  }

  @override
  Widget build(BuildContext context) {
    //Services().fetchProducts();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: modelServices,
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData( 
            brightness: Brightness.light,
            primarySwatch: Colors.indigo,
            accentColor: Colors.indigoAccent,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: ProductsScreen(),
          // auth.isAuth
          //     ? ProductsScreen()
          //     : FutureBuilder(
          //         future: auth.tryAutoLogin(),
          //         builder: (ctx, authResultSnapshot) {
          //           return authResultSnapshot.connectionState ==
          //                   ConnectionState.waiting
          //               ? Scaffold(
          //                   body: Center(child: CircularProgressIndicator()))
          //               : AuthScreen();
          //         })
                  // ,
          routes: {
            ProductsScreen.routeName: (BuildContext context) =>
                ProductsScreen(),
            AdminScreen.routeName: (BuildContext context) => AdminScreen(),
          },
        ),
      ),
    );
  }
}
