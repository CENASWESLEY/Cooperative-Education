import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Room {
  final String icon;
  final String name;
  final int devices;

  Room({required this.icon, required this.name, required this.devices});

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'name': name,
        'devices': devices,
      };

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      icon: json['icon'],
      name: json['name'],
      devices: json['devices'],
    );
  }
}

class RoomModel extends ChangeNotifier {
  List<Room> _rooms = [
    Room(icon: 'assets/images/Living.png', name: 'Living Room', devices: 3),
    Room(icon: 'assets/images/Kitchen.png', name: 'Kitchen Room', devices: 3),
    Room(icon: 'assets/images/Bed.png', name: 'Bed Room', devices: 3),
    Room(icon: 'assets/images/security.png', name: 'Security', devices: 3),
    Room(icon: 'assets/images/sensor.png', name: 'Sensor', devices: 3),
  ];

  RoomModel() {
    _loadRooms();
  }

  List<Room> get rooms => List.unmodifiable(_rooms);

  Future<void> _loadRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final roomsData = prefs.getString('rooms');
    if (roomsData != null) {
      final List<dynamic> jsonData = json.decode(roomsData);
      _rooms = jsonData.map((item) => Room.fromJson(item)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final roomsData = json.encode(_rooms.map((room) => room.toJson()).toList());
    await prefs.setString('rooms', roomsData);
  }

  void addRoom(Room room) {
    _rooms.add(room);
    _saveRooms();
    notifyListeners();
  }

  void updateRoom(int index, Room room) {
    _rooms[index] = room;
    _saveRooms();
    notifyListeners();
  }

  void removeRoom(int index) {
    _rooms.removeAt(index);
    _saveRooms();
    notifyListeners();
  }
}
