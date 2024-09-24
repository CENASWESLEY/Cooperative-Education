import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mqtt_app/Pages/Room/ChangeRoom.dart';
import 'package:provider/provider.dart';
import 'package:mqtt_app/Pages/Room/Room.dart';
import 'package:mqtt_app/Pages/home/Alert/Alert_card.dart';
import 'package:mqtt_app/Pages/home/Favourite/Favourite_card.dart';
import 'package:mqtt_app/items/Chart.dart';

class MySubRoom_Room extends StatefulWidget {
  final Room room;

  const MySubRoom_Room({super.key, required this.room});

  @override
  State<MySubRoom_Room> createState() => _MySubRoom_RoomState();
}

class _MySubRoom_RoomState extends State<MySubRoom_Room> {
  void _showEditDevicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EditDevicesDialog(room: widget.room);
      },
    );
  }

  void _showAddDevicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AddDevicesDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191919),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                widget.room.icon.startsWith('assets/')
                    ? Image.asset(
                        widget.room.icon,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(widget.room.icon),
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Color.fromARGB(0, 25, 25, 25).withOpacity(0),
                        Color(0xff191919).withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 350,
                  child: SizedBox(
                    height: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Iconsax.arrow_left_2,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.room.name.toUpperCase(),
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 5),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          child: IconButton(
                            icon: Icon(Icons.more_horiz),
                            padding: EdgeInsets.all(0),
                            color: Colors.white,
                            onPressed: () => _showEditDevicesDialog(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 110,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Devices',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      offset: Offset(0, 3),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _showEditDevicesDialog(context),
                                child: Text(
                                  '${widget.room.devices} DEVICES',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(0, 3),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 320,
                          height: 120,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: const [
                                SizedBox(
                                  width: 20,
                                ),
                                FavouriteCardSubscribe(
                                    category: 'SECURITY',
                                    name: 'DOOR',
                                    icon: 'assets/Icons/smart-door.png',
                                    textStatus: 'LOCK',
                                    topics: ['Security : Door'],
                                    result: 'Door Status'),
                                SizedBox(
                                  width: 15,
                                ),
                                FavouriteCardPublish(
                                    category: 'LIVING ROOM',
                                    name: 'LIGHT',
                                    icon: 'assets/Icons/lamp.png',
                                    textStatus: 'TURN',
                                    topics: ['Living Room : Light'],
                                    result: 'Light Status'),
                                SizedBox(
                                  width: 15,
                                ),
                                FavouriteCardSubscribe(
                                    category: 'GAMES ROOM',
                                    name: 'POWER',
                                    icon: 'assets/Icons/power-off.png',
                                    textStatus: 'TURN',
                                    topics: ['Games Room : Power'],
                                    result: 'Power Status'),
                                SizedBox(
                                  width: 15,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                width: 300,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'My Sensor',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(0, 3),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '2 DEVICE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(0, 3),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 320,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyAlertCard(
                                      category: 'SENSOR',
                                      name: 'ULTRASONIC',
                                      topics: ['Sensor : Ultrasonic'],
                                    ),
                                    MyAlertCard(
                                      category: 'SENSOR',
                                      name: 'PUMP',
                                      topics: ['Sensor : Pump'],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 420, child: Mychart_Meter()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditDevicesDialog extends StatefulWidget {
  final Room room;

  EditDevicesDialog({required this.room});

  @override
  _EditDevicesDialogState createState() => _EditDevicesDialogState();
}

class _EditDevicesDialogState extends State<EditDevicesDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Widget Device',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xffF5B553),
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      alignment: Alignment.center,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.room.devices; i++)
            ListTile(
              title: Container(
                width: 400,
                height: 45,
                decoration: BoxDecoration(
                    color: Color(0xff191919),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff000000).withOpacity(0.8),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ]),
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    prefixIcon: Icon(
                      Icons.device_hub,
                      color: Colors.white,
                      size: 20,
                    ),
                    suffixIcon: Row(
                      children: [
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Iconsax.heart5,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            // Handle delete device
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            // Handle delete device
                          },
                        ),
                      ],
                    ),
                    hintText: "         Device Widget",
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 12),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Color(0xff191919),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Container(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
                onPressed: () {}),
            TextButton(
              onPressed: () {
                // Handle submit
                Navigator.of(context).pop();
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'SUBMIT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff191919),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                alignment: Alignment.center,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                // Handle add device
              },
            ),
          ],
        )
      ],
    );
  }
}

class AddDevicesDialog extends StatefulWidget {
  const AddDevicesDialog({super.key});

  @override
  State<AddDevicesDialog> createState() => _AddDevicesDialogState();
}

class _AddDevicesDialogState extends State<AddDevicesDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Widget Device',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xffF5B553),
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
