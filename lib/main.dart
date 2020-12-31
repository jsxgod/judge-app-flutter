import 'package:flutter_app/ui/screens/login.dart';
import 'package:flutter_app/ui/screens/screens.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oldtimers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Quicksand',
      ),
      home: LoginScreen(),
      routes: {
        'crew': (ctx) => CrewScreen(),
        'crew_competition_active': (ctx) => CrewCompetitionActiveScreen(),
        'login': (ctx) => LoginScreen(),
        'crew_qr': (ctx) => CrewQRScreen(),
        'crew_statistics': (ctx) => CrewStatisticsScreen(),
        'judge': (ctx) => JudgeScreen(),
        'grade_crew': (ctx) => GradeCrewScreen(),
        'race': (ctx) => RaceScreen(),
        'timerace': (ctx) => TimeRaceScreen(),
        'physical': (ctx) => PhysicalScreen(),
        'knowledge': (ctx) => KnowledgeScreen(),
      },
    );
  }
}
