import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/Screens/OnBoardingScreen/welcome_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      // home: initialize.when(
      //   data: (data) {
      //     return LoginPage();
      //   },
      // error: (error, stackTrace) => ErrorScreen(error, stackTrace),
      //   loading: () => LoadingScreen(),)
    );
  }
}
