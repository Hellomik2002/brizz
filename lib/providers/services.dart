import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../models/Service.dart';

class ModelServices extends ChangeNotifier {
  List<Service> services = [];
  bool isloading = false;
  Future<Null> fetchProducts() async {
    isloading = true;
    notifyListeners();
    services = [];
    var services1 =
        await Firestore.instance.collection('services').getDocuments();
    services1.documents.forEach((DocumentSnapshot documentSnapshot) {
      services.add(Service(
          id: documentSnapshot.documentID,
          title: documentSnapshot.data['title'],
          rating: documentSnapshot.data['rating'] * 1.0,
          description: documentSnapshot.data['description'],
          address: documentSnapshot.data['address'],
          price: documentSnapshot.data['price'] * 1.0,
          urlImage: documentSnapshot.data['urlImage'],
          details: DetailService(
              urls_images:
                  documentSnapshot.data['details']['urls_images'] != null
                      ? (documentSnapshot.data['details']['urls_images']
                              as List<dynamic>)
                          .map((dynamic obj) {
                          return obj.toString();
                        }).toList()
                      : [],
              description: documentSnapshot.data['details']['description']),
          phoneNumber: 
          documentSnapshot.data['phoneNumber'] != null
                      ? (documentSnapshot.data['phoneNumber']
                              as List<dynamic>)
                          .map((dynamic obj) {
                          return obj.toString();
                        }).toList()
                      : []
          ));
    });
    isloading = false;
    notifyListeners();
  }

  Future<Null> updateProduct(Service oldService, Service newService) async {
    isloading = true;
    notifyListeners();
    await Firestore.instance
        .collection('services')
        .document(oldService.id)
        .updateData({
      'id': newService.id,
      'title': newService.title,
      'rating': newService.rating,
      'description': newService.description,
      'address': newService.address,
      'price': newService.price,
      'urlImage': newService.urlImage,
      'phoneNumber': newService.phoneNumber,
      'details': {
        'urls_images': newService.details.urls_images,
        'description': newService.details.description,
      },
    });
    oldService = newService;
    isloading = false;
    notifyListeners();
  }

  Future<Null> addProduct({
    @required String title,
    @required double rating,
    @required String description,
    @required String address,
    @required double price,
    @required File fileImage,
    @required List<String> phoneNumber,
    @required String detailDescription,
    @required List<Asset> detailFiles,
  }) async {
    isloading = true;
    notifyListeners();
    // final custom_id = Firestore.instance.collection('services').//;
    String idCodeTitle = DateTime.now().toString();
    var task = await FirebaseStorage.instance
        .ref()
        .child(idCodeTitle)
        .putFile(fileImage)
        .onComplete;
    final String urlImage = await task.ref.getDownloadURL();
    List<String> urlImages = [];
    for (int i = 0; i < detailFiles.length; ++i) {
      final fileValue = detailFiles[i];
      final byteValue = await fileValue.requestOriginal(quality: 70);
      var task1 = await FirebaseStorage.instance
          .ref()
          .child(idCodeTitle + '/${i}')
          .putData(byteValue.buffer.asUint8List())
          .onComplete;
      urlImages.add(await task1.ref.getDownloadURL());
    }
    var uploadtask = await Firestore.instance.collection('services').add({
      'title': title,
      'rating': rating,
      'description': description,
      'address': address,
      'price': price,
      'urlImage': urlImage,
      'phoneNumber': phoneNumber,
      'details': {
        'urls_images': urlImages,
        'description': detailDescription,
      },
    });
    isloading = false;
    notifyListeners();
  }
  
  Future<Null> deleteProduct({String id}) async{
    isloading = true;
    notifyListeners();
    await Firestore.instance.collection('services').document(id).delete();
    isloading = false;
    notifyListeners();
  }
  //
}
