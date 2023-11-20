import 'package:flutter/material.dart';
import 'package:whisper/Screens/OnBoardingScreen/onboarding3.dart';
import 'package:whisper/Screens/OnBoardingScreen/onboarding1.dart';
import 'package:whisper/Screens/OnBoardingScreen/onboarding2.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  PageController controller = PageController();
  int currentPageValue = 0;

  final List<Widget> introWidgetsList = <Widget>[
    
    const OnboardingFirst(),
    const OnboardingSecond(),
    const OnboardingThird(),
    
  ];

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        PageView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: introWidgetsList.length,
          onPageChanged: (int page) {
            getChangedPageAndMoveBar(page);
          },
          controller: controller,
          itemBuilder: (context, index) {
            return introWidgetsList[index];
          },
        ),
        Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 35),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < introWidgetsList.length; i++)
                    if (i == currentPageValue) ...[circleBar(true)] else
                      circleBar(false),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}
