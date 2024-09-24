import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mqtt_app/Pages/Login/Register.dart';
import 'package:mqtt_app/items/Button.dart';
import 'package:mqtt_app/Pages/superpages.dart'; // Import the page to navigate after login
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mqtt_app/Pages/Login/auth_service.dart'; // Import AuthService
import 'package:firebase_auth/firebase_auth.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  final AuthService _authService = AuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Function to handle Google Sign-In
  void _signInWithGoogle() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Mysuperpages()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login with Google failed')),
      );
    }
  }

/*
  // Function to handle Facebook Sign-In
  void _signInWithFacebook() async {
    User? user = await _authService.signInWithFacebook();
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Mysuperpages()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login with Facebook failed')),
      );
    }
  }
*/

  @override
  Widget build(BuildContext context) {
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
                      'LOGIN',
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
                      'Login To Your Account',
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
                    MyUserLogin(controller: _emailController),
                    SizedBox(height: 10),
                    MyPasswordLogin(controller: _passwordController),
                    Container(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  'Remember Me',
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
                                Transform.scale(
                                  scale: 0.8,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value!;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    checkColor: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Text(
                              'Forgot password?',
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
                          ),
                        ],
                      ),
                    ),
                    MyButtonLogin(
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No have a account?',
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
                                builder: (context) => MyRegister(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign in',
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
                              onPressed: () {}, //_signInWithFacebook,
                              child: Image.asset(
                                'assets/Icons/Social/facebook.png',
                                width: 20,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
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
                              onPressed: _signInWithGoogle,
                              child: Image.asset(
                                'assets/Icons/Social/Google.png',
                                width: 20,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
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
                              child: Image.asset(
                                'assets/Icons/Social/apple.png',
                                width: 20,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.all(0),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyUserLogin extends StatelessWidget {
  final TextEditingController controller;
  const MyUserLogin({super.key, required this.controller});

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

class MyPasswordLogin extends StatefulWidget {
  final TextEditingController controller;
  const MyPasswordLogin({super.key, required this.controller});

  @override
  _MyPasswordLoginState createState() => _MyPasswordLoginState();
}

class _MyPasswordLoginState extends State<MyPasswordLogin> {
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
