import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/Models/user.dart';
import 'package:whisper/Screens/Auth/otp.dart';
import 'package:whisper/Services/DataBaseService/database_services.dart';
import 'package:whisper/Services/DataBaseService/profile_edit.dart';

class Auth with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? firebaseUser;
  static bool didSighOut = false;
  static String? uid;
  AuthCredential? _phoneAuthCredential;
  String? _verificationId;
  int? _code;

  void _handleError(e) {}
  Future<void> getFirebaseUser() async {
    firebaseUser = FirebaseAuth.instance.currentUser!;
  }

  static bool get isAuth {
    User? user = FirebaseAuth.instance.currentUser;
    return user == null ? false : true;
  }

  static void userPhoneNumber() {
    var phoneNumberUser = FirebaseAuth.instance.currentUser!.phoneNumber;
  }

  static void setUid() {
    uid = FirebaseAuth.instance.currentUser!.uid.toString();
  }

  Future<void> editProfile(String name, about, bio) async {
    await EditProfile().editProfile(name, about, bio);
    notifyListeners();
  }

  Future<bool> saveprofilepicture(File image) async {
    await EditProfile.saveprofilepicture(image).then((value) {
      if (value) {
        notifyListeners();
        return value;
      }
    });
    return false;
  }

  Future<bool> login() async {
    int flag = 0;
    try {
      await FirebaseAuth.instance
          .signInWithCredential(_phoneAuthCredential!)
          .then((UserCredential authRes) async {
        // if (authRes.user == null) {
        var isuser = await FirebaseFirestore.instance
            .collection('users')
            .doc(Auth.uid)
            .get();
        if (isuser.exists == false) {
          // if user is not registered
          int privateKEY = Random().nextInt(5) + 100;
          int publicKEY = privateKEY * privateKEY;
          firebaseUser = authRes.user!;
          await DataBaseService().registerUserDetails(AppUser(
              id: firebaseUser!.uid,
              name: firebaseUser!.phoneNumber!,
              bio: '',
              about: '',
              image: '',
              phoneNumber: firebaseUser!.phoneNumber!,
              private_key: privateKEY,
              public_key: publicKEY));
          // }
          // print(firebaseUser.toString());
        }
      }).catchError((e) {
        flag = 1;
        _handleError(e);
        // // print("handle error in login1");
      });
      if (flag == 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<void> logout() async {
    didSighOut = true;
    try {
      await FirebaseAuth.instance.signOut();
      firebaseUser = null;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> submitPhoneNumber(String phone, context) async {
    String phoneNumber = "+91${phone.toString().trim()}";
    print(phoneNumber);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(milliseconds: 10000),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        _phoneAuthCredential = credential;
        // Verification is complete, handle authenticated user.
        // You can navigate to a new screen or perform any other action.
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure, e.g., display an error message.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message!),
          ),
        );
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _code = resendToken;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyOtp(phoneNumber),
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      // codeSent: codeSent,
      // codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
    print("otp sent");
  }

  Future<bool> submitOTP(String otp) async {
    String smsCode = otp.toString().trim();
    _phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: smsCode);
    bool islogin = await login();

    return islogin;
  }

  void displayUser() {
    // print(firebaseUser.toString());
  }
}
