import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dashboard_ems/Section/Section1/ChargerStatusNotifier.dart';
import 'package:dashboard_ems/Section/Section3/MDBNotifier.dart';
import 'package:dashboard_ems/Section/Section3/TLMNotifier.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';

class MQTTClientWrapper {
  final client = MqttServerClient('103.49.148.231', '');
  final String clientIdentifier = 'Charging Monitor';
  bool isConnected = false;
  late BuildContext _context;
  late ChargerStatusNotifier chargerStatusNotifier;
  late MDBNotifier mdbNotifier;
  late TLMNotifier tlmNotifier;
  //late Charging_StatisticsNotifier chargingStatistics;

  MQTTClientWrapper(BuildContext context) {
    _context = context;
    chargerStatusNotifier =
        Provider.of<ChargerStatusNotifier>(_context, listen: false);
    mdbNotifier = Provider.of<MDBNotifier>(_context, listen: false);
    tlmNotifier = Provider.of<TLMNotifier>(_context, listen: false);
    //chargingStatistics =Provider.of<Charging_StatisticsNotifier>(_context, listen: false);

    _setup();
  }

  void _setup() {
    client.port = 57212;
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
  }

  Future<void> connect() async {
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .authenticateAs('rdd01', 'rdd01')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        log('Client connected successfully');
        isConnected = true;

        //subscribeToTopic('/MEA/PLUGME/EV/RES/PJ'); // Status
        //startPublishing();
        //subscribeToTopic('/smg/tlm/'); // TLM
        //subscribeToTopic('MEAEV/OLM/PJ01-test2-1'); // MDB

        client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          final recMess = c![0].payload as MqttPublishMessage;
          final topic = c[0].topic;
          final pt =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

          if (pt.startsWith('{') && pt.endsWith('}')) {
            final payload = jsonDecode(pt);
            if (topic == '/MEA/PLUGME/EV/RES/PJ') {
              CONNECTOR_STATUS(payload);
            }

            if (topic == '/smg/tlm/') {
              TLM(payload);
            }
          }

          if (topic == 'MEAEV/OLM/PJ01-test2-1') {
            MDB(pt);
          }
        });
      }
    } catch (e) {
      log('Exception during connection: $e');
      client.disconnect();
    }
  }

// ====================================================================== 1.CONNECTOR_STATUS ===================================================================================

  void CONNECTOR_STATUS(payload) {
    log('------------------------------------------------------------------------------------');
    log(' | CONNECTOR_STATUS | ');

    // ประมวลผล Charger 1 (rddNC4200001) ก่อน
    for (var i = 0; i < payload['result'].length; i++) {
      var chargerData = payload['result'][i];
      String cpId = chargerData['cp_id'];

      if (cpId == 'rddNC4200001' && chargerData['connector'] != null) {
        int connectorCount = chargerData['connector'].length;
        log('Charger1 has $connectorCount connectors');
        for (var j = 0; j < connectorCount; j++) {
          var connectorData = chargerData['connector'][j];
          if (connectorData == null || connectorData['status'] == null) {
            continue;
          }
          int uniqueId = connectorData['id']; // ใช้ id 1-18 สำหรับ Charger 1
          log('Charger1 Connector $uniqueId - ID: $uniqueId, Status: ${connectorData['status']}');
          chargerStatusNotifier.updateConnector1Status(
              uniqueId, connectorData['status']);
        }
      }
    }

    // ประมวลผล Charger 2 (rddNC4000001) หลังจากนั้น
    for (var i = 0; i < payload['result'].length; i++) {
      var chargerData = payload['result'][i];
      String cpId = chargerData['cp_id'];

      if (cpId == 'rddNC4000001' && chargerData['connector'] != null) {
        int connectorCount = chargerData['connector'].length;
        log('Charger2 has $connectorCount connectors');
        for (var j = 0; j < connectorCount; j++) {
          var connectorData = chargerData['connector'][j];
          if (connectorData == null || connectorData['status'] == null) {
            continue;
          }
          int uniqueId =
              connectorData['id'] + 18; // ใช้ id 19-30 สำหรับ Charger 2
          log('Charger2 Connector $uniqueId - ID: $uniqueId, Status: ${connectorData['status']}');
          chargerStatusNotifier.updateConnector2Status(
              uniqueId, connectorData['status']);
        }
      }
    }

    log('------------------------------------------------------------------------------------');
    chargerStatusNotifier.notifyListeners();
  }

// ====================================================================== 3.TRANSFORMER LOAD MANAGEMENT\n& MAIN DISTRIBUTION BOARD ===================================================================================

/*
{"OLM_ID":"KTT0734","Timestamp":"2024-09-06T05:30:00Z","Voltage-A(V)":"229.3","Voltage-B(V)":"230.2","Voltage-C(V)":"230.8","Current-A(A)":"13.76","Current-B(A)":"12.16","Current-C(A)":"16.96","ActivePower-A(kW)":"2.88","ActivePower-B(kW)":"1.92","ActivePower-C(kW)":"1.92","ReactivePower-A(kVAR)":"0","ReactivePower-B(kVAR)":"0","ReactivePower-C(kVAR)":"0","Power-A(kVA)":"3.04","Power-B(kVA)":"2.72","Power-C(kVA)":"3.84"}
*/

  void TLM(dynamic payload) {
    log('------------------------------------------------------------------------------------');
    log(' | TRANSFORMER LOAD MANAGEMENT | ');

    double voltage1 =
        double.tryParse(payload['Voltage-A(V)'].toString()) ?? 0.0;
    double voltage2 =
        double.tryParse(payload['Voltage-B(V)'].toString()) ?? 0.0;
    double voltage3 =
        double.tryParse(payload['Voltage-C(V)'].toString()) ?? 0.0;
    double current1 =
        double.tryParse(payload['Current-A(A)'].toString()) ?? 0.0;
    double current2 =
        double.tryParse(payload['Current-B(A)'].toString()) ?? 0.0;
    double current3 =
        double.tryParse(payload['Current-C(A)'].toString()) ?? 0.0;
    double power1 =
        double.tryParse(payload['ActivePower-A(kW)'].toString()) ?? 0.0;
    double power2 =
        double.tryParse(payload['ActivePower-B(kW)'].toString()) ?? 0.0;
    double power3 =
        double.tryParse(payload['ActivePower-C(kW)'].toString()) ?? 0.0;
    double repower1 =
        double.tryParse(payload['ReactivePower-A(kVAR)'].toString()) ?? 0.0;
    double repower2 =
        double.tryParse(payload['ReactivePower-B(kVAR)'].toString()) ?? 0.0;
    double repower3 =
        double.tryParse(payload['ReactivePower-C(kVAR)'].toString()) ?? 0.0;
    double active_energy = current1 + current2 + current3;
    double reactive_energy = repower1 + repower2 + repower3;

    log('Voltage Phase A: ${voltage1.toStringAsFixed(2)} V');
    log('Voltage Phase B: ${voltage2.toStringAsFixed(2)} V');
    log('Voltage Phase C: ${voltage3.toStringAsFixed(2)} V');
    log('Current Phase A: ${power1.toStringAsFixed(2)} A');
    log('Current Phase B: ${power2.toStringAsFixed(2)} A');
    log('Current Phase C: ${power3.toStringAsFixed(2)} A');
    log('Power Phase A: ${current1.toStringAsFixed(2)} KW');
    log('Power Phase B: ${current2.toStringAsFixed(2)} KW');
    log('Power Phase C: ${current3.toStringAsFixed(2)} KW');
    log('Total Load: ${current3.toStringAsFixed(2)} KW');
    //log('Total Active Energy: ${active_energy.toStringAsFixed(2)} KWh');
    //log('Total Reactive Energy: ${reactive_energy.toStringAsFixed(2)} KVarH');
/*

    log('Voltage Phase A: ${voltage1.toStringAsFixed(2)} V');
    log('Voltage Phase B: ${voltage2.toStringAsFixed(2)} V');
    log('Voltage Phase C: ${voltage3.toStringAsFixed(2)} V');
    log('Current Phase A: ${current1.toStringAsFixed(2)} A');
    log('Current Phase B: ${current2.toStringAsFixed(2)} A');
    log('Current Phase C: ${current3.toStringAsFixed(2)} A');
    log('Power Phase A: ${power1.toStringAsFixed(2)} W');
    log('Power Phase B: ${power2.toStringAsFixed(2)} W');
    log('Power Phase C: ${power3.toStringAsFixed(2)} W');
    log('Total Active Energy: ${active_energy.toStringAsFixed(2)} KWH');
    log('Total Reactive Energy: ${reactive_energy.toStringAsFixed(2)} KVarH');

        tlmNotifier.updateValues(
      newVolt1: voltage1,
      newVolt2: voltage2,
      newVolt3: voltage3,
      newCurrent1: current1,
      newCurrent2: current2,
      newCurrent3: current3,
      newPower1: power1,
      newPower2: power2,
      newPower3: power3,
      newEnergyK: active_energy,
      newEnergyVarK: reactive_energy,
    );
*/
    tlmNotifier.updateValues(
      newVolt1: voltage1,
      newVolt2: voltage2,
      newVolt3: voltage3,
      newCurrent1: power1,
      newCurrent2: power1,
      newCurrent3: power1,
      newPower1: current1,
      newPower2: current2,
      newPower3: current3,
      newEnergyK: active_energy,
      newEnergyVarK: reactive_energy,
    );

    log('------------------------------------------------------------------------------------');
  }

  /*
  List<double?>? vipValues;
  List<double?>? kwhValues;

  bool hasDisplayedSecondLog = false;

  void MDB(String payload) {
    // ฟังก์ชันสำหรับเตรียมข้อมูล
    String dataPrepare(String data) {
      Map<String, String> dataDict = {
        "0": "00",
        "1": "01",
        "2": "02",
        "3": "03",
        "4": "04",
        "5": "05",
        "6": "06",
        "7": "07",
        "8": "08",
        "9": "09",
        "A": "0A",
        "B": "0B",
        "C": "0C",
        "D": "0D",
        "E": "0E",
        "F": "0F"
      };
      return dataDict[data.toUpperCase()] ?? data;
    }

    // ฟังก์ชันสำหรับแปลงค่า hex string เป็น floating-point
    double? parseFloat(String hexStr) {
      if (hexStr.startsWith("0x")) {
        hexStr = hexStr.substring(2);
      }
      try {
        int intVal = int.parse(hexStr, radix: 16);
        var byteData = ByteData(4);
        byteData.setUint32(0, intVal, Endian.big);
        return byteData.getFloat32(0, Endian.big);
      } catch (e) {
        log("Invalid hex string: $e");
        return null;
      }
    }

    // ลบ "VIP:" และ "kwh:" ออกจาก payload
    payload = payload.replaceAll("VIP:", "").replaceAll("kWh:", "").trim();

    // แยก payload เป็นส่วนๆ
    List<String> parts = payload.split(' 0x');

    // ฟังก์ชันสำหรับการดึงข้อมูลตามตำแหน่ง
    String getData(int partIndex) {
      return (partIndex < parts.length) ? parts[partIndex] : "0";
    }

    // เตรียมค่า VIP meter values
    List<String> vipValues = [
      "0x" +
          dataPrepare(getData(3)) +
          dataPrepare(getData(4)) +
          dataPrepare(getData(5)) +
          dataPrepare(getData(6)), // Voltage1
      "0x" +
          dataPrepare(getData(7)) +
          dataPrepare(getData(8)) +
          dataPrepare(getData(9)) +
          dataPrepare(getData(10)), // Voltage2
      "0x" +
          dataPrepare(getData(11)) +
          dataPrepare(getData(12)) +
          dataPrepare(getData(13)) +
          dataPrepare(getData(14)), // Voltage3
      "0x" +
          dataPrepare(getData(15)) +
          dataPrepare(getData(16)) +
          dataPrepare(getData(17)) +
          dataPrepare(getData(18)), // Current1
      "0x" +
          dataPrepare(getData(19)) +
          dataPrepare(getData(20)) +
          dataPrepare(getData(21)) +
          dataPrepare(getData(22)), // Current2
      "0x" +
          dataPrepare(getData(23)) +
          dataPrepare(getData(24)) +
          dataPrepare(getData(25)) +
          dataPrepare(getData(26)), // Current3
      "0x" +
          dataPrepare(getData(27)) +
          dataPrepare(getData(28)) +
          dataPrepare(getData(29)) +
          dataPrepare(getData(30)), // Power1
      "0x" +
          dataPrepare(getData(31)) +
          dataPrepare(getData(32)) +
          dataPrepare(getData(33)) +
          dataPrepare(getData(34)), // Power2
      "0x" +
          dataPrepare(getData(35)) +
          dataPrepare(getData(36)) +
          dataPrepare(getData(37)) +
          dataPrepare(getData(38)) // Power3
    ];

    // แปลงค่า VIP meter values เป็น float
    List<double?> parsedVipValues =
        vipValues.map((value) => parseFloat(value)).toList();

    // ตรวจสอบและ log ค่า Voltage, Current, Power จาก VIP
    if (parsedVipValues.length >= 9) {
      final voltage1 = parsedVipValues[0] ?? 0;
      final voltage2 = parsedVipValues[1] ?? 0;
      final voltage3 = parsedVipValues[2] ?? 0;
      final current1 = parsedVipValues[3] ?? 0;
      final current2 = parsedVipValues[4] ?? 0;
      final current3 = parsedVipValues[5] ?? 0;
      final power1 = parsedVipValues[6] ?? 0;
      final power2 = parsedVipValues[7] ?? 0;
      final power3 = parsedVipValues[8] ?? 0;

      // แสดง log เฉพาะเมื่อมีค่า Voltage และยังไม่แสดงผล
      if (voltage1 > 220 && voltage1 < 240) {
        log('------------------------------------------------------------------------------------');
        log(' | MAIN DISTRIBUTION BOARD | ');
        log('Voltage Phase A: ${voltage1.toStringAsFixed(2)} V');
        log('Voltage Phase B: ${voltage2.toStringAsFixed(2)} V');
        log('Voltage Phase C: ${voltage3.toStringAsFixed(2)} V');
        log('Current Phase A: ${current1.toStringAsFixed(2)} A');
        log('Current Phase B: ${current2.toStringAsFixed(2)} A');
        log('Current Phase C: ${current3.toStringAsFixed(2)} A');
        log('Power Phase A: ${power1.toStringAsFixed(2)} W');
        log('Power Phase B: ${power2.toStringAsFixed(2)} W');
        log('Power Phase C: ${power3.toStringAsFixed(2)} W');

        // เตรียมค่า kWh meter values
        List<String> kwhValues = [
          "0x" +
              dataPrepare(getData(147)) +
              dataPrepare(getData(148)) +
              dataPrepare(getData(149)) +
              dataPrepare(getData(150)), // KWH
          "0x" +
              dataPrepare(getData(155)) +
              dataPrepare(getData(156)) +
              dataPrepare(getData(157)) +
              dataPrepare(getData(158)) // KVARH
        ];

        // แปลงค่า kWh meter values เป็น float
        List<double?> parsedKwhValues =
            kwhValues.map((value) => parseFloat(value)).toList();

        if (parsedKwhValues.length >= 2) {
          final active_energy = parsedKwhValues[0] ?? 0;
          final reactive_energy = parsedKwhValues[1] ?? 0;

          log('Active Energy: ${active_energy.toStringAsFixed(2)} KWH');
          log('Reactive Energy: ${reactive_energy.toStringAsFixed(2)} KVArH');

          mdbNotifier.updateValues(
            newVolt1: voltage1,
            newVolt2: voltage2,
            newVolt3: voltage3,
            newCurrent1: current1,
            newCurrent2: current2,
            newCurrent3: current3,
            newPower1: power1,
            newPower2: power2,
            newPower3: power3,
            newEnergyK: active_energy,
            newEnergyVarK: reactive_energy,
          );
        } else {
          log('Error: kWh data is incomplete or invalid');
        }

        log('------------------------------------------------------------------------------------');
      }
    } else {
      log('Error: VIP data is incomplete or invalid');
    }
  }
  */
  void MDB(String pt) {
    log('------------------------------------------------------------------------------------');
    log(' | MAIN DISTRIBUTION BOARD | ');

    pt = pt.replaceAll("Parameter:", "").trim();
    List<String> values = pt.split(',');

    try {
      double voltage1 = double.parse(values[0].trim());
      double voltage2 = double.parse(values[1].trim());
      double voltage3 = double.parse(values[2].trim());
      double current1 = double.parse(values[3].trim());
      double current2 = double.parse(values[4].trim());
      double current3 = double.parse(values[5].trim());
      double power1 = double.parse(values[6].trim()) / 100;
      double power2 = double.parse(values[7].trim()) / 100;
      double power3 = double.parse(values[8].trim()) / 100;
      double active_energy = double.parse(values[9].trim()) / 100;
      double reactive_energy = double.parse(values[10].trim()) / 100;

      log('Voltage Phase A: ${voltage1.toStringAsFixed(2)} V');
      log('Voltage Phase B: ${voltage2.toStringAsFixed(2)} V');
      log('Voltage Phase C: ${voltage3.toStringAsFixed(2)} V');
      log('Current Phase A: ${current1.toStringAsFixed(2)} A');
      log('Current Phase B: ${current2.toStringAsFixed(2)} A');
      log('Current Phase C: ${current3.toStringAsFixed(2)} A');
      log('Power Phase A: ${power1.toStringAsFixed(2)} KW');
      log('Power Phase B: ${power2.toStringAsFixed(2)} KW');
      log('Power Phase C: ${power3.toStringAsFixed(2)} KW');
      log('Total Load: ${power3.toStringAsFixed(2)} KW');
      //log('Total Active Energy: ${active_energy.toStringAsFixed(2)} KWh');
      //log('Total Reactive Energy: ${reactive_energy.toStringAsFixed(2)} KVarH');

      mdbNotifier.updateValues(
        newVolt1: voltage1,
        newVolt2: voltage2,
        newVolt3: voltage3,
        newCurrent1: current1,
        newCurrent2: current2,
        newCurrent3: current3,
        newPower1: power1,
        newPower2: power2,
        newPower3: power3,
        newEnergyK: power1 + power2 + power3,
        newEnergyVarK: reactive_energy,
      );
    } catch (e) {
      //log('Error: $e');
    }

    log('------------------------------------------------------------------------------------');
  }

// ====================================================================== 6.Connector Annual Charging Statistics ===================================================================================

  void CHARGING_STATISTICS(String pt) {
    log('------------------------------------------------------------------------------------');
    log(' | CONNECTOR ANNUAL CHARGING STATISTICS | ');

    pt = pt.replaceAll("Parameter:", "").trim();
    List<String> values = pt.split(',');

    try {
      double active_energy = double.parse(values[9].trim()) / 100;

      log('Total Active Energy: ${active_energy.toStringAsFixed(2)} KWh');
      //log('Total Reactive Energy: ${reactive_energy.toStringAsFixed(2)} KVarH');
    } catch (e) {
      //log('Error: $e');
    }

    log('------------------------------------------------------------------------------------');
  }

  void onConnected() {
    log('Connected with client identifier: $clientIdentifier');
    isConnected = true;
  }

  void onDisconnected() {
    log('Disconnected');
    isConnected = false;
    //connect();
  }

  void onSubscribed(String topic) {
    //log('Subscribed to $topic');
  }

  void onSubscribeFail(String topic) {
    log('Failed to subscribe $topic');
  }

  void pong() {
    //log('Ping response client callback invoked');
  }

  void subscribeToTopic(String topic) {
    if (isConnected) {
      client.subscribe(topic, MqttQos.atLeastOnce);
      log('Subscribed to $topic');
    } else {
      log('Cannot subscribe, client is not connected');
    }
  }

  void startPublishing() {
    publishMessage('/MEA/PLUGME/EV/PJ', 'STATUS');
    Timer.periodic(Duration(minutes: 1), (Timer t) {
      publishMessage('/MEA/PLUGME/EV/PJ', 'STATUS');
    });
  }

  void publishMessage(String topic, String message) {
    if (isConnected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
      log('Message published to $topic');
    } else {
      //log('Cannot publish message, client is not connected');
    }
  }
}
