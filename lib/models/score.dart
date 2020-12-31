import 'package:flutter/material.dart';

class Score {
  final int id;
  final String competition;
  final String score;
  final String date;
  final int crew;
  final int event;

  Score(this.id, this.competition, this.score, this.date, this.crew, this.event);

  Score.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        competition = json['competition'],
        score = json['score'],
        date = json['date'],
        crew = json['crew'],
        event = json['event'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'competition': competition,
        'score': score,
        'crew': crew,
        'event': event
      };
}