import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mqtt_app/Pages/Login/Login.dart';
import 'package:mqtt_app/Pages/Provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xff191919),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Image.asset(
                  'assets/images/Background.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                        Color(0xff191919).withOpacity(0.3),
                        Color(0xff191919).withOpacity(0.95),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  child: Container(
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.home_work,
                          color: Colors.white,
                        ),
                        Text(
                          'PROFILE',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            shadows: [
                              BoxShadow(
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
                            icon: Icon(Icons.settings),
                            color: Colors.white,
                            padding: EdgeInsets.all(0),
                            constraints: BoxConstraints(),
                            onPressed: () => _SettingWidgetDialog(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    CircleAvatar(
                      radius: 53,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: userProvider.imagePath.isNotEmpty
                            ? FileImage(File(userProvider.imagePath))
                            : AssetImage('assets/images/Avatar.png')
                                as ImageProvider,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      userProvider.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.normal,
                        shadows: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 0),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      userProvider.email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        shadows: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 0),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                          //color: Colors.white
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              userProvider.location,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, 0),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        children: [
                          MyProfileButton_full(
                            images: [
                              'assets/Icons/Social/facebook.png',
                              'assets/Icons/Social/instagram.png',
                              'assets/Icons/Social/twitter.png'
                            ],
                            urls: [
                              'https://www.facebook.com',
                              'https://www.instagram.com',
                              'https://www.twitter.com'
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: 300,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MyProfileButton(
                                name: 'Device',
                                icon: FaIcon(
                                  FontAwesomeIcons.robot,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                url: 'https://www.example.com',
                              ),
                              MyProfileButton(
                                name: 'Statics',
                                icon: FaIcon(
                                  FontAwesomeIcons.chartPie,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                url: 'https://www.example.com',
                              ),
                              MyProfileButton(
                                name: 'Manage',
                                icon: FaIcon(
                                  FontAwesomeIcons.userTie,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                url: 'https://www.example.com',
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MyProfileButton(
                                name: 'Notification',
                                icon: FaIcon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                url: 'https://www.example.com',
                              ),
                              MyProfileButton(
                                name: 'Help',
                                icon: FaIcon(
                                  FontAwesomeIcons.headset,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                url: 'https://www.example.com',
                              ),
                              MyProfileButton(
                                name: 'Logout',
                                icon: FaIcon(
                                  FontAwesomeIcons.arrowRightFromBracket,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyLogin()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _SettingWidgetDialog(BuildContext context) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    final result = await showDialog(
      context: context,
      builder: (context) {
        return SettingWidget(
          initialName: userProvider.name,
          initialEmail: userProvider.email,
          initialLocation: userProvider.location,
          initialImagePath: userProvider.imagePath,
        );
      },
    );

    if (result != null) {
      userProvider.updateUser(
        result['name'],
        result['email'],
        result['location'],
        result['imagePath'],
      );
    }
  }
}

class SettingWidget extends StatefulWidget {
  final String initialImagePath;
  final String initialName;
  final String initialEmail;
  final String initialLocation;

  const SettingWidget({
    super.key,
    required this.initialImagePath,
    required this.initialName,
    required this.initialEmail,
    required this.initialLocation,
  });

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  String _imagePath = '';
  bool _isImageChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _emailController.text = widget.initialEmail;
    _locationController.text = widget.initialLocation;
    _imagePath = widget.initialImagePath;
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final fileName = pickedFile.name;
      final newPath = '$path/$fileName';
      final file = File(pickedFile.path);
      file.copy(newPath);

      setState(() {
        _imagePath = newPath;
        _isImageChanged = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Setting Information',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xffF5B553),
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      backgroundColor: Color(0xff191919),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 53,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _isImageChanged
                  ? FileImage(File(_imagePath))
                  : AssetImage(widget.initialImagePath) as ImageProvider,
            ),
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
                Icons.person,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 20,
              ),
            ),
          ),
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
              hintText: "Profile Name",
              hintStyle:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              filled: true,
              fillColor: Color(0xff191919),
            ),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          TextFormField(
            controller: _emailController,
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
              hintText: "Profile Email",
              hintStyle:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              filled: true,
              fillColor: Color(0xff191919),
            ),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          TextFormField(
            controller: _locationController,
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
              hintText: "Profile Location",
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'location': _locationController.text,
                  'imagePath': _imagePath,
                });
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
          ],
        )
      ],
    );
  }
}

class MyProfileButton extends StatelessWidget {
  final String name;
  final Widget icon;
  final Function? onPressed; // Add an optional onPressed function
  final String? url;

  const MyProfileButton({
    super.key,
    required this.name,
    required this.icon,
    this.onPressed, // Update the constructor to include onPressed
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xff191919),
          boxShadow: [
            BoxShadow(
              color: Color(0xff000000),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ]),
      child: GestureDetector(
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          } else if (url != null) {
            _launchURL(url!);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                  color: Color(0xffF5B553),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal),
            ),
            icon,
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class MyProfileButton_full extends StatelessWidget {
  final List<String> images;
  final List<String> urls;

  const MyProfileButton_full(
      {super.key, required this.images, required this.urls});

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(images.length == urls.length,
        'Images and URLs lists must have the same length');

    return Container(
      width: 300,
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xff191919),
          boxShadow: [
            BoxShadow(
              color: Color(0xff000000),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return GestureDetector(
                onTap: () => _launchURL(urls[index]),
                child: Image.asset(
                  images[index],
                  width: 30,
                ),
              );
            })),
      ),
    );
  }
}
