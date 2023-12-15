import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whisper/Screens/Auth/login.dart';
import 'package:whisper/Screens/Common/splashScreen.dart';
import 'Provider/auth.dart';
import 'Screens/OnBoardingScreen/welcome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(context),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: SplashScreen());
        } else {
          return MultiProvider(
            providers: [
           
              ChangeNotifierProvider<Auth>(
                create: (_) => Auth(),
              ),
             
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Whisper',
              theme: ThemeData(
                primaryColor: Colors.pinkAccent,
              ),
              home: getHome(snapshot.data),
            ),
          );
        }
      },
    );
  }

  Widget getHome(int authLevel) {
    switch (authLevel) {
      case -1:  
        return  LoginScreen();
      // break;
      case 0:
        return const WelcomePage();
      // break;
      case 1:
        return const Home();
      // break;
      default:
        return const Center(child: Text('Something Went wrong : ((((('));
    }
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future<int?> initialize(BuildContext context) async {
    await Firebase.initializeApp();
    if (!Auth.isAuth) {
           return -1;
       } else {
      Auth.setUid();
      var userdocumentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(Auth.uid)
          .get();
     
      if (userdocumentSnapshot.exists) {
        return 1;
      } else {
        return 0;
      }
      }
    }

  }

