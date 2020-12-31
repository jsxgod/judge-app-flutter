import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/global.dart' as global;
import 'package:flutter_app/models/competition.dart';
import 'package:flutter_app/models/score.dart';
import 'package:flutter_app/ui/widgets/crewheader.dart';
import 'package:flutter_app/ui/widgets/resultcontainer.dart';
import 'package:flutter_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrewStatisticsScreen extends StatefulWidget {
  @override
  _CrewStatisticsScreenState createState() => _CrewStatisticsScreenState();
}

class _CrewStatisticsScreenState extends State<CrewStatisticsScreen> {
  int _active = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _active,
          onItemSelected: (index) => setState(() {
            if(_active == index){
              if (_active == 0){
                Navigator.of(context).pop();
              } else if (_active == 2){
                Navigator.of(context).pop();
                Navigator.pushNamed(context, 'crew_qr');
              }
            } else {
              _active = index;
            }
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(
                Icons.directions_car_outlined,
              ),
              title: Text("Crew"),
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
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Results",
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .apply(fontWeightDelta: 2),
                            )
                          ],
                        ),
                        SizedBox(height: 9.0),
                        for (var score in global.currentCrew.scores) ResultContainer(score: score),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}