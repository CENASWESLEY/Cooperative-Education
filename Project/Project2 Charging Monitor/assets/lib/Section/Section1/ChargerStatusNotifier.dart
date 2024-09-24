import 'dart:developer';
import 'package:flutter/foundation.dart';

class ChargerStatusNotifier extends ChangeNotifier {
  // Map สำหรับเก็บสถานะของ Connector 1 และ Connector 2
  Map<int, String> _connector1Status = {
    for (int i = 0; i <= 18; i++) i: 'Finishing'
  };

  Map<int, String> _connector2Status = {
    for (int i = 19; i <= 30; i++) i: 'Finishing'
  };

  // Method สำหรับการดึงสถานะของหัวชาร์จ
  String getConnector1Status(int id) {
    String status = _connector1Status[id] ?? 'Finishing';
    return status;
  }

  String getConnector2Status(int id) {
    String status = _connector2Status[id] ?? 'Finishing';
    return status;
  }

  // Method สำหรับการอัปเดตสถานะของหัวชาร์จ
  void updateConnector1Status(int id, String status) {
    _connector1Status[id] = status;
    notifyListeners();
  }

  void updateConnector2Status(int id, String status) {
    _connector2Status[id] = status;
    notifyListeners();
  }
}
