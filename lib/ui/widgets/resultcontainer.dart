import 'package:flutter/material.dart';
import 'package:flutter_app/models/score.dart';
import 'package:flutter_app/models/competition.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/global.dart' as global;

class ResultContainer extends StatelessWidget {
  final Map<String, dynamic> score;
  const ResultContainer({
    Key key,
    this.score
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(score['competition'] == 'R' ? Icons.directions_car_outlined :
                      score['competition'] == 'T' ? Icons.timer_outlined :
                      score['competition'] == 'P' ? Icons.pan_tool_outlined :
                      Icons.menu_book_outlined,
                      color: Theme.of(context).accentColor),
                  Text(
                      score['competition'],
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .apply(
                        color: Theme.of(context).accentColor),
                  ),
                  Text(
                      score['score']
                  )
                ],
              )
          )
        ],
      ),
    );
  }

  Icon getIcon(){

  }
}