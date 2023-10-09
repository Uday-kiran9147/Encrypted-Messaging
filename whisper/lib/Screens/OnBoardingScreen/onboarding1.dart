import 'package:flutter/material.dart';

class OnboardingFirst extends StatefulWidget {
  OnboardingFirst({key}) : super(key: key);

  @override
  _OnboardingFirstState createState() => _OnboardingFirstState();
}

class _OnboardingFirstState extends State<OnboardingFirst> {
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
        body: Column(
          children: <Widget>[
            SizedBox(height: height / 7),
            Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(height: 10),
                      Text("Welcome to WHISPER!\n",
                          style: const TextStyle(
                              color: const Color(0xfffaf5f0),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Graphik",
                              fontStyle: FontStyle.normal,
                              fontSize: 33.8),
                          textAlign: TextAlign.center),
                      SizedBox(height: 20),
                      Text("Privacy Beyond Boundaries\n",
                          style: const TextStyle(
                              color: const Color(0xfffaf5f0),
                              fontWeight: FontWeight.w100,
                              fontFamily: "Graphik",
                              fontStyle: FontStyle.normal,
                              fontSize: 25.8),
                          textAlign: TextAlign.center),
                      SizedBox(height: height / 20),
                      Center(
                          child: Image(
                        image: AssetImage(
                          'assets/onboarding1.png',
                        ),
                        width: 400,
                      )),
                      SizedBox(height: height / 20),
                      Text("Chat with friends and family seamlessly :)",
                          style: const TextStyle(
                              color: const Color(0xfffaf5f0),
                              // fontWeight: FontWeight.w700,
                              fontFamily: "Graphik",
                              fontStyle: FontStyle.normal,
                              fontSize: 16),
                          textAlign: TextAlign.center),
                    ])),
          ],
        ),
      ),
    );
  }
}
