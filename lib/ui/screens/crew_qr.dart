import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/global.dart' as global;
import 'package:flutter_app/ui/widgets/crewheader.dart';
import 'package:flutter_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CrewQRScreen extends StatefulWidget {
  @override
  _CrewQRScreenState createState() => _CrewQRScreenState();
}

class _CrewQRScreenState extends State<CrewQRScreen> {
  int _active = 2;
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
              } else if (_active == 1){
                Navigator.of(context).pop();
                Navigator.pushNamed(context, 'crew_statistics');
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
          child:
          Align(
            alignment: Alignment.center,
            child: QrImage(
              data: global.currentCrew.qr,
              version: QrVersions.auto,
              size: 320,
              gapless: false,
            ),
          )
        ),
      ),
    );
  }
}
