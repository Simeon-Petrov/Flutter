import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventModel {
  String? id;
  String title;
  String? description;
  DateTime startTime;
  DateTime endTime;
  String createdBy;
  int? categoryColorValue;

  EventModel({
    this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
    this.categoryColorValue,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'createdBy': createdBy,
      'categoryColorValue': categoryColorValue,
    };
  }

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
      categoryColorValue: data['categoryColorValue'],
    );
  }

  Color get categoryColor {
    return categoryColorValue != null
        ? Color(categoryColorValue!)
        : Colors.grey;
  }
}
