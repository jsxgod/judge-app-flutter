import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert';

class RaceScreen extends StatefulWidget {
  @override
  _RaceScreenState createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  int _active = -1;
  final _formKey = GlobalKey<FormState>();

  TextEditingController crewNumberController = TextEditingController();
  TextEditingController positionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _active,
          onItemSelected: (index) => setState(() {
            bool flag = crewNumberController.text.isEmpty && positionController.text.isEmpty;
            if(_active == index){
              if (_active == 0){
                if(flag) {
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Please Send results or Reset the input first as you will not be able to get them back.'),
                        actions: [
                          FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Ok"))
                        ],
                      ),
                      barrierDismissible: true
                  );
                }
              } else if (_active == 1){
                if(global.currentJudgeScannedQR != null && global.currentJudgeScannedQR != "") {
                  Navigator.pushNamed(context, 'crew_competition_active');
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Please Scan Crew QR first.'),
                        actions: [
                          FlatButton(onPressed: (){Navigator.of(context).pop();Navigator.of(context).pop();}, child: Text("Ok"))
                        ],
                      ),
                      barrierDismissible: true
                  );
                }
              }
            } else {
              _active = index;
            }
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(
                Icons.person,
              ),
              title: Text("Home"),
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.directions_car_outlined,
              ),
              title: Text("Crew"),
            ),
          ],
        ),
        backgroundColor: Color(0xfff4f6ff),
        body: SafeArea(
          child: Align(
              alignment: Alignment.center,
            child: Form (
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Race Competition', style: TextStyle(fontSize: 32)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextFormField(
                      controller: crewNumberController,
                      decoration: const InputDecoration(
                        hintText: 'Enter crew number',

                      ),
                      validator: (value) {
                        if (value.isEmpty){
                          return 'Please enter crew number';
                        }
                        return null;
                      },
                    )
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: positionController,
                        decoration: const InputDecoration(
                          hintText: 'Enter position at finish line',

                        ),
                        validator: (value) {
                          if (value.isEmpty){
                            return 'Please enter crew number';
                          }
                          return null;
                        },
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.1,
                          buttonColor: Colors.grey,
                          child: RaisedButton(
                              onPressed: (){
                                if (_formKey.currentState.validate()) {
                                  sendResult();
                                }
                              },
                              child: Text('SEND RESULT')
                          )
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.1,
                          buttonColor: Colors.redAccent,
                          child: RaisedButton(
                              onPressed: (){
                                clearControllers();
                              },
                              child: Text('RESET')
                          )
                      )
                  )
                ],
              )
            )
        ),
        )
      ),
    );
  }

  Future sendResult() async{
    Map<String, dynamic> data = {
      "competition": "R",
      "crew": global.currentCrew.id,
      "score": positionController.text,
      "event": global.currentEvent.id
    };

    http.Response response  = await http.post(
        Uri.encodeFull('http://192.168.0.13:8080/api/score-create/'),
        body: jsonEncode(data),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        }
    );

    if (response.statusCode == 200){
      clearControllers();
    }
  }

  void clearControllers(){
    crewNumberController.clear();
    positionController.clear();
  }
}
