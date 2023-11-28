import 'package:flutter/material.dart';

class OnboardingSecond extends StatefulWidget {
  const OnboardingSecond({key}) : super(key: key);

  @override
  _OnboardingSecondState createState() => _OnboardingSecondState();
}

class _OnboardingSecondState extends State<OnboardingSecond> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor:Colors.deepPurple,
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
                      const Text("Encrypting the Conversation, Empowering You\n",
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
                          'assets/onboarding2.png',
                        ),
                        width: 300,
                      )),
                      SizedBox(height: height / 10),
                      const Text("Your conversations are shielded with end-to-end encryption, ensuring utmost privacy.",
                          style: TextStyle(
                              color: Color(0xfffaf5f0),
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
