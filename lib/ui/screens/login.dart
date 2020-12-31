import 'dart:io';

import 'package:flutter_app/global.dart' as global;
import 'package:flutter_app/models/event.dart';
import 'package:flutter_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff4f6ff),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                LoginHeader(),
                Icon(
                  Icons.qr_code_scanner,
                  size: MediaQuery.of(context).size.width * 0.5
                ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width * 0.5,
                  buttonColor: Colors.grey,
                  child: RaisedButton(
                    onPressed: () {
                      _scanFromCamera();
                    },
                    child: Text('SCAN TO LOGIN')
                  )
                )
              ],
            )),
      )

    );
  }
  Future _scanFromCamera() async {
    String scanned = await scanner.scan();
    setState(() => global.loginQR = scanned);

    if(scanned != null){
      print(scanned);
      getData();
    }
  }

  Future getData() async {
    http.Response response  = await http.get(
      Uri.encodeFull('http://192.168.0.13:8080/api/event-list/'),
      headers: {
        "Accept": "application/json"
      }
    );

    if(response.statusCode == 200){
      List events = jsonDecode(response.body);
      Event event;
      for (var e in events){
        if(e["judge_qr"] == global.loginQR){
          event = Event.fromJson(e);
          global.currentEvent = event;
          global.currentEventDescription = event.description;
          Navigator.pushNamed(context, 'judge');
          break;
        }
      }
    }
  }
}
