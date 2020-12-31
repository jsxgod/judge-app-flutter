import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert';


class TimeRaceScreen extends StatefulWidget {
  @override
  _TimeRaceScreenState createState() => _TimeRaceScreenState();
}

class _TimeRaceScreenState extends State<TimeRaceScreen> {
  int _active = -1;
  final _formKey = GlobalKey<FormState>();

  TextEditingController crewNumberController = TextEditingController();

  bool startPressed = true;
  bool stopPressed = true;
  bool resetPressed = true;
  String stopwatchTime = "00:00:00";
  var swatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _active,
            onItemSelected: (index) => setState(() {
              bool flag = crewNumberController.text.isEmpty && stopwatchTime == "00:00:00";
              if (startPressed == true){
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
                        Navigator.of(context).pop();
                      }
                  }
                } else {
                  _active = index;
                }
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
                        Text('Time Race Competition', style: TextStyle(fontSize: 28)),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.05,
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
                        )
                        ,
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                    stopwatchTime,
                                  )
                                )
                              )
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height * 0.1,
                                buttonColor: Colors.greenAccent,
                                child: RaisedButton(
                                    onPressed: startPressed ? startStopWatch : null,
                                    child: Text('START')
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
                                    onPressed: stopPressed ? null : stopStopwatch,
                                    child: Text('STOP')
                                )
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height * 0.1,
                                buttonColor: Colors.orangeAccent,
                                child: RaisedButton(
                                    onPressed: resetPressed ? null : resetStopWatch,
                                    child: Text('RESET')
                                )
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.height * 0.1,
                                buttonColor: Colors.lightGreenAccent,
                                child: RaisedButton(
                                    onPressed: resetPressed ? null : sendResult,
                                    child: Text('SEND RESULT')
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


  void startTimer(){
    Timer(duration, keepRunning);
  }

  void keepRunning(){
    if(swatch.isRunning){
      startTimer();
    }
    setState(() {
      stopwatchTime = swatch.elapsed.inHours.toString().padLeft(2, "0") + ":"
                      + (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0").toString()
                      + ":" + (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0").toString();
    });
  }

  void startStopWatch() {
    setState(() {
      stopPressed = false;
      startPressed = false;
    });
    swatch.start();
    startTimer();
  }

  void stopStopwatch() {
    setState(() {
      stopPressed = true;
      resetPressed = false;
    });
    swatch.stop();
  }

  void resetStopWatch() {
    setState(() {
      startPressed = true;
      resetPressed = true;
      crewNumberController.clear();
    });
    swatch.reset();
    stopwatchTime = "00:00:00";
  }

  Future sendResult() async{
    Map<String, dynamic> data = {
      "competition": "T",
      "crew": global.currentCrew.id,
      "score": stopwatchTime,
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
      resetStopWatch();
    }
  }

  Widget stopwatch(){
    return Container();
  }
}

