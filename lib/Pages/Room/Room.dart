import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'SubRoom.dart';
import 'ChangeRoom.dart';

class MyRoom extends StatefulWidget {
  const MyRoom({super.key});

  @override
  State<MyRoom> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  @override
  Widget build(BuildContext context) {
    var roomModel = context.watch<RoomModel>();

    //ข้อความแจ้งเตือนหากไม่ใส่ device
    void _showAddWidgetDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AddWidgetDialog(
            //จะถูก ใช้เมื่อกด submit
            onSubmit: (name, device, icon) {
              // ทำการเพิ่มห้องใหม่ใน RoomModel
              var roomModel = context.read<RoomModel>();
              // ถ้า devices ถูกเติมแล้วก็จะ ไปที่ roomModel ที่สืบทอดคลาสจาก RoomModel
              if (device.isNotEmpty && int.tryParse(device) != null) {
                roomModel.addRoom(
                    Room(icon: icon, name: name, devices: int.parse(device)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Please enter a valid number for devices')),
                );
              }
            },
          );
        },
      );
    }

    void _showEditWidgetDialog(BuildContext context, int index) {
      var roomModel = context.read<RoomModel>();
      var room = roomModel.rooms[index];
      showDialog(
        context: context,
        builder: (context) {
          return EditWidgetDialog(
            initialName: room.name,
            initialDevice: room.devices.toString(),
            initialIcon: room.icon,
            onSubmit: (name, device, icon) {
              if (device.isNotEmpty && int.tryParse(device) != null) {
                roomModel.updateRoom(index,
                    Room(icon: icon, name: name, devices: int.parse(device)));
              } else {
                // Handle invalid input
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Please enter a valid number for devices')),
                );
              }
            },
            onDelete: () {
              roomModel.removeRoom(index);
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Color(0xff191919),
      body: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          Container(
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                Text(
                  'ROOM',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 15,
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
                Container(
                  height: 24,
                  width: 24,
                  child: IconButton(
                    icon: Icon(Icons.add_circle),
                    color: Colors.white,
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                    onPressed: () => _showAddWidgetDialog(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 330,
                  child: Column(
                    children: roomModel.rooms.map((room) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: MyRoomCard(
                          room: room,
                          onEdit: () => _showEditWidgetDialog(
                              context, roomModel.rooms.indexOf(room)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 70,
          )
        ],
      ),
    );
  }
}

class MyRoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onEdit;

  const MyRoomCard({
    super.key,
    required this.room,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MySubRoom_Room(room: room)));
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 320,
                height: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff000000).withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ]),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: room.icon.startsWith('assets/')
                    ? Image.asset(
                        room.icon,
                        width: 320,
                        height: 130,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(room.icon),
                        width: 320,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                width: 320,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Color(0xffFFB267).withOpacity(0.5),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: 290,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          room.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 3),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${room.devices} Devices',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 3),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: Icon(Icons.more_horiz),
                  color: Colors.white,
                  onPressed: onEdit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddWidgetDialog extends StatefulWidget {
  final Function(String name, String device, String icon) onSubmit;

  const AddWidgetDialog({super.key, required this.onSubmit});

  @override
  State<AddWidgetDialog> createState() => _AddWidgetDialogState();
}

class _AddWidgetDialogState extends State<AddWidgetDialog> {
  final _nameController = TextEditingController();
  final _deviceController = TextEditingController();
  String _icon = 'assets/images/Living.png';
  bool _isImageChanged = false;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _icon = pickedFile.path;
        _isImageChanged = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add New Widget',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xffF5B553),
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      backgroundColor: Color(0xff191919),
      iconColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
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
                Icons.widgets,
                color: Colors.white,
                size: 20,
              ),
              hintText: "         Name Widget",
              hintStyle:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              filled: true,
              fillColor: Color(0xff191919),
            ),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          TextFormField(
            controller: _deviceController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
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
              hintText: "         Device Widget",
              hintStyle:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              filled: true,
              fillColor: Color(0xff191919),
            ),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 5,
            ),
            TextButton(
              onPressed: pickImage,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(40, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff191919),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.image,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 20,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Center(
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {
                    widget.onSubmit(
                      _nameController.text,
                      _deviceController.text,
                      _icon,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'SUBMIT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff191919),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
            Spacer()
          ],
        )
      ],
    );
  }
}

class EditWidgetDialog extends StatefulWidget {
  final String initialName;
  final String initialDevice;
  final String initialIcon;
  final Function(String name, String device, String icon) onSubmit;
  final VoidCallback onDelete;

  const EditWidgetDialog({
    super.key,
    required this.initialName,
    required this.initialDevice,
    required this.initialIcon,
    required this.onSubmit,
    required this.onDelete,
  });

  @override
  State<EditWidgetDialog> createState() => _EditWidgetDialogState();
}

class _EditWidgetDialogState extends State<EditWidgetDialog> {
  final _nameController = TextEditingController();
  final _deviceController = TextEditingController();
  String _icon = '';
  bool _isImageChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _deviceController.text = widget.initialDevice;
    _icon = widget.initialIcon;
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _icon = pickedFile.path;
        _isImageChanged = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Widget',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xffF5B553),
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      backgroundColor: Color(0xff191919),
      iconColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 200,
            child: TextFormField(
              controller: _nameController,
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
                  Icons.widgets,
                  color: Colors.white,
                  size: 20,
                ),
                hintText: "     Name Widget",
                hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 12),
                filled: true,
                fillColor: Color(0xff191919),
              ),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Container(
            width: 200,
            child: TextFormField(
              controller: _deviceController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
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
                hintText: "     Device Widget",
                hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 12),
                filled: true,
                fillColor: Color(0xff191919),
              ),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: pickImage,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(40, 40),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xff191919),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.image,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 20,
                  ),
                )),
            TextButton(
              onPressed: () {
                if (_isImageChanged) {
                  widget.onSubmit(
                    _nameController.text,
                    _deviceController.text,
                    _icon,
                  );
                } else {
                  widget.onSubmit(
                    _nameController.text,
                    _deviceController.text,
                    widget.initialIcon,
                  );
                }
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(100, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Container(
                width: 110,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: const Text(
                    'SUBMIT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff191919),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.onDelete();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(40, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff191919),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
