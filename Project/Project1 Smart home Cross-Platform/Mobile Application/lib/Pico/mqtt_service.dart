import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mqtt_app/Pico/data_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class MQTTClientWrapper {
  final client = MqttServerClient('test.mosquitto.org', '');
  final String clientIdentifier = 'flutter_client';
  bool isConnected = false;
  late BuildContext _context;

  MQTTClientWrapper(context) {
    _setup();
    _context = context;
  }

  // setup การเชือมต่อและรับค่า
  void _setup() {
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
  }

  // ฟังก์ชั่นในการเชื่อมต่อ ผ่าน id และ เชื่อมต่ออย่างน้อย 1 ครั้ง
  Future<void> connect() async {
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    // subcribe topic ต่างๆ
    try {
      await client.connect();
      log('Connection attempt succeeded');

      subscribeToTopic('Weather : Wind');
      subscribeToTopic('Weather : Temperature');
      subscribeToTopic('Weather : Humidity');

      subscribeToTopic('Security : Door');
      subscribeToTopic('Living Room : Light');
      subscribeToTopic('Games Room : Power');

      subscribeToTopic('Sensor : Ultrasonic');
      subscribeToTopic('Sensor : Water Level');
      subscribeToTopic('Sensor : Pump');

      //แทนการเขียน 8 บรรทัด
      int numberOfTopics = 8;
      for (int i = 0; i < numberOfTopics; i++) {
        subscribeToTopic('External : Meter_Value_${i + 1}');
      }

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final topic = c[0].topic;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        log('Topic:$topic , value:$pt');
        dataService.mqttData[topic] = pt;
        dataService.update();
      });

      //ถ้าการเชื่อมต่อถูกตัด
    } catch (e) {
      log('Exception during connection: $e');
      client.disconnect();
    }
  }

  void onConnected() {
    log('Connected with client identifier: $clientIdentifier');
    isConnected = true;
    // subscribeToTopic('led_state');
  }

  void onDisconnected() {
    log('Disconnected');
    isConnected = false;
  }

  void onSubscribed(String topic) {
    log('Subscribed to $topic');
  }

  void onSubscribeFail(String topic) {
    log('Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    log('Unsubscribed to $topic');
  }

  void pong() {
    log('Ping response client callback invoked');
  }

  void subscribeToTopic(String topic) {
    if (isConnected) {
      client.subscribe(topic, MqttQos.atLeastOnce);
      log('Subscribed to $topic');
    } else {
      log('Cannot subscribe, client is not connected');
    }
  }

  void publishMessage(String topic, String message) {
    if (isConnected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
      log('Message published to $topic');
    } else {
      log('Cannot publish message, client is not connected');
    }
  }
}
