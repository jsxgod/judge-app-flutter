import 'package:flutter/material.dart';

class Organizer {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String description;

  Organizer(this.id, this.name, this.email, this.phone, this.description);

  Organizer.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'],
        description = json['description'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'description': description,
      };
}