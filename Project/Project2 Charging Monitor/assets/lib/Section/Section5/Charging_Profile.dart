import 'dart:async';
import 'dart:math';
import 'package:dashboard_ems/Component/Theme.dart';
import 'package:dashboard_ems/Section/Section2/Main_Information.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Charging_Profile extends StatefulWidget {
  const Charging_Profile({super.key});

  @override
  State<Charging_Profile> createState() => _Charging_ProfileState();
}

class _Charging_ProfileState extends State<Charging_Profile> {
  /*
      ความสัมพันธ์ระหว่าง 4 ประเภท:
     EV Net Load (kW): พลังงานสุทธิที่ต้องใช้หลังหักลบพลังงานทดแทน
    EV Station Load (kW): พลังงานทั้งหมดที่ใช้ในสถานีที่เกี่ยวข้องกับการชาร์จ EV
    Grid Demand Load (kW): พลังงานที่สถานีต้องการจากระบบไฟฟ้าหลักหลังหักลบพลังงานทดแทน
    Dynamic EV Load (kW): พลังงานที่แสดงถึงการเปลี่ยนแปลงของโหลดในการชาร์จ EV
  */

  final List<String> stationList = [
    'Bang Khen',
    'Lat Krabang',
    'Phloen Chit',
    'Thon Buri',
  ];

  @override
  void initState() {
    super.initState();
    // เรียกฟังก์ชันเพื่อบันทึกค่าตลอด 24 ชั่วโมง
    saveLoadStatisticsForAllStations(stationList);
  }

  //TODO: Save data to realtime database

  void saveLoadStatisticsForAllStations(List<String> stationList) {
    for (String station in stationList) {
      simulateLoadStatistics(station);
    }
  }

  void simulateLoadStatistics(String station) async {
    // เริ่มบันทึกตั้งแต่เวลา 00:00
    DateTime startTime = DateTime.now().toUtc().add(Duration(hours: 7));
    startTime = DateTime(startTime.year, startTime.month, startTime.day, 0, 0);

    // สิ้นสุดที่เวลา 23:59
    DateTime endTime = startTime.add(Duration(hours: 24));

    while (startTime.isBefore(endTime)) {
      // สุ่มค่า EV Load
      double evLoadAC = _randomDouble(100, 200); // AC: 100-200 kW
      double evLoadDC = _randomDouble(50, 150); // DC: 50-150 kW
      double evLoad =
          _roundToTwoDecimalPlaces(evLoadAC + evLoadDC); // รวม EV Load

      // สุ่มค่า Dynamic Charging Load (10-30% ของ EV Load)
      double dynamicChargingLoad =
          _roundToTwoDecimalPlaces(evLoad * _randomDouble(0.1, 0.3));

      // สุ่มค่า Solar และ Wind Energy (Renewable Energy)
      double solarEnergy = _roundToTwoDecimalPlaces(
          evLoad * _randomDouble(0.2, 0.5)); // 20-50% ของ EV Load
      double windEnergy = _roundToTwoDecimalPlaces(
          evLoad * _randomDouble(0.05, 0.2)); // 5-20% ของ EV Load
      double renewableEnergy = _roundToTwoDecimalPlaces(
          solarEnergy + windEnergy); // รวม Renewable Energy

      // คำนวณ EV Net Load
      double evNetLoad = _roundToTwoDecimalPlaces(evLoad - renewableEnergy);

      // คำนวณ EV Station Load
      double evStationLoad =
          _roundToTwoDecimalPlaces(evLoad + dynamicChargingLoad);

      // คำนวณ Grid Demand Load
      double gridDemandLoad =
          _roundToTwoDecimalPlaces(evStationLoad - renewableEnergy);

      // บันทึกข้อมูลลง Firebase
      saveLoadStatistics(station, startTime, evLoad, dynamicChargingLoad,
          renewableEnergy, evNetLoad, evStationLoad, gridDemandLoad);

      // เพิ่มเวลา 10 นาที
      startTime = startTime.add(Duration(minutes: 10));

      // Delay การสุ่มและบันทึกให้ตรงกับเวลา (ถ้าทำการจำลองในเวลาจริง)
      await Future.delayed(Duration(milliseconds: 500)); // จำลองการรอเวลา
    }
  }

  void saveLoadStatistics(
      String station,
      DateTime timestamp,
      double evLoad,
      double dynamicChargingLoad,
      double renewableEnergy,
      double evNetLoad,
      double evStationLoad,
      double gridDemandLoad) {
    // อัปเดตวันที่ตามเวลาจริง (เพิ่มขึ้นตามเวลาปัจจุบัน)
    String formattedDate = DateFormat('yyyy-MM-dd HH:00')
        .format(timestamp); // ใช้ HH:00 สำหรับ path ใหญ่
    String timeKey =
        DateFormat('HH:mm').format(timestamp); // ใช้ HH:mm สำหรับ path ย่อย

    Map<String, dynamic> data = {
      timeKey: {
        "1 EV Net Load": {
          "01 ev load(kW)": evLoad,
          "02 renewable energy(kW)": renewableEnergy,
          "03 net load(kW)": evNetLoad // EV Load - Renewable Energy
        },
        "2 EV Station Load": {
          "01 ev load(kW)": evLoad,
          "02 dynamic charging load(kW)": dynamicChargingLoad,
          "03 station load(kW)":
              evStationLoad // EV Load + Dynamic Charging Load
        },
        "3 Grid Demand Load": {
          "01 ev load(kW)": evLoad,
          "02 dynamic charging load(kW)": dynamicChargingLoad,
          "03 renewable energy(kW)": renewableEnergy,
          "04 grid demand load(kW)":
              gridDemandLoad // (EV Load + Dynamic Charging Load) - Renewable Energy
        },
        "4 Dynamic Charging Load": {
          "01 dynamic ev load(kW)": dynamicChargingLoad // 20% ของ EV Load
        }
      }
    };

    // Save data to Firebase under the formatted date and time key
    DatabaseReference ref = FirebaseDatabase.instance.ref(
        'Stations/$station/Daily Charging Station Load Statistics/$formattedDate');
    ref.child(timeKey).set(data[timeKey]).then((_) {
      print('Data Daily Charging Station Load saved successfully!');
    }).catchError((error) {
      print('Failed to save data: $error');
    });
  }

  // ฟังก์ชันสุ่มตัวเลขและปัดเศษเป็นทศนิยม 2 ตำแหน่ง
  double _randomDouble(double min, double max) {
    return Random().nextDouble() * (max - min) + min;
  }

  // ฟังก์ชันปัดเศษตัวเลขเป็นทศนิยม 2 ตำแหน่ง
  double _roundToTwoDecimalPlaces(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

// TODO: Widget

  @override
  Widget build(BuildContext context) {
    final selectedStation =
        Provider.of<StationProvider>(context).selectedStation;

    return Container(
      width: 800,
      height: 515,
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: Theme_Colors
              .general_gradient_mainborder, // colors: [Color(0xFFFE5000), Color(0xFFFFFFFF)],
          width: 3,
        ),
        borderRadius: BorderRadius.circular(50),
        color: Theme_Colors.black,
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(255, 0, 0, 0), blurRadius: 10)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 712,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: ShaderMask(
                            shaderCallback: (bounds) => Theme_Colors
                                .general_gradient_maintext
                                .createShader(bounds),
                            child: Text(
                              'DAILY CHARGING STATION LOAD \nSTATISTICS',
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
                        top: 10,
                        right: 0,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'CHARGER 1 & CHARGER 2',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                  color: Colors.white,
                                  letterSpacing: 5,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Theme_Colors.grap4_text,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme_Colors.grap4_text,
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'EV Station(KW)',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                            color: Theme_Colors.grap4_text,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Theme_Colors.grap1_text,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme_Colors.grap1_text,
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'EV Net(KW)',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                            color:
                                                Theme_Colors.status_available,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Theme_Colors.grap3_text,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme_Colors.grap3_text,
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Grid Demand(KW)',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                            color: Theme_Colors.grap3_text,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Theme_Colors.grap2_text,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme_Colors.grap2_text,
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Dynamic Charging(KW)',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                            color: Theme_Colors.grap2_text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 710,
            height: 400,
            child: Grap_Station_Profile(),
          )
        ],
      ),
    );
  }
}

class Grap_Station_Profile extends StatefulWidget {
  @override
  _Grap_Station_ProfileState createState() => _Grap_Station_ProfileState();
}

class _Grap_Station_ProfileState extends State<Grap_Station_Profile> {
  List<FlSpot> _line1Data = [];
  List<FlSpot> _line2Data = [];
  List<FlSpot> _line3Data = [];
  List<FlSpot> _line4Data = [];
  Set<String> loadedDataSet = Set(); // ใช้เก็บเวลาที่โหลดแล้วไม่ให้ซ้ำกัน
  List<DateTime> timeList = [];
  List<String> rangetime = [];
  String? previousStation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final selectedStation =
        Provider.of<StationProvider>(context).selectedStation;

    // ตรวจสอบว่าค่า selectedStation เปลี่ยนแปลงหรือไม่
    if (previousStation != selectedStation) {
      previousStation = selectedStation;

      // ล้างข้อมูลเก่าก่อนดึงข้อมูลใหม่
      setState(() {
        _line1Data.clear();
        _line2Data.clear();
        _line3Data.clear();
        _line4Data.clear();
        timeList.clear(); // ล้าง timeList เก่าออกก่อน
        isLoading = true;
      });

      _loadRealTimeData(selectedStation); // ดึงข้อมูลใหม่เมื่อ station เปลี่ยน
    }
  }

  Future<void> _loadRealTimeData(String selectedStation) async {
    // ดึงเวลาปัจจุบันแล้วปัดลงเป็นเลขหลักทศนิยมลงท้ายด้วย 00, 10, 20, 30, 40, 50
    DateTime currentTime = DateTime.now();
    DateTime startTime = _roundToNearestTenMinutes(currentTime
        .subtract(Duration(hours: 2))); // ย้อนหลัง 2 ชั่วโมง แต่ต้องปัดลง

    // สร้างรายการเวลาแบบเรียงจากน้อยไปมาก
    for (int i = 0; i <= 12; i++) {
      DateTime timeToQuery =
          startTime.add(Duration(minutes: i * 10)); // เพิ่มทีละ 10 นาที
      timeList.add(timeToQuery);
    }

    // เรียงลำดับเวลาโดยเปรียบเทียบชั่วโมงก่อนและตามด้วยนาที
    timeList.sort((a, b) {
      int hourCompare = a.hour.compareTo(b.hour);
      if (hourCompare == 0) {
        return a.minute
            .compareTo(b.minute); // ถ้าชั่วโมงเท่ากัน ให้เปรียบเทียบนาที
      } else {
        return hourCompare; // ถ้าชั่วโมงไม่เท่ากัน ให้เรียงตามชั่วโมง
      }
    });

    List<Map<String, dynamic>> firebaseDataList = []; // เก็บข้อมูลจาก Firebase

    // ดึงข้อมูลจาก Firebase สำหรับช่วงเวลา 2 ชั่วโมง
    for (int i = 0; i < timeList.length; i++) {
      DateTime timeToQuery = timeList[i];
      String currentDateString =
          DateFormat('yyyy-MM-dd HH:00').format(timeToQuery);
      String timeSubKey = DateFormat('HH:mm').format(timeToQuery);

      // ดึงข้อมูลจาก Firebase เฉพาะ selectedStation
      DatabaseReference ref = FirebaseDatabase.instance.ref(
          'Stations/$selectedStation/Daily Charging Station Load Statistics/$currentDateString/$timeSubKey');

      ref.get().then((snapshot) {
        if (snapshot.exists) {
          Map<dynamic, dynamic> loadData =
              snapshot.value as Map<dynamic, dynamic>;

          // ดึงค่าแต่ละตัวจาก Firebase สำหรับ 4 ประเภท
          double evNetLoad =
              loadData['1 EV Net Load']?['03 net load(kW)']?.toDouble() ?? 0.0;
          double evStationLoad = loadData['2 EV Station Load']
                      ?['03 station load(kW)']
                  ?.toDouble() ??
              0.0;
          double gridDemandLoad = loadData['3 Grid Demand Load']
                      ?['04 grid demand load(kW)']
                  ?.toDouble() ??
              0.0;
          double dynamicChargingLoad = loadData['4 Dynamic Charging Load']
                      ?['01 dynamic ev load(kW)']
                  ?.toDouble() ??
              0.0;

          // แปลงเวลาจาก DateTime ไปเป็นค่า Double ที่ใช้บนกราฟ
          double timeInDouble = timeToQuery.hour.toDouble() +
              (timeToQuery.minute.toDouble() / 60);

          // เก็บข้อมูลเป็นแผนที่ชั่วคราวก่อนที่จะทำการจัดเรียงทีหลัง
          firebaseDataList.add({
            'timeSubKey': timeSubKey, // เวลา
            'timeInDouble': timeInDouble,
            'evNetLoad': evNetLoad,
            'evStationLoad': evStationLoad,
            'gridDemandLoad': gridDemandLoad,
            'dynamicChargingLoad': dynamicChargingLoad
          });

          // เมื่อดึงข้อมูลครบแล้ว จัดเรียงข้อมูลตามเวลาและเพิ่มข้อมูลในกราฟ
          if (i == timeList.length - 1) {
            firebaseDataList.sort((a, b) {
              return a['timeInDouble'].compareTo(b['timeInDouble']);
            });

            // แสดงผลการจัดเรียงเวลาแบบเรียงจากน้อยไปมาก
            firebaseDataList.forEach((data) {
              print(
                  'Time: ${data['timeSubKey']} - evNetLoad: ${data['evNetLoad']}, evStationLoad: ${data['evStationLoad']}, gridDemandLoad: ${data['gridDemandLoad']}, dynamicChargingLoad: ${data['dynamicChargingLoad']}');
            });

            //เวลา HH:mm
            DateTime timeToAdd = DateFormat('HH:mm').parse(timeSubKey);
            List<String> formattedTimeList = timeList
                .map((time) => DateFormat('HH:mm').format(time))
                .toList();
            print('Current timeList: $formattedTimeList');

            setState(() {
              // Log การเพิ่มค่าใน _line1Data
              _line1Data = firebaseDataList.asMap().entries.map((entry) {
                int index = entry.key;
                var e = entry.value;
                print(
                    "Index: $index, evNetLoad: ${e['evNetLoad']}"); // Log การเพิ่ม FlSpot
                return FlSpot(index.toDouble(), e['evNetLoad']);
              }).toList();

              _line2Data = firebaseDataList.asMap().entries.map((entry) {
                int index = entry.key;
                var e = entry.value;
                return FlSpot(index.toDouble(), e['evStationLoad']);
              }).toList();

              _line3Data = firebaseDataList.asMap().entries.map((entry) {
                int index = entry.key;
                var e = entry.value;
                return FlSpot(index.toDouble(), e['gridDemandLoad']);
              }).toList();

              _line4Data = firebaseDataList.asMap().entries.map((entry) {
                int index = entry.key;
                var e = entry.value;

                return FlSpot(index.toDouble(), e['dynamicChargingLoad']);
              }).toList();

              isLoading = false;
            });
          }
        } else {
          print(
              'No data found at $currentDateString $timeSubKey for $selectedStation.');
        }
      }).catchError((error) {
        print('Error fetching data for $currentDateString $timeSubKey: $error');
      });
    }
  }

// ฟังก์ชันปัดค่าเวลาให้ลงท้ายด้วย 00, 10, 20, 30, 40, 50
  DateTime _roundToNearestTenMinutes(DateTime dateTime) {
    int minute = dateTime.minute;
    int roundedMinute = (minute / 10).floor() * 10;
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour,
        roundedMinute);
  }

// ฟังก์ชันการคำนวณและแสดงแกนเวลาในกราฟ
  String _formatTime(double value) {
    // ดึงเวลาจริงจากค่า value (ซึ่งเป็นค่า X ของแต่ละจุด)
    final time = DateTime.now()
        .subtract(Duration(hours: 2))
        .add(Duration(minutes: (value * 10).toInt())); // เพิ่มทีละ 10 นาที
    final roundedTime = _roundToNearestTenMinutes(
        time); // ปัดเวลาให้ลงท้ายด้วย 00, 10, 20, 30, 40, 50
    return '${roundedTime.hour}:${roundedTime.minute.toString().padLeft(2, '0')}'; // แสดงเวลาที่ปัดแล้ว
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 20),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: _line2Data,
                isCurved: true,
                color: Theme_Colors.grap4_text,
                barWidth: 2,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: Theme_Colors.grap4_gradient,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 0,
                      color: Theme_Colors.grap4_text,
                      strokeWidth: 0,
                    );
                  },
                ),
              ),
              LineChartBarData(
                spots: _line3Data,
                isCurved: true,
                color: Theme_Colors.grap3_text,
                barWidth: 2,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: Theme_Colors.grap3_gradient,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 0,
                      color: Theme_Colors.grap3_text,
                      strokeWidth: 0,
                    );
                  },
                ),
              ),
              LineChartBarData(
                spots: _line1Data,
                isCurved: true,
                color: Theme_Colors.grap1_text,
                barWidth: 2,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: Theme_Colors.grap1_gradient,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 0,
                      color: Theme_Colors.grap1_text,
                      strokeWidth: 0,
                    );
                  },
                ),
              ),
              LineChartBarData(
                spots: _line4Data,
                isCurved: true,
                color: Theme_Colors.grap2_text,
                barWidth: 2,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: Theme_Colors.grap2_gradient,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 0,
                      color: Theme_Colors.grap2_text,
                      strokeWidth: 0,
                    );
                  },
                ),
              ),
            ],
            titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0), // เพิ่ม margin ให้ label แกน Y
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      );
                    },
                    interval: 100,
                    reservedSize: 40,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // ปิดการแสดง label ที่แกน Y ด้านขวา
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      // ตรวจสอบว่าค่า value อยู่ในช่วง index ของ timeList หรือไม่
                      if (value >= 0 && value < timeList.length) {
                        DateTime time = timeList[value.toInt()];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('HH:mm')
                                .format(time), // แสดงผลเวลาในรูปแบบ HH:mm
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        );
                      } else {
                        return SizedBox(); // ไม่แสดงค่าเวลา
                      }
                    },
                    interval: 1, // ให้แสดงผลทุกๆ ค่าใน timeList
                    reservedSize: 22,
                  ),
                ),
                topTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                ))),
            gridData: FlGridData(
              show: true,
              horizontalInterval: 100, // กำหนดระยะห่างของ grid ในแนวนอน
              verticalInterval: 1, // กำหนดระยะห่างของ grid ในแนวตั้ง
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.white.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            minX: 0, // เริ่มต้นที่ index 0
            maxX: timeList.length - 1, // ใช้ความยาวของ timeList เป็น maxX

            minY: 0,
            maxY: 500,
          ),
        ),
      ),
    );
  }
}



/*

class Grap_Station_Profile extends StatefulWidget {
  @override
  _Grap_Station_ProfileState createState() => _Grap_Station_ProfileState();
}

class _Grap_Station_ProfileState extends State<Grap_Station_Profile> {
  final Random _random = Random();
  late Timer _timer;

  // Create lists for each line of data
  List<FlSpot> _line1Data = [];
  List<FlSpot> _line2Data = [];
  List<FlSpot> _line3Data = [];
  List<FlSpot> _line4Data = [];

  // Define the start time for the graph
  DateTime _startTime = DateTime.now()
      .toUtc()
      .add(Duration(hours: 7))
      .subtract(Duration(hours: 2));

  double _currentXValue = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startTimer();
  }

  void _initializeData() {
    for (int i = 0; i < 12; i++) {
      _line1Data.add(FlSpot(_currentXValue, 450 + _random.nextDouble() * 50));
      _line2Data.add(FlSpot(_currentXValue, 180 + _random.nextDouble() * 20));
      _line3Data.add(FlSpot(_currentXValue, 100 + _random.nextDouble() * 50));
      _line4Data.add(FlSpot(_currentXValue, _random.nextDouble() * 50));
      _currentXValue += 1;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 10), (timer) {
      setState(() {
        _line1Data.add(FlSpot(_currentXValue, 450 + _random.nextDouble() * 50));
        _line2Data.add(FlSpot(_currentXValue, 180 + _random.nextDouble() * 20));
        _line3Data.add(FlSpot(_currentXValue, 100 + _random.nextDouble() * 50));
        _line4Data.add(FlSpot(_currentXValue, _random.nextDouble() * 50));

        if (_line1Data.length > 12) {
          _line1Data.removeAt(0);
          _line2Data.removeAt(0);
          _line3Data.removeAt(0);
          _line4Data.removeAt(0);
        }

        _currentXValue += 1;
      });
    });
  }

  String _formatTime(double value) {
    final time =
        DateTime.now().subtract(Duration(minutes: (12 - value).toInt() * 10));
    final minutes = (time.minute ~/ 10) * 10;
    return '${time.hour}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 20),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: _line1Data,
                isCurved: true,
                color: Theme_Colors.grap1_text,
                barWidth: 2,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: Theme_Colors.grap1_gradient,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 0,
                      color: Theme_Colors.grap1_text,
                      strokeWidth: 0,
                    );
                  },
                ),
              ),
              LineChartBarData(
                spots: _line2Data,
                isCurved: true,
                color: Theme_Colors.grap2_text,
                barWidth: 2,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: Theme_Colors.grap2_gradient,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 0,
                      color: Theme_Colors.grap2_text,
                      strokeWidth: 0,
                    );
                  },
                ),
              ),
              LineChartBarData(
                spots: _line3Data,
                isCurved: true,
                color: Theme_Colors.grap3_text,
                barWidth: 2,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: Theme_Colors.grap3_gradient,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 0,
                      color: Theme_Colors.grap3_text,
                      strokeWidth: 0,
                    );
                  },
                ),
              ),
              LineChartBarData(
                spots: _line4Data,
                isCurved: true,
                color: Theme_Colors.grap4_text,
                barWidth: 2,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: Theme_Colors.grap4_gradient,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 0,
                      color: Theme_Colors.grap4_text,
                      strokeWidth: 0,
                    );
                  },
                ),
              ),
            ],
            titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0), // เพิ่ม margin ให้ label แกน Y
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      );
                    },
                    interval: 100,
                    reservedSize: 40,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // ปิดการแสดง label ที่แกน Y ด้านขวา
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _formatTime(value),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      );
                    },
                    interval: 1,
                    reservedSize: 22,
                  ),
                ),
                topTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: false,
                ))),
            gridData: FlGridData(
              show: true,
              horizontalInterval: 100, // กำหนดระยะห่างของ grid ในแนวนอน
              verticalInterval: 1, // กำหนดระยะห่างของ grid ในแนวตั้ง
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.white.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            minX: _line1Data.isNotEmpty ? _line1Data.first.x : 0,
            maxX: _line1Data.isNotEmpty ? _line1Data.last.x : 0,
            minY: 0,
            maxY: 500,
          ),
        ),
      ),
    );
  }
}


 */