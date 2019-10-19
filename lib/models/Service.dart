
import 'package:flutter/material.dart';

class Service {
  final String title;
  final double rating;
  final String description;
  final String address;
  final double price;
  final String urlImage;
  final String id;
  final List<String> phoneNumber;
  final DetailService details;

  Service(
      {
        this.id,
      @required this.title,
       @required this.rating,
      this.description,
      this.address,
      this.price,
      this.urlImage,
      this.details,
      @required this.phoneNumber
      });
}

class DetailService{
  final List<String> urls_images;
  final String description;
  DetailService({this.urls_images, this.description});
}