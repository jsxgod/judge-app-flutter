import 'package:flutter/material.dart';

class Competition {
  final int id;
  final String type;
  final int event;

  Competition(this.id, this.type, this.event);

  Competition.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        event = json['event'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'type': type,
        'event': event,
      };
}