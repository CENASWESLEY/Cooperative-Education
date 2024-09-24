import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mqtt_app/items/Button.dart';
import 'package:mqtt_app/pages/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  'assets/images/Screen.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Icons/Logo.png',
                        width: 164,
                        height: 182,
                      ),
                      SizedBox(height: 25),
                      Column(
                        children: [
                          Text(
                            'REGISTER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, 5),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                          ),
                          Text(
                            'Sign In To Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, 5),
                                  blurRadius: 5,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Column(
                        children: [
                          MyUserRegister(controller: _emailController),
                          SizedBox(height: 10),
                          MyPasswordRegister(controller: _passwordController),
                          SizedBox(height: 10),
                          MyConfirmPasswordRegister(
                              controller: _confirmPasswordController),
                          SizedBox(height: 20),
                          MyButtonRegister(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            confirmPasswordController:
                                _confirmPasswordController,
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have a account?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
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
                              SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyLogin()),
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color(0xffFFB267),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    decoration: TextDecoration.underline,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(0, 5),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Image.network(
                                      'https://static-00.iconduck.com/assets.00/facebook-color-icon-2048x2048-bfly1vxr.png',
                                      width: 20,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Image.network(
                                      'http://pngimg.com/uploads/google/google_PNG19635.png',
                                      width: 25,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Image.network(
                                      'https://cdn-icons-png.flaticon.com/512/154/154870.png',
                                      width: 20,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class MyUserRegister extends StatelessWidget {
  final TextEditingController controller;
  const MyUserRegister({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      child: TextFormField(
        controller: controller,
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
            Iconsax.user,
            color: Color(0xffFFFFFF).withOpacity(0.5),
            size: 20,
          ),
          hintText: "Username",
          hintStyle: TextStyle(color: Color(0xffFFFFFF).withOpacity(0.5)),
          filled: true,
          fillColor: Color(0xff191919),
        ),
        style: TextStyle(color: Color(0xffFFFFFF).withOpacity(0.5)),
      ),
    );
  }
}

class MyPasswordRegister extends StatefulWidget {
  final TextEditingController controller;
  const MyPasswordRegister({super.key, required this.controller});

  @override
  _MyPasswordRegisterState createState() => _MyPasswordRegisterState();
}

class _MyPasswordRegisterState extends State<MyPasswordRegister> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.blue),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5.5),
          ),
          prefixIcon: Icon(
            Iconsax.lock,
            color: Color(0xffFFFFFF).withOpacity(0.5),
            size: 20,
          ),
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: _togglePasswordVisibility,
            color: Colors.grey,
            iconSize: 20,
          ),
          filled: true,
          fillColor: Color(0xff191919),
        ),
        style: TextStyle(color: Color(0xffFFFFFF).withOpacity(0.5)),
      ),
    );
  }
}

class MyConfirmPasswordRegister extends StatefulWidget {
  final TextEditingController controller;
  const MyConfirmPasswordRegister({super.key, required this.controller});

  @override
  _MyConfirmPasswordRegisterState createState() =>
      _MyConfirmPasswordRegisterState();
}

class _MyConfirmPasswordRegisterState extends State<MyConfirmPasswordRegister> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.blue),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5.5),
          ),
          prefixIcon: Icon(
            Iconsax.lock,
            color: Color(0xffFFFFFF).withOpacity(0.5),
            size: 20,
          ),
          hintText: 'Confirm Password',
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: _togglePasswordVisibility,
            color: Colors.grey,
            iconSize: 20,
          ),
          filled: true,
          fillColor: Color(0xff191919),
        ),
        style: TextStyle(color: Color(0xffFFFFFF).withOpacity(0.5)),
      ),
    );
  }
}
