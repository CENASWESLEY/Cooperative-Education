import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_ems/Component/Theme.dart';
import 'package:dashboard_ems/Section/Section2/Main_Information.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Connector_Status extends StatefulWidget {
  const Connector_Status({super.key});

  @override
  State<Connector_Status> createState() => _Connector_StatusState();
}

class _Connector_StatusState extends State<Connector_Status> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  Timer? _timer;
  final List<String> statusOptions = ['Charging', 'Finishing'];

  // รายชื่อสถานีทั้งหมด
  final List<String> stationList = [
    'Bang Khen',
    'Lat Krabang',
    'Phloen Chit',
    'Thon Buri',
  ];

  @override
  void initState() {
    super.initState();

    // ตั้ง Timer สำหรับสุ่มสถานะทุก 1 นาที
    _timer = Timer.periodic(Duration(minutes: 10), (timer) {
      randomizeAndSaveConnectorStatusForAllStations();
    });

    // สุ่มสถานะครั้งแรก
    randomizeAndSaveConnectorStatusForAllStations();
  }

  //TODO: Fetch infomation to Firestore

  // ฟังก์ชันสุ่มสถานะหัวชาร์จและบันทึกลง Firebase สำหรับทุกสถานี
  void randomizeAndSaveConnectorStatusForAllStations() {
    Random random = Random();
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // ลูปสุ่มสถานะสำหรับทุกสถานี
    for (String station in stationList) {
      Map<String, dynamic> connectorData = {};
      int numOfChargersToUpdate = random.nextInt(20) + 1; // สุ่ม 1-20 หัวชาร์จ
      List<int> selectedChargers = [];

      // เลือกหัวชาร์จที่จะถูกสุ่มสถานะ
      while (selectedChargers.length < numOfChargersToUpdate) {
        int chargerId = random.nextInt(30) + 1;
        if (!selectedChargers.contains(chargerId)) {
          selectedChargers.add(chargerId);
        }
      }

      for (int i = 1; i <= 30; i++) {
        String formattedId = i.toString().padLeft(2, '0');
        String status;
        String type;

        if (selectedChargers.contains(i)) {
          status = statusOptions[random.nextInt(statusOptions.length)];
        } else {
          status = 'Available';
        }

        type = (i <= 15) ? 'DC' : 'AC';

        connectorData['Connector ID:$formattedId'] = {
          'status': status,
          'type': type,
          'date': formattedDate,
        };
      }

      // บันทึกข้อมูลลง Firebase สำหรับสถานีนั้น
      databaseRef
          .child('Stations/$station/Connector Status')
          .set(connectorData)
          .then((_) => print("Data saved successfully for $station"))
          .catchError((error) => print("Failed to save data: $error"));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StationProvider>(
      builder: (context, stationProvider, child) {
        String selectedStation = stationProvider.selectedStation;

        return Container(
          width: 500,
          height: 515,
          decoration: BoxDecoration(
            border: GradientBoxBorder(
              gradient: Theme_Colors.general_gradient_mainborder,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0), blurRadius: 10)
            ],
            color: Theme_Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGradientSideDecoration1(
                  Theme_Colors.general_gradient_subborder_left),
              SizedBox(width: 5),
              Container(
                width: 454,
                height: 510,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTitle(),
                    _buildChargerRow(1, 5, selectedStation),
                    _buildChargerRow(6, 10, selectedStation),
                    _buildChargerRow(11, 15, selectedStation),
                    _buildChargerRow(16, 20, selectedStation),
                    _buildChargerRow(21, 25, selectedStation),
                    _buildChargerRow(26, 30, selectedStation),
                    SizedBox(height: 0),
                  ],
                ),
              ),
              SizedBox(width: 5),
              _buildGradientSideDecoration2(
                  Theme_Colors.general_gradient_subborder_right),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGradientSideDecoration1(Gradient gradient) {
    return Container(
      width: 15,
      height: 180,
      decoration: BoxDecoration(
        gradient: gradient,
        boxShadow: [BoxShadow(blurRadius: 20, color: Theme_Colors.orange)],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }

  Widget _buildGradientSideDecoration2(Gradient gradient) {
    return Container(
      width: 15,
      height: 180,
      decoration: BoxDecoration(
        gradient: gradient,
        boxShadow: [BoxShadow(blurRadius: 20, color: Theme_Colors.orange)],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: 454,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 20),
          Container(
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  Theme_Colors.general_gradient_maintext.createShader(bounds),
              child: Text(
                'CONNECTOR\nSTATUS',
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
          Container(
            width: 265,
            child: Column(
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
                _buildStatusIndicatorRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicatorRow() {
    return Row(
      children: [
        _buildStatusIndicator(
            'Available',
            Theme_Colors.status_gradient_labelavailable,
            Theme_Colors.status_available),
        SizedBox(width: 15),
        _buildStatusIndicator('Charging', Theme_Colors.status_gradient_charging,
            Theme_Colors.status_charging),
        SizedBox(width: 15),
        _buildStatusIndicator(
            'Unavailable',
            Theme_Colors.status_gradient_labelunavailable,
            Theme_Colors.status_unavailable),
      ],
    );
  }

  Widget _buildStatusIndicator(
      String label, Gradient gradient, Color shadowColor) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [BoxShadow(color: shadowColor, blurRadius: 5)]),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 10,
            color: shadowColor,
          ),
        ),
      ],
    );
  }

  Widget _buildChargerRow(int startId, int endId, String station) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '$startId',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        for (int i = startId; i <= endId; i++)
          ChargerTile(id: i, station: station),
        Text(
          '$endId',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// TODO: Create Charger

class ChargerTile extends StatelessWidget {
  final int id;
  final String station;
  ChargerTile({required this.id, required this.station});

  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseRef
          .child(
              'Stations/$station/Connector Status/Connector ID:${id.toString().padLeft(2, '0')}')
          .onValue, // ฟังการเปลี่ยนแปลงของ Firebase Realtime Database
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        Map<String, dynamic>? chargerData;

        // ตรวจสอบว่ามีข้อมูลหรือไม่
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          chargerData =
              (snapshot.data!.snapshot.value as Map).cast<String, dynamic>();
        }

        // ถ้าไม่มีข้อมูล ให้ใช้ค่าเริ่มต้น "Unknown"
        String status = chargerData?['status'] ?? 'Unknown';
        String type = chargerData?['type'] ?? 'Unknown';

        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: getStatusGradient(status),
            boxShadow: [
              BoxShadow(
                color: getBoxShadowColor(status),
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              id <= 15
                  ? 'assets/icons/charger/DC.png'
                  : 'assets/icons/charger/AC.png',
            ),
          ),
        );
      },
    );
  }

  // กำหนดสีตามสถานะ
  Gradient getStatusGradient(String status) {
    switch (status) {
      case 'Available':
        return Theme_Colors.status_gradient_available;
      case 'Charging':
        return Theme_Colors.status_gradient_charging;
      default:
        return Theme_Colors.status_gradient_unavailable;
    }
  }

  // กำหนดเงาตามสถานะ
  Color getBoxShadowColor(String status) {
    switch (status) {
      case 'Available':
        return Theme_Colors.status_available;
      case 'Charging':
        return Theme_Colors.status_charging;
      default:
        return Theme_Colors.status_unavailable;
    }
  }
}




/*
import 'dart:developer';
import 'package:dashboard_ems/Component/Theme.dart';
import 'package:dashboard_ems/Section/Section1/ChargerStatusNotifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';

class Connector_Status extends StatefulWidget {
  const Connector_Status({super.key});

  @override
  State<Connector_Status> createState() => _Connector_StatusState();
}

class _Connector_StatusState extends State<Connector_Status> {
  @override
  Widget build(BuildContext context) {
    final chargerStatusNotifier = Provider.of<ChargerStatusNotifier>(context);

    return Container(
      width: 500,
      height: 515,
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: Theme_Colors.general_gradient_mainborder,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [BoxShadow(color: Theme_Colors.orange, blurRadius: 10)],
        color: Theme_Colors.black,
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
            width: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 454,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: ShaderMask(
                        shaderCallback: (bounds) => Theme_Colors
                            .general_gradient_maintext
                            .createShader(bounds),
                        child: Text(
                          'CONNECTOR\nSTATUS',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Container(
                      width: 265,
                      child: Column(
                        children: [
                          Text(
                            'CHARGER 1 & CHARGER 2',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                                color: Colors.white,
                                letterSpacing: 5),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          gradient: Theme_Colors
                                              .status_gradient_labelavailable,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Theme_Colors.status_available,
                                              blurRadius: 5,
                                            )
                                          ]),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Available',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        color: Theme_Colors.status_available,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          gradient: Theme_Colors
                                              .status_gradient_charging,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Theme_Colors.status_charging,
                                              blurRadius: 5,
                                            )
                                          ]),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Charging',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        color: Theme_Colors.status_charging,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          gradient: Theme_Colors
                                              .status_gradient_labelunavailable,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme_Colors
                                                  .status_unavailable,
                                              blurRadius: 5,
                                            )
                                          ]),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Unavailable',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        color: Theme_Colors.status_unavailable,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 454,
                          height: 400,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '1',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Charger1(
                                    id: 1,
                                  ),
                                  Charger1(
                                    id: 2,
                                  ),
                                  Charger1(
                                    id: 3,
                                  ),
                                  Charger1(
                                    id: 4,
                                  ),
                                  Charger1(
                                    id: 5,
                                  ),
                                  Text(
                                    '5',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '6',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Charger1(
                                    id: 6,
                                  ),
                                  Charger1(
                                    id: 7,
                                  ),
                                  Charger1(
                                    id: 8,
                                  ),
                                  Charger1(
                                    id: 9,
                                  ),
                                  Charger1(
                                    id: 10,
                                  ),
                                  Text(
                                    '10',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '11',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Charger1(
                                    id: 11,
                                  ),
                                  Charger1(
                                    id: 12,
                                  ),
                                  Charger1(
                                    id: 13,
                                  ),
                                  Charger1(
                                    id: 14,
                                  ),
                                  Charger1(
                                    id: 15,
                                  ),
                                  Text(
                                    '15',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '16',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Charger1(
                                    id: 16,
                                  ),
                                  Charger1(
                                    id: 17,
                                  ),
                                  Charger1(
                                    id: 18,
                                  ),
                                  Charger2(
                                    id: 19,
                                  ),
                                  Charger2(
                                    id: 20,
                                  ),
                                  Text(
                                    '20',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '21',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Charger2(
                                    id: 21,
                                  ),
                                  Charger2(
                                    id: 22,
                                  ),
                                  Charger2(
                                    id: 23,
                                  ),
                                  Charger2(
                                    id: 24,
                                  ),
                                  Charger2(
                                    id: 25,
                                  ),
                                  Text(
                                    '25',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '26',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Charger2(
                                    id: 26,
                                  ),
                                  Charger2(
                                    id: 27,
                                  ),
                                  Charger2(
                                    id: 28,
                                  ),
                                  Charger2(
                                    id: 29,
                                  ),
                                  Charger2(
                                    id: 30,
                                  ),
                                  Text(
                                    '30',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            width: 5,
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
}

class Charger1 extends StatefulWidget {
  final int id;
  Charger1({super.key, required this.id});

  @override
  State<Charger1> createState() => _Charger1State();
}

class _Charger1State extends State<Charger1> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChargerStatusNotifier>(
      builder: (context, chargerStatusNotifier, child) {
        String status = chargerStatusNotifier.getConnector1Status(widget.id);

        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: getStatusGradient1(status),
            boxShadow: [
              BoxShadow(
                color: getBoxShadowColor1(status),
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/icons/charger/DC.png',
            ),
          ),
        );
      },
    );
  }

  Gradient getStatusGradient1(String status) {
    switch (status) {
      case 'Available':
        return Theme_Colors.status_gradient_available;
      case 'Charging':
        return Theme_Colors.status_gradient_charging;
      case 'Finishing':
        return Theme_Colors.status_gradient_unavailable;
      default:
        return Theme_Colors.status_gradient_unavailable;
    }
  }

  Color getBoxShadowColor1(String status) {
    switch (status) {
      case 'Available':
        return Theme_Colors.status_available;
      case 'Charging':
        return Theme_Colors.status_charging;
      case 'Finishing':
        return Theme_Colors.status_unavailable;
      default:
        return Theme_Colors.status_unavailable;
    }
  }
}

class Charger2 extends StatefulWidget {
  final int id;

  Charger2({super.key, required this.id});

  @override
  State<Charger2> createState() => _Charger2State();
}

class _Charger2State extends State<Charger2> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChargerStatusNotifier>(
      builder: (context, chargerStatusNotifier, child) {
        String status = chargerStatusNotifier.getConnector2Status(widget.id);

        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: getStatusGradient2(status),
            boxShadow: [
              BoxShadow(
                color: getBoxShadowColor2(status),
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/icons/charger/AC.png',
            ),
          ),
        );
      },
    );
  }

  Gradient getStatusGradient2(String status) {
    switch (status) {
      case 'Available':
        return Theme_Colors.status_gradient_available;
      case 'Charging':
        return Theme_Colors.status_gradient_charging;
      case 'Finishing':
        return Theme_Colors.status_gradient_unavailable;
      default:
        return Theme_Colors.status_gradient_unavailable;
    }
  }

  Color getBoxShadowColor2(String status) {
    switch (status) {
      case 'Available':
        return Theme_Colors.status_available;
      case 'Charging':
        return Theme_Colors.status_charging;
      case 'Finishing':
        return Theme_Colors.status_unavailable;
      default:
        return Theme_Colors.status_unavailable;
    }
  }
}
*/