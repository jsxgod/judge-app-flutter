import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/global.dart';
import 'package:flutter_app/ui/widgets/crewheader.dart';
import 'package:flutter_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GradeCrewScreen extends StatefulWidget {
  @override
  _GradeCrewScreenState createState() => _GradeCrewScreenState();
}

class _GradeCrewScreenState extends State<GradeCrewScreen> {
  int _active = 1;

  String _crew_id;
  String _competition_id;
  String _competition_name;
  String _score;

  final GlobalKey<_GradeCrewScreenState> _gradeKey = GlobalKey<_GradeCrewScreenState>();

  Widget _buildCrewId() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Crew Id'),
      maxLength: 1000,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Crew id is required';
        }

        return null;
      },
      onSaved: (String value) {
        _crew_id = value;
      },
    );
  }

  Widget _buildCompetitionId() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Competition Id'),
      maxLength: 1000,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Competition id is required';
        }

        return null;
      },
      onSaved: (String value) {
        _competition_id = value;
      },
    );
  }

  Widget _buildCompetitionName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Competition Name'),
      maxLength: 100,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Competition name is required';
        }

        return null;
      },
      onSaved: (String value) {
        _competition_name = value;
      },
    );
  }

  Widget _buildScore() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Score'),
      maxLength: 100,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Score is required';
        }

        return null;
      },
      onSaved: (String value) {
        _score = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _active,
        onItemSelected: (index) => setState(() {
          if(_active == index){
            if (_active == 0){
              Navigator.pushNamed(context, 'judge');
            } else {
              Navigator.pushNamed(context, 'grade_crew');
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
              Icons.qr_code_outlined,
            ),
            title: Text("QR"),
          ),
        ],
      ),
      backgroundColor: Color(0xfff4f6ff),
      body: SafeArea(
          child: Form(
            key: _gradeKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildCrewId(),
                _buildCompetitionId(),
                _buildCompetitionName(),
                _buildScore(),
                SizedBox(height: 100),
                RaisedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                onPressed: () {
                    print('submit');
                  //if (!_gradeKey.currentState.validate()) {
                    //return;
                  //}
                }
              )
              ]
            )
          )

      ),
    );
  }
}