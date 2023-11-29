import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/Screens/OnBoardingScreen/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/Screens/home_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

final firebaseInitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialize = ref.watch(firebaseInitializerProvider);
    return MaterialApp(
      title: 'Whisper',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.purple[50],
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const WelcomePage();
            }
            return const Home();
          }),
      // home: initialize.when(
      //   data: (data) {
      //     return LoginPage();
      //   },
      // error: (error, stackTrace) => ErrorScreen(error, stackTrace),
      //   loading: () => LoadingScreen(),)
    );
  }
}
