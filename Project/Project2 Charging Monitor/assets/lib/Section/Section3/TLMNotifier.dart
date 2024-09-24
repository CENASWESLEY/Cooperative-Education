import 'dart:developer';
import 'package:flutter/foundation.dart';

class TLMNotifier extends ChangeNotifier {
  double? volt1;
  double? volt2;
  double? volt3;
  double? current1;
  double? current2;
  double? current3;
  double? power1;
  double? power2;
  double? power3;
  double? energyK;
  double? energyVarK;

  void updateValues({
    double? newVolt1,
    double? newVolt2,
    double? newVolt3,
    double? newCurrent1,
    double? newCurrent2,
    double? newCurrent3,
    double? newPower1,
    double? newPower2,
    double? newPower3,
    double? newEnergyK,
    double? newEnergyVarK,
  }) {
    volt1 = newVolt1;
    volt2 = newVolt2;
    volt3 = newVolt3;
    current1 = newCurrent1;
    current2 = newCurrent2;
    current3 = newCurrent3;
    power1 = newPower1;
    power2 = newPower2;
    power3 = newPower3;
    energyK = newEnergyK;
    energyVarK = newEnergyVarK;

    notifyListeners(); // แจ้งเตือน UI เมื่อค่าถูกอัปเดต
  }
}
