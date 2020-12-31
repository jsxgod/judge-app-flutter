import 'dart:io';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_app/global.dart' as global;
import 'package:flutter_app/ui/widgets/crewheader.dart';
import 'package:flutter_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrewCompetitionActiveScreen extends StatefulWidget {
  @override
  _CrewCompetitionActiveScreenState createState() => _CrewCompetitionActiveScreenState();
}

class _CrewCompetitionActiveScreenState extends State<CrewCompetitionActiveScreen> {
  int _active = -1;

  @override
  Widget build(BuildContext context) {
    getScores();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _active,
          onItemSelected: (index) =>
              setState(() {
                if (_active == index) {
                  if (_active == 0) {
                    Navigator.of(context).pop();
                  } else if (_active == 1) {
                    Navigator.pushNamed(context, 'crew_statistics');
                  } else {
                    Navigator.pushNamed(context, 'crew_qr');
                  }
                } else {
                  _active = index;
                }
              }),
          items: [
            BottomNavyBarItem(
              icon: Icon(
                Icons.addchart_outlined,
              ),
              title: Text("Back"),
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.analytics_outlined,
              ),
              title: Text("Results"),
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.qr_code_outlined,
              ),
              title: Text("QR"),
            ),
          ],
        ),
        backgroundColor: Color(0xfff4f6ff),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CrewHeader(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 21.0, vertical: 31.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 11,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              CarDetailColumn(
                                  textColor: Theme
                                      .of(context)
                                      .accentColor),
                              Expanded(child: Column()),
                              CarDetailColumn(
                                  textColor: Theme
                                      .of(context)
                                      .accentColor, crew: global.currentCrew),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future getScores() async {
    http.Response response  = await http.get(
        Uri.encodeFull('http://192.168.0.13:8080/api/crew-scores/' + global.currentCrew.id.toString()),
        headers: {
          "Accept": "application/json"
        }
    );


    List crewScores = jsonDecode(response.body);
    global.currentCrew.scores = crewScores;
  }
}