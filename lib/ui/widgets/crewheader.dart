import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/global.dart' as global;

class CrewHeader extends StatefulWidget {
  @override
  _CrewHeaderState createState() => _CrewHeaderState();
}

class _CrewHeaderState extends State<CrewHeader>{

  PickedFile _photo;
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 25,
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(.3), BlendMode.srcOver),
                  image: global.currentCrew.img == null
                      ? NetworkImage("https://cdn.pixabay.com/photo/2016/02/13/13/11/cuba-1197800_960_720.jpg",)
                      : global.currentCrew.img
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(3.0),
                        decoration:
                            BoxDecoration(border: null, shape: BoxShape.circle),
                        child: Icon(
                          Icons.directions_car_outlined,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 9.0,
                      ),
                      Text(
                        global.currentCrew.car + ' #' + global.currentCrew.number.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .apply(color: Colors.white, fontWeightDelta: 2),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                onPressed: () {
                  _pickPhotoUploadMode(context);
                  },
                child: Icon(
                  Icons.photo_camera_outlined,
                  size: 23.0,
                ),
                shape: CircleBorder(),
                mini: true,
                backgroundColor: Colors.black.withOpacity(0.20),
              ))
        ],
      ),
    );
  }

  Future _photoFromCamera() async {
    PickedFile photo = await imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 50
    );

    _photo = photo;
    await sendFileToDjango(_photo);
    await getCrewPhoto();
    setState(() {});
  }

  Future _photoFromGallery() async {
    PickedFile photo = await  imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    _photo = photo;
    await sendFileToDjango(_photo);
    await getCrewPhoto();
    setState(() {});
  }

  void _pickPhotoUploadMode(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _photoFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _photoFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<Map<String, dynamic>> sendFileToDjango(PickedFile f) async {
    String endPoint = 'http://192.168.0.13:8080/api/photo-upload/' + global.currentCrew.id.toString() + '/';
    Map<String, dynamic> data = {};
    File file  = File(f.path);
    String base64file = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;
    data['name']=fileName;
    data['file']= base64file;
    try {
      var response = await http.post(
          endPoint,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: json.encode(data));
    } catch (e) {
      throw (e.toString());
    }

    return data;
  }

  Future getCrewPhoto() async {
    http.Response response  = await http.get(
        Uri.encodeFull('http://192.168.0.13:8080/api/crew-photo/' + global.currentCrew.id.toString() + '/'),
        headers: {
          "Accept": "application/json"
        }
    );

    if (response.statusCode == 200){
      Map<String, dynamic> data = jsonDecode(response.body);
      String file = data['file'];

      Uint8List bytes = base64Decode(file);
      global.currentCrew.img = Image.memory(bytes).image;
    } else {
      global.currentCrew.img = null;
    }
  }
}

