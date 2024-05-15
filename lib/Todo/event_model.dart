import 'package:flutter/material.dart';

class EventModel {
  int? id;
  final String name;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime date;

  EventModel({
    this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'name': name,
      'start_time': '${startTime.hour}:${startTime.minute}',
      'end_time': '${endTime.hour}:${endTime.minute}',
      'date': date.toIso8601String(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map["id"],
      name: map['name'],
      startTime: TimeOfDay(
        hour: int.parse(map['start_time'].split(':')[0]),
        minute: int.parse(map['start_time'].split(':')[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(map['end_time'].split(':')[0]),
        minute: int.parse(map['end_time'].split(':')[1]),
      ),
      date: DateTime.parse(map['date']),
    );
  }
}
