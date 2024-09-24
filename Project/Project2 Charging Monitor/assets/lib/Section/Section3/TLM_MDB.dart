import 'dart:async';
import 'dart:math';

import 'package:dashboard_ems/Component/Theme.dart';
import 'package:dashboard_ems/Section/Section2/Main_Information.dart';
import 'package:dashboard_ems/Section/Section3/MDBNotifier.dart';
import 'package:dashboard_ems/Section/Section3/TLMNotifier.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dashboard_ems/Component/Theme.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TLM_MDB extends StatefulWidget {
  const TLM_MDB({super.key});

  @override
  State<TLM_MDB> createState() => _TLM_MDBState();
}

class _TLM_MDBState extends State<TLM_MDB> {
  final FirebaseDatabase _realtime = FirebaseDatabase.instance;
  final Random _random = Random();
  Timer? _timer;
  Map<String, dynamic> mdbValues = {};
  Map<String, dynamic> tlmValues = {};
  String? _previousSelectedStation;

  final List<String> stationList = [
    'Bang Khen',
    'Lat Krabang',
    'Phloen Chit',
    'Thon Buri'
  ];

  // จากค่า Usage
  final Map<String, double> stationEnergy = {
    'Bang Khen': 171979.4,
    'Lat Krabang': 177799.1,
    'Phloen Chit': 184259.63,
    'Thon Buri': 174029.1,
  };

  @override
  void initState() {
    super.initState();
    // Trigger saving of random values at startup and every 10 minutes
    startRandomValueGeneration();
    listenToFirebaseUpdates();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedStation =
        Provider.of<StationProvider>(context).selectedStation;
    if (_previousSelectedStation != selectedStation) {
      _previousSelectedStation = selectedStation;
      listenToFirebaseUpdates();
    }
  }

// TODO: Save information to realtime

  void startRandomValueGeneration() {
    // Generate and save initial values immediately
    generateAndSaveValuesForAllStations();

    // Set up a timer to generate new values every 10 minutes (600,000 milliseconds)
    _timer = Timer.periodic(Duration(minutes: 10), (Timer t) {
      generateAndSaveValuesForAllStations();
    });
  }

  // Function to loop through all stations and generate random values
  void generateAndSaveValuesForAllStations() {
    for (String station in stationList) {
      generateAndSaveDailyValues(station);
    }
  }

  void generateAndSaveDailyValues(String selectedStation) {
    double totalEnergy = stationEnergy[selectedStation] ?? 0;
    int daysIn9Months = 270;
    double dailyEnergy = totalEnergy / daysIn9Months;
    // Fixed energy split (60% for TLM and 40% for MDB)
    double tlmEnergy = dailyEnergy * 0.6;
    double mdbEnergy = dailyEnergy * 0.4;

    // Voltage randomization within the specified range 228V to 231V
    double voltageATLM = 228 + _random.nextDouble() * 3;
    double voltageBTLM = 228 + _random.nextDouble() * 3;
    double voltageCTLM = 228 + _random.nextDouble() * 3;

    double voltageAMDB = 228 + _random.nextDouble() * 3;
    double voltageBMDB = 228 + _random.nextDouble() * 3;
    double voltageCMDB = 228 + _random.nextDouble() * 3;

    // Proportional Power Randomization (TLM)
    double powerATLM = tlmEnergy *
        (0.3 +
            _random.nextDouble() *
                0.1); // Power A takes around 30% of TLM energy
    double powerBTLM = tlmEnergy *
        (0.4 +
            _random.nextDouble() *
                0.1); // Power B takes around 40% of TLM energy
    double powerCTLM = tlmEnergy *
        (0.3 +
            _random.nextDouble() *
                0.1); // Power C takes around 30% of TLM energy

    // Proportional Power Randomization (MDB)
    double powerAMDB = mdbEnergy *
        (0.3 +
            _random.nextDouble() *
                0.1); // Power A takes around 30% of MDB energy
    double powerBMDB = mdbEnergy *
        (0.4 +
            _random.nextDouble() *
                0.1); // Power B takes around 40% of MDB energy
    double powerCMDB = mdbEnergy *
        (0.3 +
            _random.nextDouble() *
                0.1); // Power C takes around 30% of MDB energy

    _realtime
        .ref(
            'Stations/$selectedStation/Transformer Load Management & Main Distribution Board/1 Transformer Load Management')
        .update({
      '01 Voltage A': voltageATLM.toStringAsFixed(2),
      '02 Voltage B': voltageBTLM.toStringAsFixed(2),
      '03 Voltage C': voltageCTLM.toStringAsFixed(2),
      '04 Power A': powerATLM.toStringAsFixed(2),
      '05 Power B': powerBTLM.toStringAsFixed(2),
      '06 Power C': powerCTLM.toStringAsFixed(2),
      '07 Total Energy TLM': tlmEnergy.toStringAsFixed(2),
    });
    _realtime
        .ref(
            'Stations/$selectedStation/Transformer Load Management & Main Distribution Board/2 Main Distribution Board')
        .update({
      '01 Voltage A': voltageAMDB.toStringAsFixed(2),
      '02 Voltage B': voltageBMDB.toStringAsFixed(2),
      '03 Voltage C': voltageCMDB.toStringAsFixed(2),
      '04 Power A': powerAMDB.toStringAsFixed(2),
      '05 Power B': powerBMDB.toStringAsFixed(2),
      '06 Power C': powerCMDB.toStringAsFixed(2),
      '07 Total Energy MDB': mdbEnergy.toStringAsFixed(2),
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

// TODO: Query information form realtime

  void listenToFirebaseUpdates() {
    // Get the selected station
    final selectedStation =
        Provider.of<StationProvider>(context, listen: false).selectedStation;

    // Listen for changes in TLM data
    _realtime
        .ref(
            'Stations/$selectedStation/Transformer Load Management & Main Distribution Board/1 Transformer Load Management')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          tlmValues = data.map((key, value) => MapEntry(key.toString(), value));
        });
      }
    });

    // Listen for changes in MDB data
    _realtime
        .ref(
            'Stations/$selectedStation/Transformer Load Management & Main Distribution Board/2 Main Distribution Board')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          mdbValues = data.map((key, value) => MapEntry(key.toString(), value));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mdbNotifier = Provider.of<MDBNotifier>(context);
    final tlmNotifier = Provider.of<TLMNotifier>(context);

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
          BoxShadow(color: const Color.fromARGB(255, 0, 0, 0), blurRadius: 10)
        ],
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
            width: 14,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => Theme_Colors
                          .general_gradient_maintext
                          .createShader(bounds),
                      child: Text(
                        'TRANSFORMER LOAD MANAGEMENT\n& MAIN DISTRIBUTION BOARD',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          shadows: [
                            Shadow(
                              color: Color(0xFFFFEEBB).withOpacity(1),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'CHARGER 1 & CHARGER 2 ',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                          color: Colors.white,
                          letterSpacing: 5),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 430,
                        height: 170,
                        decoration: BoxDecoration(
                          border: GradientBoxBorder(
                            gradient: Theme_Colors.tlm_gradient_orange,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Load_TLM(
                                      name: 'Voltage A',
                                      value:
                                          '${tlmValues["01 Voltage A"] ?? 0}'),
                                  Power_TLM(
                                      name: 'Power A',
                                      value: '${tlmValues["04 Power A"] ?? 0}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Load_TLM(
                                      name: 'Voltage B',
                                      value:
                                          '${tlmValues["02 Voltage B"] ?? 0}'),
                                  Power_TLM(
                                      name: 'Power B',
                                      value: '${tlmValues["05 Power B"] ?? 0}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Load_TLM(
                                      name: 'Voltage C',
                                      value:
                                          '${tlmValues["03 Voltage C"] ?? 0}'),
                                  Power_TLM(
                                      name: 'Power C',
                                      value: '${tlmValues["06 Power C"] ?? 0}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TotalLoad_TLM(
                                      name: 'TLM Energy Consumption',
                                      value:
                                          '${tlmValues["07 Total Energy TLM"] ?? 0}')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 430,
                        height: 170,
                        decoration: BoxDecoration(
                          border: GradientBoxBorder(
                            gradient: Theme_Colors.tlm_gradient_orange,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Load_MDB(
                                      name: 'Voltage A',
                                      value:
                                          '${mdbValues["01 Voltage A"] ?? 0}'),
                                  Power_MDB(
                                      name: 'Power A',
                                      value: '${mdbValues["04 Power A"] ?? 0}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Load_MDB(
                                      name: 'Voltage B',
                                      value:
                                          '${mdbValues["02 Voltage B"] ?? 0}'),
                                  Power_MDB(
                                      name: 'Power B',
                                      value: '${mdbValues["05 Power B"] ?? 0}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Load_MDB(
                                      name: 'Voltage C',
                                      value:
                                          '${mdbValues["03 Voltage C"] ?? 0}'),
                                  Power_MDB(
                                      name: 'Power C',
                                      value: '${mdbValues["06 Power C"] ?? 0}')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TotalLoad_MDB(
                                      name: 'MDB Energy Consumption',
                                      value:
                                          '${mdbValues["07 Total Energy MDB"] ?? 0}')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            width: 15,
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

class Load_TLM extends StatelessWidget {
  final String name;
  final String value;

  const Load_TLM({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 190) / 400;
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
                      '${double.parse(value).toStringAsFixed(2)} V',
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

class TotalLoad_TLM extends StatelessWidget {
  final String name;
  final String value;

  const TotalLoad_TLM({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 395) / 1000;
    return Container(
      width: 390,
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
                      '${double.parse(value).toStringAsFixed(2)} KWH',
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
                    width: 390,
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

class Power_TLM extends StatelessWidget {
  final String name;
  final String value;

  const Power_TLM({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 190) / 300;
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
                      '${double.parse(value).toStringAsFixed(2)} KW',
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

class Load_MDB extends StatelessWidget {
  final String name;
  final String value;

  const Load_MDB({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 190) / 400;

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
                      '${double.parse(value).toStringAsFixed(2)} V',
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

class TotalLoad_MDB extends StatelessWidget {
  final String name;
  final String value;

  const TotalLoad_MDB({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 395) / 1000;

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
                      '${double.parse(value).toStringAsFixed(2)} KWH',
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

class Power_MDB extends StatelessWidget {
  final String name;
  final String value;

  const Power_MDB({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    double valueDouble = double.tryParse(value) ?? 0.0;
    double widthValue = (valueDouble * 190) / 300;

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
                      '${double.parse(value).toStringAsFixed(2)} KW',
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
