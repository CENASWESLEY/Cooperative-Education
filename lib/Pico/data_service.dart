import 'dart:developer';
import 'package:flutter/material.dart';

// ใช้ DataService สืบทอด class จาก ChangeNotifier
class DataService extends ChangeNotifier {
  //Map เก็บข้อมูล key เป็น string value เป็น dynamic ที่สามารถรับค่าได้หลายประเภท
  Map<String, dynamic> mqttData = {};

  void update() {
    log('update data:$mqttData');
    notifyListeners();
  }
}
