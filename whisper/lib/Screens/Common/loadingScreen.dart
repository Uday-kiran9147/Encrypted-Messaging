import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[100],
      child: const Center(
        child: SpinKitChasingDots(
          color: Color.fromARGB(255, 228, 118, 155),
          size: 50,
        ),
      ),
    );
  }
}
