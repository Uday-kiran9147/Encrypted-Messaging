import 'package:flutter/material.dart';
import 'package:whisper/Screens/Auth/login.dart';

class OnboardingThird extends StatefulWidget {
  const OnboardingThird({key}) : super(key: key);

  @override
  _OnboardingThirdState createState() => _OnboardingThirdState();
}

class _OnboardingThirdState extends State<OnboardingThird> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: ListView(
          children: <Widget>[
            // SizedBox(height: height / 7),
            Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(height: 10),
                      const Text("Privacy? We've Got You Covered.\n",
                          style: TextStyle(
                              color: Color(0xfffaf5f0),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Graphik",
                              fontStyle: FontStyle.normal,
                              fontSize: 33.8),
                          textAlign: TextAlign.center),
                      SizedBox(height: height / 12),
                      const Center(
                          child: Image(
                        image: AssetImage(
                          'assets/onboarding3.png',
                        ),
                        width: 300,
                      )),
                      SizedBox(height: height / 15),
          
                      const Text("Spice up your chats with fun stickers and expressive emojis",
                          style: TextStyle(
                              color: Color(0xfffaf5f0),
                              // fontWeight: FontWeight.w700,
                              fontFamily: "Graphik",
                              fontStyle: FontStyle.normal,
                              fontSize: 21),
                          textAlign: TextAlign.center),
                           const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          minimumSize: const Size(200, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        "Let's get started",
                        style: TextStyle(fontSize: 20),
                      )),
                          
                    ])),
          ],
        ),
      ),
    );
  }
}
