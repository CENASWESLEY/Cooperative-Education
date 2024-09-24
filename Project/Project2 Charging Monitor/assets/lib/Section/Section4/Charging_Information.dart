import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_ems/Component/Theme.dart';
import 'package:dashboard_ems/Section/Section2/Main_Information.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Charging_Information extends StatefulWidget {
  const Charging_Information({super.key});

  @override
  State<Charging_Information> createState() => _Charging_InformationState();
}

class _Charging_InformationState extends State<Charging_Information> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // เรียกใช้ฟังก์ชันสร้าง transaction เมื่อ widget ถูกสร้างครั้งแรก
    //generateTransactions();
  }

// TODO: Save information to Firebase

  Future<void> generateTransactions() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // รายชื่อสถานี
    final List<String> stationList = [
      'Bang Khen',
      'Lat Krabang',
      'Phloen Chit',
      'Thon Buri'
    ];

    // รายชื่อเดือน
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
      //'11.November',
      //'12.December'
    ];

    // รายชื่อวัน (กำหนด 1-31)
    List<String> days =
        List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));

    // ปีที่ใช้
    String year = "2024";

    for (String station in stationList) {
      for (String month in months) {
        for (String day in days) {
          String date = "$year-${month.split('.')[0]}-$day"; // YYYY-MM-DD

          // เตรียม list สำหรับเก็บ transaction ของ AC และ DC
          List<Map<String, dynamic>> acTransactions = [];
          List<Map<String, dynamic>> dcTransactions = [];

          // สร้าง Transaction สำหรับ AC
          int acTransactionCount =
              Random().nextInt(15) + 1; // สุ่ม transaction 0-10 ครั้ง
          for (int i = 0; i < acTransactionCount; i++) {
            Map<String, dynamic> transaction =
                generateRandomACTransaction(); // ฟังก์ชันสุ่มข้อมูล transaction AC
            acTransactions.add(transaction); // เพิ่ม transaction เข้าไปใน list
          }

          // สร้าง Transaction สำหรับ DC
          int dcTransactionCount =
              Random().nextInt(15) + 1; // สุ่ม transaction 0-10 ครั้ง
          for (int i = 0; i < dcTransactionCount; i++) {
            Map<String, dynamic> transaction =
                generateRandomDCTransaction(); // ฟังก์ชันสุ่มข้อมูล transaction DC
            dcTransactions.add(transaction); // เพิ่ม transaction เข้าไปใน list
          }

          // บันทึกข้อมูล AC ลงใน Firestore
          try {
            await firestore
                .collection('Stations')
                .doc(station)
                .collection('Connector Daily Charging Statistics')
                .doc(month)
                .collection('Transactions')
                .doc(date) // YYYY-MM-DD
                .set({
              'AC': acTransactions, // เก็บเป็น list ของ transaction AC
            }, SetOptions(merge: true));
            print("AC Transactions saved for $station - $month - $date");
          } catch (e) {
            print(
                "Failed to save AC transactions for $station - $month - $date: $e");
          }

          // บันทึกข้อมูล DC ลงใน Firestore
          try {
            await firestore
                .collection('Stations')
                .doc(station)
                .collection('Connector Daily Charging Statistics')
                .doc(month)
                .collection('Transactions')
                .doc(date) // YYYY-MM-DD
                .set({
              'DC': dcTransactions, // เก็บเป็น list ของ transaction DC
            }, SetOptions(merge: true));
            print("DC Transactions saved for $station - $month - $date");
          } catch (e) {
            print(
                "Failed to save DC transactions for $station - $month - $date: $e");
          }
        }
      }
    }
  }

// ฟังก์ชันสุ่มสร้างข้อมูล transaction สำหรับ AC
  Map<String, dynamic> generateRandomACTransaction() {
    String id = 'TXN${Random().nextInt(999999).toString().padLeft(6, '0')}';
    int startHour = Random().nextInt(24);
    int startMinute = Random().nextInt(60);
    int durationHours = Random().nextInt(8) + 1; // 1 ถึง 8 ชั่วโมง
    int durationMinutes = Random().nextInt(60); // สุ่มนาทีสำหรับ duration

    String startTime =
        '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';
    String endTime =
        getEndTime(startTime, durationHours.toDouble() + durationMinutes / 60);
    double energy = Random().nextDouble() * (176 - 7) + 7; // 7 ถึง 176 kWh
    double power = Random().nextDouble() * (22 - 7) + 7; // 7 ถึง 22 kW

    return {
      '01.id': id,
      '02.startTime': startTime,
      '03.endTime': endTime,
      '04.duration': '$durationHours h $durationMinutes m',
      '05.energy(kWh)': energy.toStringAsFixed(2),
      '06.power(kW)': power.toStringAsFixed(2),
      '07.status': 'Completed'
    };
  }

// ฟังก์ชันสุ่มสร้างข้อมูล transaction สำหรับ DC
  Map<String, dynamic> generateRandomDCTransaction() {
    String id = 'TXN${Random().nextInt(999999).toString().padLeft(6, '0')}';
    int startHour = Random().nextInt(24);
    int startMinute = Random().nextInt(60);
    int durationHours = Random().nextInt(2); // 30 นาทีถึง 2 ชั่วโมง
    int durationMinutes = Random().nextInt(60); // สุ่มนาทีสำหรับ duration

    String startTime =
        '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';
    String endTime =
        getEndTime(startTime, durationHours.toDouble() + durationMinutes / 60);
    double energy = Random().nextDouble() * (300 - 25) + 25; // 25 ถึง 300 kWh
    double power = Random().nextDouble() * (150 - 50) + 50; // 50 ถึง 150 kW

    return {
      '01.id': id,
      '02.startTime': startTime,
      '03.endTime': endTime,
      '04.duration': '$durationHours h $durationMinutes m',
      '05.energy(kWh)': energy.toStringAsFixed(2),
      '06.power(kW)': power.toStringAsFixed(2),
      '07.status': 'Completed'
    };
  }

// ฟังก์ชันคำนวณเวลาสิ้นสุด รวมถึงนาทีด้วย
  String getEndTime(String startTime, double durationHours) {
    List<String> timeParts = startTime.split(':');
    int startHour = int.parse(timeParts[0]);
    int startMinute = int.parse(timeParts[1]);

    // คำนวณจำนวนชั่วโมงและนาทีจาก durationHours
    int durationInMinutes =
        (durationHours * 60).toInt(); // แปลงชั่วโมงทศนิยมเป็นนาที
    int totalMinutes = startMinute + durationInMinutes;
    int endHour = (startHour + totalMinutes ~/ 60) % 24; // คำนวณชั่วโมง
    int endMinute = totalMinutes % 60; // คำนวณนาที

    return '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
  }

// ฟังก์ชันสำหรับจำนวนวันในแต่ละเดือน (ไม่รวม leap year)
  int getDaysInMonth(String month) {
    switch (month) {
      case '02.February':
        return 29; // leap year
      case '04.April':
      case '06.June':
      case '09.September':
      case '11.November':
        return 30;
      default:
        return 31;
    }
  }

  //TODO: Fetch infomation from Firestore

  // ฟังก์ชันดึงข้อมูลจำนวน session จาก Firestore สำหรับ AC หรือ DC
  Future<String> getSessionData(String type, String selectedStation) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MM.MMMM').format(now); // เช่น 01.January
    String currentDate =
        DateFormat('yyyy-MM-dd').format(now); // เช่น 2024-01-01

    String pathBase =
        "/Stations/$selectedStation/Connector Daily Charging Statistics/$currentMonth/Transactions/$currentDate";

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.doc(pathBase).get();
    List<dynamic>? transactions = snapshot.data()?[type];

    return transactions?.length.toString() ?? "0";
  }

// ฟังก์ชันดึงข้อมูล duration จาก Firestore สำหรับ AC หรือ DC
  Future<String> getDurationData(String type, String selectedStation) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MM.MMMM').format(now); // เช่น 01.January
    String currentDate =
        DateFormat('yyyy-MM-dd').format(now); // เช่น 2024-01-01

    String pathBase =
        "/Stations/$selectedStation/Connector Daily Charging Statistics/$currentMonth/Transactions/$currentDate";

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.doc(pathBase).get();

      if (snapshot.exists) {
        List<dynamic>? transactions = snapshot.data()?[type];

        // ตรวจสอบว่ามี transaction หรือไม่
        if (transactions != null) {
          int totalMinutes = 0;

          transactions.forEach((transaction) {
            String duration = transaction['04.duration'];
            totalMinutes += parseDurationToMinutes(duration);
          });

          int hours = totalMinutes ~/ 60;
          int minutes = totalMinutes % 60;
          return "${hours}h ${minutes}m";
        } else {
          return "0h 0m";
        }
      } else {
        return "0h 0m";
      }
    } catch (e) {
      return "0h 0m"; // ส่งค่า default กลับเมื่อเกิดข้อผิดพลาด
    }
  }

  // ฟังก์ชันดึงข้อมูลพลังงานจาก Firestore สำหรับ AC หรือ DC
  Future<String> getEnergyData(String type, String selectedStation) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MM.MMMM').format(now); // เช่น 01.January
    String currentDate =
        DateFormat('yyyy-MM-dd').format(now); // เช่น 2024-01-01

    String pathBase =
        "/Stations/$selectedStation/Connector Daily Charging Statistics/$currentMonth/Transactions/$currentDate";

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.doc(pathBase).get();
    List<dynamic>? transactions = snapshot.data()?[type];

    double totalEnergy = 0.0;
    transactions?.forEach((transaction) {
      totalEnergy += double.parse(transaction['05.energy(kWh)']);
    });

    return totalEnergy.toStringAsFixed(2);
  }

  // ฟังก์ชันดึงข้อมูล power จาก Firestore สำหรับ AC หรือ DC
  Future<String> getPowerData(String type, String selectedStation) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MM.MMMM').format(now); // เช่น 01.January
    String currentDate =
        DateFormat('yyyy-MM-dd').format(now); // เช่น 2024-01-01

    String pathBase =
        "/Stations/$selectedStation/Connector Daily Charging Statistics/$currentMonth/Transactions/$currentDate";

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.doc(pathBase).get();
    List<dynamic>? transactions = snapshot.data()?[type];

    double totalPower = 0.0;
    transactions?.forEach((transaction) {
      totalPower += double.parse(transaction['06.power(kW)']);
    });

    return totalPower.toStringAsFixed(2);
  }

// Helper function สำหรับแปลง duration เป็น minutes
  int parseDurationToMinutes(String duration) {
    try {
      // ลบช่องว่างส่วนเกิน และแยกค่าออกเป็นส่วนชั่วโมงและนาที
      duration = duration.replaceAll(' h', 'h').replaceAll(' m', 'm');
      List<String> parts = duration.split(' ');

      int hours = 0;
      int minutes = 0;

      // ตรวจสอบว่าแต่ละส่วนเป็นชั่วโมงหรือนาที
      parts.forEach((part) {
        if (part.contains('h')) {
          hours = int.parse(part.replaceAll('h', '').trim());
        } else if (part.contains('m')) {
          minutes = int.parse(part.replaceAll('m', '').trim());
        }
      });

      return hours * 60 + minutes;
    } catch (e) {
      print("Error parsing duration to minutes: $e");
      return 0; // ถ้ามีข้อผิดพลาด คืนค่า 0
    }
  }

  // ฟังก์ชันรวม session ของ AC และ DC
  Future<int> calculateTotalSessions(String selectedStation) async {
    int acSessions = int.parse(await getSessionData("AC", selectedStation));
    int dcSessions = int.parse(await getSessionData("DC", selectedStation));
    return acSessions + dcSessions;
  }

  // ฟังก์ชันรวม duration ของ AC และ DC
  Future<String> calculateTotalDuration(String selectedStation) async {
    String acDuration = await getDurationData("AC", selectedStation);
    String dcDuration = await getDurationData("DC", selectedStation);
    return sumDurations(acDuration, dcDuration);
  }

  // ฟังก์ชันรวมค่า duration ของ AC และ DC
  String sumDurations(String duration1, String duration2) {
    int minutes1 = parseDurationToMinutes(duration1);
    int minutes2 = parseDurationToMinutes(duration2);

    int totalMinutes = minutes1 + minutes2;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    return "${hours}h ${minutes}m";
  }

  // ฟังก์ชันรวมพลังงาน (Energy) ของ AC และ DC
  Future<int> calculateTotalEnergy(String selectedStation) async {
    double acEnergy = double.parse(await getEnergyData("AC", selectedStation));
    double dcEnergy = double.parse(await getEnergyData("DC", selectedStation));
    return (acEnergy + dcEnergy).toInt();
  }

  // ฟังก์ชันรวม power ของ AC และ DC
  Future<double> calculateTotalPower(String selectedStation) async {
    double acPower = double.parse(await getPowerData("AC", selectedStation));
    double dcPower = double.parse(await getPowerData("DC", selectedStation));
    return acPower + dcPower;
  }

  @override
  Widget build(BuildContext context) {
    final selectedStation =
        Provider.of<StationProvider>(context).selectedStation;

    return Container(
      width: 500,
      height: 515,
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: Theme_Colors.general_gradient_mainborder,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(50),
        color: Theme_Colors.black,
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(255, 0, 0, 0), blurRadius: 10)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 15,
            height: 180,
            decoration: BoxDecoration(
                gradient: Theme_Colors.general_gradient_subborder_left,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Theme_Colors.orange,
                  )
                ],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
          ),
          SizedBox(
            width: 17,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    child: ShaderMask(
                      shaderCallback: (bounds) => Theme_Colors
                          .general_gradient_maintext
                          .createShader(bounds),
                      child: Container(
                        width: 410,
                        child: Text(
                          'CONNECTOR\nDAILY CHARGING STATISTICS',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            shadows: [
                              Shadow(
                                color: Color(0xFFFFEEBB).withOpacity(0.8),
                                blurRadius: 10,
                                offset: Offset(0, 0),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 0,
                    child: Text(
                      'CHARGER 1 & CHARGER 2',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                        color: Colors.white,
                        letterSpacing: 5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Container(
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSessionRow(selectedStation),
                    _buildDurationRow(selectedStation),
                    _buildPowerRow(selectedStation),
                    _buildEnergyRow(selectedStation),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            width: 17,
          ),
          Container(
            width: 15,
            height: 180,
            decoration: BoxDecoration(
                gradient: Theme_Colors.general_gradient_subborder_right,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Theme_Colors.orange,
                  )
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionRow(String selectedStation) {
    return Container(
      width: 430,
      height: 86,
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: Theme_Colors.information_gradient_orange,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<String>(
                future: getSessionData("DC", selectedStation),
                builder: (context, snapshot) {
                  return DC_Time(
                    name: 'DC',
                    value: snapshot.data ?? '0',
                    unit: 'TIMES',
                    max_value: 20,
                  );
                },
              ),
              FutureBuilder<String>(
                future: getSessionData("AC", selectedStation),
                builder: (context, snapshot) {
                  return AC_Time(
                    name: 'AC',
                    value: snapshot.data ?? '0',
                    unit: 'TIMES',
                    max_value: 20,
                  );
                },
              ),
            ],
          ),
          FutureBuilder<int>(
            future: calculateTotalSessions(selectedStation),
            builder: (context, snapshot) {
              return Total_ACDC_Time(
                name: 'Total Number of Sessions',
                value: snapshot.data?.toString() ?? '0',
                unit: 'TIMES',
                max_value: 40,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDurationRow(String selectedStation) {
    return Container(
      width: 430,
      height: 86,
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: Theme_Colors.information_gradient_orange,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<String>(
                future: getDurationData("DC", selectedStation),
                builder: (context, snapshot) {
                  return DC_Duration(
                    name: 'DC',
                    time_value: snapshot.data ?? '0',
                    unit: 'HR',
                    max_value: 100,
                  );
                },
              ),
              FutureBuilder<String>(
                future: getDurationData("AC", selectedStation),
                builder: (context, snapshot) {
                  return AC_Duration(
                    name: 'AC',
                    time_value: snapshot.data ?? '0',
                    unit: 'HR',
                    max_value: 100,
                  );
                },
              ),
            ],
          ),
          FutureBuilder<String>(
            future: calculateTotalDuration(selectedStation),
            builder: (context, snapshot) {
              return Total_ACDC_Duration(
                name: 'Total Charging Duration',
                time_value: snapshot.data ?? '0',
                unit: 'HR',
                max_value: 50,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPowerRow(String selectedStation) {
    return Container(
      width: 430,
      height: 86,
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: Theme_Colors.information_gradient_orange,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<String>(
                future: getPowerData("DC", selectedStation),
                builder: (context, snapshot) {
                  return DC_Usage(
                    name: 'DC',
                    value: snapshot.data ?? '0',
                    unit: 'KW',
                    max_value: 2000,
                  );
                },
              ),
              FutureBuilder<String>(
                future: getPowerData("AC", selectedStation),
                builder: (context, snapshot) {
                  return AC_Usage(
                    name: 'AC',
                    value: snapshot.data ?? '0',
                    unit: 'KW',
                    max_value: 2000,
                  );
                },
              ),
            ],
          ),
          FutureBuilder<double>(
            future: calculateTotalPower(selectedStation),
            builder: (context, snapshot) {
              return Total_ACDC_Usage(
                name: 'Total Power',
                value: snapshot.data?.toString() ?? '0',
                unit: 'KW',
                max_value: 4000,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyRow(String selectedStation) {
    return Container(
      width: 430,
      height: 86,
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: Theme_Colors.information_gradient_orange,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<String>(
                future: getEnergyData("DC", selectedStation),
                builder: (context, snapshot) {
                  return DC_Usage(
                    name: 'DC',
                    value: snapshot.data ?? '0',
                    unit: 'KWH',
                    max_value: 3000,
                  );
                },
              ),
              FutureBuilder<String>(
                future: getEnergyData("AC", selectedStation),
                builder: (context, snapshot) {
                  return AC_Usage(
                    name: 'AC',
                    value: snapshot.data ?? '0',
                    unit: 'KWH',
                    max_value: 3000,
                  );
                },
              ),
            ],
          ),
          FutureBuilder<int>(
            future: calculateTotalEnergy(selectedStation),
            builder: (context, snapshot) {
              return Total_ACDC_Usage(
                name: 'Total Energy',
                value: snapshot.data?.toString() ?? '0',
                unit: 'KWH',
                max_value: 6000,
              );
            },
          ),
        ],
      ),
    );
  }
}

// TODO: Widget

class AC_Time extends StatelessWidget {
  final String name;
  final String value;
  final String unit;
  final int max_value;

  const AC_Time({
    super.key,
    required this.name,
    required this.value,
    required this.unit,
    required this.max_value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 190) / max_value;

    return Container(
      width: 190,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme_Colors.white,
                  shadows: [
                    Shadow(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => Theme_Colors
                        .tlm_gradient_orange_value
                        .createShader(bounds),
                    child: Text(
                      '$value $unit',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 190,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                  ),
                  Container(
                    width: widthValue,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: Theme_Colors.tlm_gradient_orange_value),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class DC_Time extends StatelessWidget {
  final String name;
  final String value;
  final String unit;
  final int max_value;

  const DC_Time({
    super.key,
    required this.name,
    required this.value,
    required this.unit,
    required this.max_value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 190) / max_value;

    return Container(
      width: 190,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme_Colors.white,
                  shadows: [
                    Shadow(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => Theme_Colors
                        .tlm_gradient_orange_value
                        .createShader(bounds),
                    child: Text(
                      '$value $unit',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 190,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                  ),
                  Container(
                    width: widthValue,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: Theme_Colors.tlm_gradient_orange_value),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class Total_ACDC_Time extends StatelessWidget {
  final String name;
  final String value;
  final String unit;
  final int max_value;

  const Total_ACDC_Time({
    super.key,
    required this.name,
    required this.value,
    required this.unit,
    required this.max_value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 395) / max_value;
    return Container(
      width: 395,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme_Colors.white,
                  shadows: [
                    Shadow(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => Theme_Colors
                        .tlm_gradient_orange_value
                        .createShader(bounds),
                    child: Text(
                      '$value $unit',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    ' / LAST 24 HR',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 395,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                  ),
                  Container(
                    width: widthValue,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: Theme_Colors.tlm_gradient_orange_value),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class AC_Usage extends StatelessWidget {
  final String name;
  final String value;
  final String unit;
  final int max_value;

  const AC_Usage({
    super.key,
    required this.name,
    required this.value,
    required this.unit,
    required this.max_value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 190) / max_value;

    return Container(
      width: 190,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme_Colors.white,
                  shadows: [
                    Shadow(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => Theme_Colors
                        .tlm_gradient_orange_value
                        .createShader(bounds),
                    child: Text(
                      value == 'TIMES'
                          ? '$value $unit'
                          : '${NumberFormat("#,##0.00").format(double.tryParse(value))} $unit',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 190,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                  ),
                  Container(
                    width: widthValue,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: Theme_Colors.tlm_gradient_orange_value),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class DC_Usage extends StatelessWidget {
  final String name;
  final String value;
  final String unit;
  final int max_value;

  const DC_Usage({
    super.key,
    required this.name,
    required this.value,
    required this.unit,
    required this.max_value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 190) / max_value;

    return Container(
      width: 190,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme_Colors.white,
                  shadows: [
                    Shadow(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => Theme_Colors
                        .tlm_gradient_orange_value
                        .createShader(bounds),
                    child: Text(
                      '${NumberFormat("#,##0.00").format(double.tryParse(value))} $unit',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 190,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                  ),
                  Container(
                    width: widthValue,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: Theme_Colors.tlm_gradient_orange_value),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class Total_ACDC_Usage extends StatelessWidget {
  final String name;
  final String value;
  final String unit;
  final int max_value;

  const Total_ACDC_Usage({
    super.key,
    required this.name,
    required this.value,
    required this.unit,
    required this.max_value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 395) / max_value;
    return Container(
      width: 395,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme_Colors.white,
                  shadows: [
                    Shadow(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => Theme_Colors
                        .tlm_gradient_orange_value
                        .createShader(bounds),
                    child: Text(
                      '${NumberFormat("#,##0.00").format(double.tryParse(value))} $unit',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    ' / LAST 24 HR',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 395,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                  ),
                  Container(
                    width: widthValue,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: Theme_Colors.tlm_gradient_orange_value),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class AC_Duration extends StatelessWidget {
  final String name;
  final String time_value;
  final String unit;
  final double max_value;

  const AC_Duration({
    super.key,
    required this.name,
    required this.time_value,
    required this.unit,
    required this.max_value,
  });

  @override
  Widget build(BuildContext context) {
    double widthValue = 0.0; // ตัวแปรเก็บความกว้าง

    // ฟังก์ชันแปลงจากเวลา "4h 53m" เป็นชั่วโมงทศนิยม และคำนวณความกว้าง
    double calculateWidth(String time, double maxValue, double maxWidth) {
      try {
        if (time.isEmpty || !time.contains('h') || !time.contains('m')) {
          throw RangeError("Invalid time format");
        }

        // แยก "xh ym" เป็นชั่วโมงและนาที
        List<String> parts = time.split(' ');
        if (parts.length < 2) throw RangeError("Invalid time parts");

        int hours = int.parse(parts[0].replaceAll('h', '').trim());
        int minutes = int.parse(parts[1].replaceAll('m', '').trim());

        // คำนวณชั่วโมงทศนิยมและบัญญัติไตรยางค์เพื่อหาความกว้าง
        double decimalHours = hours + (minutes / 60);
        return (decimalHours * maxWidth) / maxValue;
      } catch (e) {
        print("Error in calculateWidth: $e");
        return 0.0; // ถ้ามีข้อผิดพลาด ให้คืนค่า 0
      }
    }

    String formatTime(String time) {
      try {
        if (time.isEmpty || !time.contains('h') || !time.contains('m')) {
          throw RangeError("Invalid time format");
        }

        List<String> parts = time.split(' ');
        if (parts.length < 2) throw RangeError("Invalid time parts");

        int hours = int.parse(parts[0].replaceAll('h', '').trim());
        int minutes = int.parse(parts[1].replaceAll('m', '').trim());

        // ถ้าชั่วโมงเป็น 0 ให้แสดงแค่นาที
        if (hours == 0) {
          return '$minutes MIN';
        } else {
          return '$hours HR $minutes MIN';
        }
      } catch (e) {
        print("Error in formatTime: $e");
        return "0 MIN"; // คืนค่าเริ่มต้นหากมีข้อผิดพลาด
      }
    }

    widthValue = calculateWidth(time_value, max_value, 190);
    String timeText = formatTime(time_value);

    return Container(
      width: 190,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme_Colors.white,
                  shadows: [
                    Shadow(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => Theme_Colors
                        .tlm_gradient_orange_value
                        .createShader(bounds),
                    child: Text(
                      '$timeText',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 190,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                  ),
                  Container(
                    width: widthValue,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: Theme_Colors.tlm_gradient_orange_value),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class DC_Duration extends StatelessWidget {
  final String name;
  final String time_value;
  final String unit;
  final double max_value;

  const DC_Duration({
    super.key,
    required this.name,
    required this.time_value,
    required this.unit,
    required this.max_value,
  });

  @override
  Widget build(BuildContext context) {
    double widthValue = 0.0; // ตัวแปรเก็บความกว้าง

    // ฟังก์ชันแปลงจากเวลา "4h 53m" เป็นชั่วโมงทศนิยม และคำนวณความกว้าง
    double calculateWidth(String time, double maxValue, double maxWidth) {
      try {
        if (time.isEmpty || !time.contains('h') || !time.contains('m')) {
          throw RangeError("Invalid time format");
        }

        // แยก "xh ym" เป็นชั่วโมงและนาที
        List<String> parts = time.split(' ');
        if (parts.length < 2) throw RangeError("Invalid time parts");

        int hours = int.parse(parts[0].replaceAll('h', '').trim());
        int minutes = int.parse(parts[1].replaceAll('m', '').trim());

        // คำนวณชั่วโมงทศนิยมและบัญญัติไตรยางค์เพื่อหาความกว้าง
        double decimalHours = hours + (minutes / 60);
        return (decimalHours * maxWidth) / maxValue;
      } catch (e) {
        print("Error in calculateWidth: $e");
        return 0.0; // ถ้ามีข้อผิดพลาด ให้คืนค่า 0
      }
    }

    String formatTime(String time) {
      try {
        if (time.isEmpty || !time.contains('h') || !time.contains('m')) {
          throw RangeError("Invalid time format");
        }

        List<String> parts = time.split(' ');
        if (parts.length < 2) throw RangeError("Invalid time parts");

        int hours = int.parse(parts[0].replaceAll('h', '').trim());
        int minutes = int.parse(parts[1].replaceAll('m', '').trim());

        // ถ้าชั่วโมงเป็น 0 ให้แสดงแค่นาที
        if (hours == 0) {
          return '$minutes MIN';
        } else {
          return '$hours HR $minutes MIN';
        }
      } catch (e) {
        print("Error in formatTime: $e");
        return "0 MIN"; // คืนค่าเริ่มต้นหากมีข้อผิดพลาด
      }
    }

    widthValue = calculateWidth(time_value, max_value, 190);
    String timeText = formatTime(time_value);

    return Container(
      width: 190,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme_Colors.white,
                  shadows: [
                    Shadow(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => Theme_Colors
                        .tlm_gradient_orange_value
                        .createShader(bounds),
                    child: Text(
                      '$timeText',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 190,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                  ),
                  Container(
                    width: widthValue,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: Theme_Colors.tlm_gradient_orange_value),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class Total_ACDC_Duration extends StatelessWidget {
  final String name;
  final String time_value;
  final String unit;
  final double max_value;

  const Total_ACDC_Duration({
    super.key,
    required this.name,
    required this.time_value,
    required this.unit,
    required this.max_value,
  });

  @override
  Widget build(BuildContext context) {
    double widthValue = 0.0; // ตัวแปรเก็บความกว้าง

    // ฟังก์ชันแปลงจากเวลา xh ym เป็นชั่วโมงทศนิยม และคำนวณความกว้าง
    double calculateWidth(String time, double maxValue, double maxWidth) {
      try {
        if (time.isEmpty || !time.contains('h') || !time.contains('m')) {
          throw RangeError("Invalid time format");
        }

        // แยก "xh ym" เป็นชั่วโมงและนาที
        List<String> parts = time.split(' ');
        if (parts.length < 2) throw RangeError("Invalid time parts");

        int hours = int.parse(parts[0].replaceAll('h', '').trim());
        int minutes = int.parse(parts[1].replaceAll('m', '').trim());

        // คำนวณชั่วโมงทศนิยมและบัญญัติไตรยางค์เพื่อหาความกว้าง
        double decimalHours = hours + (minutes / 60);
        return (decimalHours * maxWidth) / maxValue;
      } catch (e) {
        print("Error in calculateWidth: $e");
        return 0.0; // ถ้ามีข้อผิดพลาด ให้คืนค่า 0
      }
    }

    String formatTime(String time) {
      try {
        if (time.isEmpty || !time.contains('h') || !time.contains('m')) {
          throw RangeError("Invalid time format");
        }

        List<String> parts = time.split(' ');
        if (parts.length < 2) throw RangeError("Invalid time parts");

        int hours = int.parse(parts[0].replaceAll('h', '').trim());
        int minutes = int.parse(parts[1].replaceAll('m', '').trim());

        // ถ้าชั่วโมงเป็น 0 ให้แสดงแค่นาที
        if (hours == 0) {
          return '$minutes MIN';
        } else {
          return '$hours HR $minutes MIN';
        }
      } catch (e) {
        print("Error in formatTime: $e");
        return "0 MIN"; // คืนค่าเริ่มต้นหากมีข้อผิดพลาด
      }
    }

    // คำนวณความกว้างของแถบตามจำนวนเวลา
    widthValue = calculateWidth(time_value, max_value, 190);
    // แปลงเวลาให้อยู่ในรูปแบบที่อ่านง่าย
    String timeText = formatTime(time_value);

    return Container(
      width: 395,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Theme_Colors.white,
                  shadows: [
                    Shadow(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => Theme_Colors
                        .tlm_gradient_orange_value
                        .createShader(bounds),
                    child: Text(
                      '$timeText',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    ' / LAST 24 HR',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 395,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                  ),
                  Container(
                    width: widthValue,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: Theme_Colors.tlm_gradient_orange_value),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
