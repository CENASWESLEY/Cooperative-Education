import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database extends StatefulWidget {
  const Database({super.key});

  @override
  State<Database> createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
/*
    //TODO: Save infomation to Firestore

  void saveDailyChargingData() async {
    // สร้าง instance ของ Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // รายชื่อเดือนตั้งแต่ Jan ถึง Dec
    List<String> months = [
      '01.January',
      '02.February',
      '03.March',
      '04.April',
      '05.May',
      '06.June',
      '07.July',
      '08.August',
      '09.September',
      '10.October',
      '11.November',
      '12.December'
    ];

    // ฟังก์ชันสุ่มค่า HH:MM สำหรับ Charging Duration
    String getRandomTime() {
      Random random = Random();
      int hours = random.nextInt(3); // สุ่มชั่วโมง 0 - 4
      int minutes = random.nextInt(60); // สุ่มนาที 0 - 59
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }

    // ฟังก์ชันสุ่มค่าพลังงาน kWh สำหรับ Energy โดยคำนวณจากจำนวนครั้งที่ชาร์จ
    String getRandomEnergy(int sessions) {
      Random random = Random();
      // กำหนดให้การใช้พลังงานอยู่ที่ประมาณ 5-15 kWh ต่อการชาร์จ 1 ครั้ง
      int energy = sessions * (random.nextInt(11) + 5); // 5-15 kWh ต่อครั้ง
      return '$energy kWh';
    }

    // ฟังก์ชันสุ่มค่ากำลังไฟฟ้า (Power) สำหรับ Power (kW)
    String getRandomPower(String duration) {
      List<String> parts = duration.split(":");
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      double timeInHours = hours + (minutes / 60); // แปลงเวลาเป็นชั่วโมงทศนิยม
      Random random = Random();
      // กำหนดกำลังไฟฟ้าให้สัมพันธ์กับพลังงานที่ใช้ โดยเฉลี่ยประมาณ 2 - 22 kW
      double power = (random.nextDouble() * 20) + 2; // สุ่มกำลังไฟ 2 - 22 kW
      return '${(power * timeInHours).toStringAsFixed(2)} kW'; // กำหนดค่า power เป็น kW
    }

    // ฟังก์ชันสุ่มค่าจำนวนการชาร์จสำหรับ Number of Sessions (0-20)
    int getRandomSessions() {
      Random random = Random();
      return random.nextInt(21); // สุ่มค่า 0 - 20 ครั้ง
    }

    // สร้างข้อมูลสำหรับแต่ละเดือน
    for (String month in months) {
      // จำนวนวันที่แต่ละเดือน
      int daysInMonth = getDaysInMonth(month);

      // สร้างข้อมูลรายวัน
      for (int day = 1; day <= daysInMonth; day++) {
        String date =
            "2024-${(months.indexOf(month) + 1).toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

        // สุ่มจำนวนครั้งที่ชาร์จสำหรับ AC และ DC
        int sessionsAC = getRandomSessions();
        int sessionsDC = getRandomSessions();

        // Data สำหรับ AC และ DC (Charging Duration)
        String durationAC = getRandomTime();
        String durationDC = getRandomTime();
        Map<String, String> dailyDurationAC = {date: durationAC};
        Map<String, String> dailyDurationDC = {date: durationDC};

        // Data สำหรับ AC และ DC (Energy)
        Map<String, String> dailyEnergyAC = {date: getRandomEnergy(sessionsAC)};
        Map<String, String> dailyEnergyDC = {date: getRandomEnergy(sessionsDC)};

        // Data สำหรับ AC และ DC (Power)
        Map<String, String> dailyPowerAC = {date: getRandomPower(durationAC)};
        Map<String, String> dailyPowerDC = {date: getRandomPower(durationDC)};

        // Data สำหรับ AC และ DC (Number of Sessions)
        Map<String, String> dailySessionsAC = {date: sessionsAC.toString()};
        Map<String, String> dailySessionsDC = {date: sessionsDC.toString()};

        // บันทึกข้อมูลใน Firestore สำหรับ Charging Duration
        await firestore
            .collection('Station')
            .doc('Phloen Chit')
            .collection('Connector Daily Charging Statistics')
            .doc(month)
            .collection('Charging Duration')
            .doc('AC')
            .set(dailyDurationAC, SetOptions(merge: true));

        await firestore
            .collection('Station')
            .doc('Phloen Chit')
            .collection('Connector Daily Charging Statistics')
            .doc(month)
            .collection('Charging Duration')
            .doc('DC')
            .set(dailyDurationDC, SetOptions(merge: true));

        // บันทึกข้อมูลใน Firestore สำหรับ Energy (kWh)
        await firestore
            .collection('Station')
            .doc('Phloen Chit')
            .collection('Connector Daily Charging Statistics')
            .doc(month)
            .collection('Energy (kWh)')
            .doc('AC')
            .set(dailyEnergyAC, SetOptions(merge: true));

        await firestore
            .collection('Station')
            .doc('Phloen Chit')
            .collection('Connector Daily Charging Statistics')
            .doc(month)
            .collection('Energy (kWh)')
            .doc('DC')
            .set(dailyEnergyDC, SetOptions(merge: true));

        // บันทึกข้อมูลใน Firestore สำหรับ Power (kW)
        await firestore
            .collection('Station')
            .doc('Phloen Chit')
            .collection('Connector Daily Charging Statistics')
            .doc(month)
            .collection('Power')
            .doc('AC')
            .set(dailyPowerAC, SetOptions(merge: true));

        await firestore
            .collection('Station')
            .doc('Phloen Chit')
            .collection('Connector Daily Charging Statistics')
            .doc(month)
            .collection('Power')
            .doc('DC')
            .set(dailyPowerDC, SetOptions(merge: true));

        // บันทึกข้อมูลใน Firestore สำหรับ Number of Sessions
        await firestore
            .collection('Station')
            .doc('Phloen Chit')
            .collection('Connector Daily Charging Statistics')
            .doc(month)
            .collection('Number of Sessions')
            .doc('AC')
            .set(dailySessionsAC, SetOptions(merge: true));

        await firestore
            .collection('Station')
            .doc('Phloen Chit')
            .collection('Connector Daily Charging Statistics')
            .doc(month)
            .collection('Number of Sessions')
            .doc('DC')
            .set(dailySessionsDC, SetOptions(merge: true));
      }
    }
  }

// ฟังก์ชันสำหรับจำนวนวันในแต่ละเดือน (ไม่รวม leap year)
  int getDaysInMonth(String month) {
    switch (month) {
      case '02.February':
        return 29;
      case '04.April':
      case '06.June':
      case '09.September':
      case '11.November':
        return 30;
      default:
        return 31;
    }
  }

*/
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
