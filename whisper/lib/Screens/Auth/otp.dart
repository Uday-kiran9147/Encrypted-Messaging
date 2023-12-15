// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_null_comparison

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/Models/user.dart';
import 'package:whisper/Screens/Auth/login.dart';
import 'package:whisper/Screens/home_screen.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                 
                Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                       
                        _buildTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'Enter your email address',
                          icon: Icons.email,
                        ),
                        _buildTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                       
                        _buildButton(
                          onPressed: () async {
                            await register(
                              _emailController.text,
                              _passwordController.text,
                            ).then((value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            });
                          },
                          label: 'Register',
                          color: Color(0xFF2C384A),
                        ),
                        _buildButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          label: 'Login',
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
      
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(color: Colors.black), 
        prefixIcon: Icon(icon,color: Colors.black,),
        focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black), // Change the border color here
        borderRadius: BorderRadius.circular(12.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black), // Change the border color here
        borderRadius: BorderRadius.circular(12.0),
      ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}


Future<void> register(
  String email,
  String password,
  
) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .whenComplete(() async {
           int privateKEY = Random().nextInt(5) + 100;
          int publicKEY = privateKEY * privateKEY;
          AppUser newuser = AppUser(
            id: FirebaseAuth.instance.currentUser!.uid,
            name: '',
            bio: '',
            about: '',
            image: '',
            password: password,
            email: email,
            private_key: privateKEY,
            public_key: publicKEY,
          );
      await FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(newuser.toMap());
    });
    print("User registered: ${userCredential.user?.uid}");
  } catch (e) {

  }
}