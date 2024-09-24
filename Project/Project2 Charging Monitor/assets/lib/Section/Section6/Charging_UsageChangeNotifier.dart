import 'package:flutter/material.dart';

class EnergyProvider extends ChangeNotifier {
  double _totalEnergy = 0.0;

  double get totalEnergy => _totalEnergy;

  void updateEnergies(double totalenergy) {
    // totalenergy form charging_Usage
    _totalEnergy = totalenergy;
    notifyListeners();
  }

  double total_Energy() {
    return _totalEnergy;
  }

// TODO: Element Green

// ลด CO2=(CO2 จากน้ำมัน−CO2 จากพลังงานไฟฟ้า)×ระยะทางที่วิ่งได้

  // ฟังก์ชันคำนวณการลด CO2
  double calculateCO2Reduction() {
    double co2FromGas = (_totalEnergy / 0.2 / 10) * 2.31; // ปล่อย CO2 จากน้ำมัน
    double co2FromElectricity = _totalEnergy * 0.475; // ปล่อย CO2 จากไฟฟ้า
    return co2FromGas - co2FromElectricity; // ลด CO2 ที่ได้
  }

//ต้นไม้หนึ่งต้นสามารถดูดซับ CO2 ได้ประมาณ 22 กิโลกรัมต่อปี

  // ฟังก์ชันคำนวณจำนวนต้นไม้ที่เทียบเท่า
  double calculateTreeEquivalent() {
    double co2Reduction = calculateCO2Reduction();
    return co2Reduction / 22; // ต้นไม้หนึ่งต้นดูดซับ CO2 ได้ 22 กิโลกรัมต่อปี
  }

  // ฟังก์ชันคำนวณการประหยัดค่าใช้จ่าย
  double calculateCostSaving() {
    double gasCost = (_totalEnergy / 0.2 / 10) *
        40; // ค่าน้ำมันที่ใช้เบนซิน  0.2 kwh/กิดลเมตร | ใช้น้ำมัน 10 กิโลเมตรต่อลิตร | ราคาน้ำมันเบนฐิน 40
    double electricCost = _totalEnergy * 4; // ค่าไฟฟ้าที่ใช้
    return gasCost - electricCost; // การประหยัด
  }

// TODO: Element Yellow

  // ฟังก์ชันคำนวณ Electrical Grid Power
  double calculateElectricalGridPower() {
    return _totalEnergy - (_totalEnergy * 0.2);
  }

  // ฟังก์ชันคำนวณ Renewable Energy
  double calculateRenewableEnergy() {
    return _totalEnergy * 0.2; // ใช้พลังงานหมุนเวียน 20% จากพลังงานทั้งหม
  }

// ฟังก์ชันคำนวณ Monthly Energy Consumption
  double calculateMonthlyEnergy() {
    double _totalEnergyperyear = (_totalEnergy * 12) / 9;

    return (_totalEnergyperyear / 12);
  }
}
