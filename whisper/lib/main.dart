import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/Screens/Common/errorScreen.dart';
import 'package:whisper/Screens/Common/loadingScreen.dart';
import 'package:whisper/Screens/OnBoardingScreen/onboarding1.dart';
import 'package:whisper/Screens/OnBoardingScreen/welcome_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

final firebaseInitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialize = ref.watch(firebaseInitializerProvider);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
        // home: initialize.when(
        //   data: (data) {
        //     return AuthChecker();
        //   },
        //   error: (error, stackTrace) => ErrorScreen(error, stackTrace),
        //   loading: () => LoadingScreen(),
        );
  }
}
