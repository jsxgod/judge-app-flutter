import 'dart:typed_data';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_app/models/crew.dart';
import 'package:flutter_app/ui/widgets/judgedetailcolumn.dart';
import 'package:flutter_app/ui/widgets/judgeheader.dart';
import 'package:flutter_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_app/global.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert';

class JudgeScreen extends StatefulWidget {
  @override
  _JudgeScreenState createState() => _JudgeScreenState();
}

class _JudgeScreenState extends State<JudgeScreen> {
  int _active = -1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _active,
          onItemSelected: (index) =>
              setState(() {
                if (_active == index) {
                  if (_active == 0) {
                    if(ModalRoute.of(context).settings.name != 'judge'){
                      Navigator.pushNamed(context, 'judge');}
                  } else if (_active == 1) {
                    if(global.currentJudgeScannedQR != null && global.currentJudgeScannedQR != "") {
                      Navigator.pushNamed(context, 'crew');
                    } else {
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
                    } else {
                        _scanFromCamera();
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
            BottomNavyBarItem(
              icon: Icon(
                Icons.qr_code_outlined,
              ),
              title: Text("Scan QR"),
            ),
          ],
        ),
        backgroundColor: Color(0xfff4f6ff),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  JudgeHeader(),
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
                              Expanded(
                                child: Text(
                                   global.currentEvent.description
                                )
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 9.0),
                        Text(
                          "Competitions",
                          style: Theme
                              .of(context)
                              .textTheme
                              .title
                              .apply(fontWeightDelta: 2),
                        ),
                        SizedBox(height: 9.0),
                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 4,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: global.competitionDetailsList.length,
                            itemBuilder: (ctx, i) {
                              return GestureDetector(
                                onTap: () => {
                                  if (global.currentJudgeScannedQR != null && global.currentJudgeScannedQR != ""){
                                    Navigator.pushNamed(context, global.competitionList[i]),
                                    global.currentCompetition = global.competitionList[i]
                                  } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                        title: Text('Please Scan Crew QR first.'),
                                        actions: [
                                          FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Ok"))
                                        ],
                                    ),
                                    barrierDismissible: true
                                )
                                  }
                                },
                                child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 3,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    padding: EdgeInsets.all(15.0),
                                    alignment: Alignment.bottomLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "${global.competitionDetailsList[i]['img']}"),
                                      ),
                                    ),
                                    child: Stack(children: <Widget>[
                                      Text("${global.competitionDetailsList[i]['title']}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 6
                                              ..color = Colors.black,
                                          )),
                                      Text("${global.competitionDetailsList[i]['title']}",
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.white)),
                                    ])),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future _scanFromCamera() async {
    String scanned = await scanner.scan();
    setState(() => global.currentJudgeScannedQR = scanned);

    if(scanned != null){
      getData();
    }
  }

  Future getData() async {
    http.Response response  = await http.get(
        Uri.encodeFull('http://192.168.0.13:8080/api/crew-list/'),
        headers: {
          "Accept": "application/json"
        }
    );


    List crews = jsonDecode(response.body);
    Crew crew;
    for (var c in crews){
      if(c["qr"] == global.currentJudgeScannedQR){
        if(c['event'] == global.currentEvent.id){
          crew = Crew.fromJson(c);
          global.currentCrew = crew;
          await getCrewPhoto();
          Navigator.pushNamed(context, 'crew');
          break;
        }
      }
    }
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