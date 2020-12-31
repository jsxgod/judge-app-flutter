import 'package:flutter/material.dart';

import 'models/event.dart';
import 'models/crew.dart';

Color blueColor = Color(0xff1954cf);

List<Map<String, dynamic>> competitionDetailsList = [
  {'img': 'https://cdn.pixabay.com/photo/2016/07/27/00/58/oldtimer-1544342_960_720.jpg', 'title': 'Race'},
  {'img': 'https://cdn.pixabay.com/photo/2019/08/14/19/00/auto-4406505_960_720.jpg', 'title': 'Time Race'},
  {'img': 'https://cdn.pixabay.com/photo/2015/02/19/03/31/man-641691_960_720.jpg', 'title': 'Physical'},
  {'img': 'https://cdn.pixabay.com/photo/2019/08/10/09/17/oldtimer-4396528_960_720.jpg', 'title': 'Knowledge'},
];

List<String> competitionList = ['race', 'timerace', 'physical', 'knowledge'];

String currentJudgeScannedQR = "";
Crew currentCrew;

Event currentEvent;
String currentEventDescription = "";

String loginQR = "";

String currentCompetition = "";

String cT = "";