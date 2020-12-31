import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Crew {
  final int id;
  final int number;
  final String car;
  final String yearOfProduction;
  final String qr;
  final String photo;
  final String description;
  final String driverName;
  final int event;

  List scores;
  ImageProvider img;

  Crew(this.id, this.number, this.car, this.qr, this.photo, this.description,
      this.yearOfProduction, this.driverName, this.event);

  Crew.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        event = json['event'],
        number = json['number'],
        car = json['car'],
        qr = json['qr'],
        photo = json['photo'],
        description = json['description'],
        yearOfProduction = json['year_of_production'],
        driverName = json['driver_name'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'number': number,
        'car': car,
        'year_of_production': yearOfProduction,
        'driver_name': driverName,
        'qr': qr,
        'photo': photo,
        'description': description,
        'event': event,
      };
}