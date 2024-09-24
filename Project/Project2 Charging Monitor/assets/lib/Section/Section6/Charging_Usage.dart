import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_ems/Component/Theme.dart';
import 'package:dashboard_ems/Section/Section1/ChargerStatusNotifier.dart';
import 'package:dashboard_ems/Section/Section2/Main_Information.dart';
import 'package:dashboard_ems/Section/Section6/Charging_UsageChangeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Charging_Usage extends StatefulWidget {
  const Charging_Usage({super.key});

  @override
  State<Charging_Usage> createState() => _Charging_UsageState();
}

class _Charging_UsageState extends State<Charging_Usage> {
// TODO: Query information from Firestore

  // List เก็บค่าพลังงานแต่ละเดือน
  List<double> acMonthlyValues = List.generate(12, (_) => 0.0);
  List<double> dcMonthlyValues = List.generate(12, (_) => 0.0);
  List<double> totalMonthlyEnergy = List.generate(12, (_) => 0.0);

  String? _previousSelectedStation;

  @override
  void initState() {
    super.initState();
    fetchEnergyData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedStation =
        Provider.of<StationProvider>(context).selectedStation;
    if (_previousSelectedStation != selectedStation) {
      _previousSelectedStation = selectedStation;
      fetchEnergyData();
    }
  }

  // ฟังก์ชันดึงข้อมูลพลังงานสำหรับทั้ง AC และ DC ในแต่ละเดือน
  Future<Map<String, List<double>>> getEnergyACDCMonthly(
      String selectedStation) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

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
      //'10.October',
      //'11.November',
      //'12.December',
    ];

    List<double> acMonthlyValues = [];
    List<double> dcMonthlyValues = [];
    List<double> totalMonthlyEnergy = [];

    for (String month in months) {
      try {
        String pathBase =
            "/Stations/$selectedStation/Connector Daily Charging Statistics/$month/Transactions";

        QuerySnapshot<Map<String, dynamic>> snapshot =
            await firestore.collection(pathBase).get();

        double acTotal = 0.0;
        double dcTotal = 0.0;

        for (var doc in snapshot.docs) {
          Map<String, dynamic>? data = doc.data();

          if (data != null) {
            // ดึงข้อมูลพลังงานจาก AC
            List<dynamic>? acTransactions = data['AC'];
            if (acTransactions != null) {
              for (var transaction in acTransactions) {
                String energyStr = transaction['05.energy(kWh)'] ?? '0';
                acTotal += double.tryParse(energyStr) ?? 0.0;
              }
            }

            // ดึงข้อมูลพลังงานจาก DC
            List<dynamic>? dcTransactions = data['DC'];
            if (dcTransactions != null) {
              for (var transaction in dcTransactions) {
                String energyStr = transaction['05.energy(kWh)'] ?? '0';
                dcTotal += double.tryParse(energyStr) ?? 0.0;
              }
            }
          }
        }

        acMonthlyValues.add(acTotal);
        dcMonthlyValues.add(dcTotal);
        totalMonthlyEnergy.add(acTotal + dcTotal);
      } catch (e) {
        acMonthlyValues.add(0);
        dcMonthlyValues.add(0);
      }
    }

    return {
      'AC': acMonthlyValues,
      'DC': dcMonthlyValues,
      'Total': totalMonthlyEnergy,
    };
  }

  // ดึงข้อมูลตาม selectedStation ที่ผู้ใช้เลือก
  Future<void> fetchEnergyData() async {
    final selectedStation =
        Provider.of<StationProvider>(context, listen: false).selectedStation;

    Map<String, List<double>> energyData =
        await getEnergyACDCMonthly(selectedStation);

    setState(() {
      acMonthlyValues = energyData['AC'] ?? [];
      dcMonthlyValues = energyData['DC'] ?? [];
      totalMonthlyEnergy = energyData['Total'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // ใช้การตรวจจับ selectedStation ทุกครั้งที่มีการเปลี่ยนแปลง
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
                        width: 430,
                        child: Text(
                          'CONNECTOR\nANNUAL CHARGING STATISTICS',
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
                    buildTotalEnergyChargingUsage(context),
                    buildTotalDCChargingUsage(),
                    buildTotalACChargingUsage(),
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

  // สร้าง widget สำหรับการแสดงผล Total Energy Charging Usage
  Widget buildTotalEnergyChargingUsage(BuildContext context) {
    int currentMonth = DateTime.now().month;
    // คำนวณค่า totalEnergy จาก totalMonthlyEnergy
    double totalEnergy = totalMonthlyEnergy.isNotEmpty
        ? totalMonthlyEnergy.reduce((a, b) => ((a + b)))
        : 0;

    // ใช้ addPostFrameCallback เพื่อรันการอัปเดตหลังจาก build phase เสร็จสิ้น
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final energyProvider =
          Provider.of<EnergyProvider>(context, listen: false);
      energyProvider.updateEnergies(totalEnergy); // อัปเดตค่าใน EnergyProvider
    });

    // คืนค่า Widget ที่แสดงผลการใช้พลังงานทั้งหมด
    return Total_Energy_Charging_Usage(
      name: 'Total Energy Charging',
      total_value: totalEnergy.toString(),
      monthly_values: totalMonthlyEnergy.map((e) => e.toString()).toList(),
    );
  }

  // ฟังก์ชันแสดงผล Total AC Charging Usage
  Widget buildTotalACChargingUsage() {
    int currentMonth = DateTime.now().month;
    double totalAcValue = acMonthlyValues.isNotEmpty
        ? acMonthlyValues.reduce((a, b) => ((a + b)))
        : 0;

    return Total_Energy_Charging_Usage(
      name: 'Total AC Charging',
      total_value: totalAcValue.toString(),
      monthly_values: acMonthlyValues.map((e) => e.toString()).toList(),
    );
  }

  // ฟังก์ชันแสดงผล Total DC Charging Usage
  Widget buildTotalDCChargingUsage() {
    int currentMonth = DateTime.now().month;
    double totalDcValue = dcMonthlyValues.isNotEmpty
        ? dcMonthlyValues.reduce((a, b) => ((a + b)))
        : 0;

    return Total_Energy_Charging_Usage(
      name: 'Total DC Charging',
      total_value: totalDcValue.toString(),
      monthly_values: dcMonthlyValues.map((e) => e.toString()).toList(),
    );
  }
}

class Total_Energy_Charging_Usage extends StatefulWidget {
  final String name;
  final List<String> monthly_values; // รับค่ารายเดือนเข้ามาเป็นลิสต์ของ string
  final String total_value;

  const Total_Energy_Charging_Usage({
    super.key,
    required this.name,
    required this.total_value,
    required this.monthly_values, // เพิ่มรับค่ารายเดือน
  });

  @override
  State<Total_Energy_Charging_Usage> createState() =>
      _Total_Energy_Charging_UsageState();
}

class _Total_Energy_Charging_UsageState
    extends State<Total_Energy_Charging_Usage> {
  @override
  Widget build(BuildContext context) {
    // คำนวณค่าความสูงของบาร์รายเดือน
    List<double> heightValues = widget.monthly_values.isEmpty
        ? List.generate(
            12, (_) => 1.0) // ถ้าลิสต์ว่าง กำหนดให้ทุกเดือนมีค่าเป็น 1.0
        : widget.monthly_values.map((value) {
            double parsedValue = (double.tryParse(value) ?? 1.0) * 50 / 100000;
            return parsedValue == 0.0 ? 1.0 : parsedValue;
          }).toList();
    // รายชื่อเดือน
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return Container(
      width: 430,
      height: 120,
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: Theme_Colors.usage_gradient_orange_border,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 110,
            width: 410,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Theme_Colors.white,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.8),
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
                                .usage_gradient_orange_text
                                .createShader(bounds),
                            child: Text(
                              '${NumberFormat("#,##0.00").format(double.parse(widget.total_value))} KWH',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Text(
                            ' / Year In 2024',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(12, (index) {
                    return BarChart(
                      value_per_month:
                          index < heightValues.length ? heightValues[index] : 1,
                      month: months[index],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  final double value_per_month;
  final String month;

  const BarChart(
      {super.key, required this.value_per_month, required this.month});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 20,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme_Colors.black,
              ),
            ),
            Container(
              width: 20,
              height: value_per_month,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: Theme_Colors.usage_gradient_orange,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          '$month',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Theme_Colors.white,
          ),
        ),
      ],
    );
  }
}
