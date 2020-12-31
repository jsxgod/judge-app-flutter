import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhysicalScreen extends StatefulWidget {
  @override
  _PhysicalScreenState createState() => _PhysicalScreenState();
}

class _PhysicalScreenState extends State<PhysicalScreen> {
  int _active = -1;
  final _formKey = GlobalKey<FormState>();
  TextEditingController crewNumberController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  TextEditingController maxScoreController = TextEditingController();

  List textEditingControllers;
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    textEditingControllers = [crewNumberController, scoreController, maxScoreController];
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _active,
            onItemSelected: (index) => setState(() {
              checkControllers();
              if(_active == index){
                if (_active == 0){
                  if(flag) {
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
                    }                  } else {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Please Scan Crew QR first.'),
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
                      Navigator.of(context).pop();
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
                        Text('Physical Competition', style: TextStyle(fontSize: 32)),
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
                        Row(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                controller: scoreController,
                                decoration: const InputDecoration(
                                  hintText: 'Score'
                                ),
                                validator: (value) {
                                  if (value.isEmpty){
                                    return 'Please enter crew\'s score';
                                  }
                                  return null;
                                },
                              )
                            ),
                            Expanded(child: Column()),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                                child: TextFormField(
                                  controller: maxScoreController,
                                  decoration: const InputDecoration(
                                    hintText: 'Max score',

                                  ),
                                  validator: (value) {
                                    if (value.isEmpty){
                                      return 'Please enter max score';
                                    }
                                    return null;
                                  },
                                )
                            ),
                          ],
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
                                    child: Text('SEND RESULTS')
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
                        ),
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
      "competition": "P",
      "crew": global.currentCrew.id,
      "score": scoreController.text+"/"+maxScoreController.text,
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

  void checkControllers(){
    flag = true;
    for (TextEditingController c in textEditingControllers){
      if (c.text.isNotEmpty){
        flag = false;
        break;
      }
    }
  }

  void clearControllers(){
    crewNumberController.clear();
    scoreController.clear();
    maxScoreController.clear();
  }
}