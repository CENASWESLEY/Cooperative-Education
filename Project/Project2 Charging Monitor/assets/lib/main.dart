import 'dart:developer';
import 'package:dashboard_ems/MQTT/MQTT.dart';
import 'package:dashboard_ems/MQTT/Provider_MQTT.dart';
import 'package:dashboard_ems/Section/Section1/ChargerStatusNotifier.dart';
import 'package:dashboard_ems/Section/Section2/Main_Information.dart';
import 'package:dashboard_ems/Section/Section3/MDBNotifier.dart';
import 'package:dashboard_ems/Section/Section3/TLMNotifier.dart';
import 'package:dashboard_ems/Section/Section6/Charging_UsageChangeNotifier.dart';
import 'package:dashboard_ems/layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:fl_heatmap/fl_heatmap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

late MQTTClientWrapper mqttClientWrapper;
DataService dataService = DataService();

const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyCTt0XhlMscEnJ10qLLtLmw2wOqmSQI1tA",
  projectId: "charging-monitor",
  storageBucket: "charging-monitor.appspot.com",
  messagingSenderId: "350994984131",
  appId: "1:350994984131:android:e86a12b47469f3cc500676",
);

Future<void> main() async {
  // Ensure Flutter is properly initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StationProvider()), // สถานี
        ChangeNotifierProvider(
            create: (context) => EnergyProvider()), // พลังงาน
        ChangeNotifierProvider(create: (context) => ChargerStatusNotifier()),
        ChangeNotifierProvider(create: (_) => MDBNotifier()),
        ChangeNotifierProvider(create: (_) => TLMNotifier()),
        // ChangeNotifierProvider(create: (context) => Charging_StatisticsNotifier()),
        ChangeNotifierProvider(create: (context) => DataService()), // MQTT
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    mqttClientWrapper = MQTTClientWrapper(context);
    mqttClientWrapper.connect().then((_) {
      log('MQTT connection initiated');
    }).catchError((e) {
      log('MQTT connection failed: $e');
    });
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Layout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
