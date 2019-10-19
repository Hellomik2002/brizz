import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'package:firebase_core/firebase_core.dart';

class ImageInput extends StatefulWidget {
  final Function upload;
  ImageInput({this.upload});
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState(upload: this.upload);
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;
  Function upload;

  _ImageInputState({this.upload});

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source,imageQuality: 70).then((File image) async {
      image = await FlutterExifRotation.rotateImage(path:image.path);
      setState(() {
        _imageFile = image;
        upload(_imageFile);
      });
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150.0,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text('Pick an Image'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(
            color: Theme.of(context).accentColor,
            width: 2,
          ),
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt),
              SizedBox(
                width: 5.0,
              ),
              Text('Add image')
            ],
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        _imageFile == null
            ? Text('Please pick a image')
            : Image.file(
                _imageFile,
                fit: BoxFit.cover,
                height: 300.0,
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.topCenter,
              ),
      ],
    );
  }
}
