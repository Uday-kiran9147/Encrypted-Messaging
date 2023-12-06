import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/Screens/Auth/otp.dart';
import 'package:whisper/Screens/Common/landingpage.dart';

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
    this.firebaseUser = FirebaseAuth.instance.currentUser!;
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

  Future<bool> login() async {
    int flag = 0;
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential!)
          .then((UserCredential authRes) {
        firebaseUser = authRes.user!;
        // // print(firebaseUser.toString());
      }).catchError((e) {
        flag = 1;
        _handleError(e);
        // // print("handle error in login1");
      });
      if (flag == 0)
        return true;
      else
        return false;
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
    String phoneNumber = "+91 " + phone.toString().trim();

    void verificationCompleted(AuthCredential phoneAuthCredential) {
      this._phoneAuthCredential = phoneAuthCredential;
    }

    void verificationFailed(FirebaseAuthException error) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LandingPage()));
      _handleError(error);
    }

    void codeSent(String verificationId, code) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyOtp(phone)));
      this._verificationId = verificationId;
      this._code = code;
    }

    void codeAutoRetrievalTimeout(String verificationId) {}

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(milliseconds: 10000),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<bool> submitOTP(String otp) async {
    String smsCode = otp.toString().trim();
    this._phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: smsCode);
    bool islogin = await login();

    return islogin;
  }

  void displayUser() {
    // print(firebaseUser.toString());
  }
}
