import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mqtt_app/Pages/Login/Login.dart';
import 'package:mqtt_app/Pages/Login/Started.dart';
import 'package:mqtt_app/Pages/Provider/user_provider.dart';
import 'package:mqtt_app/Pages/Room/ChangeRoom.dart';
import 'package:mqtt_app/Pages/home/home.dart';
import 'package:mqtt_app/Pico/data_service.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'Pages/superpages.dart';
import 'Pico/mqtt_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart'; // ใช้ firebase_core สำหรับ Flutter
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

late MQTTClientWrapper mqttClientWrapper;
late Timer t;
DataService dataService = DataService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => DataService()),
    ChangeNotifierProvider(
        create: (context) => RoomModel()), // Add the RoomModel provider
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.kanitTextTheme(),
        ),
        home: Mystart());
  }
}
