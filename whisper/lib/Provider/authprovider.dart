import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/Provider/auth.dart';


final autheticationProvider = Provider<Authentication>((ref) {
  return Authentication();
});
final authStateProvider = StreamProvider<User?>(
  (ref) {
    return ref.read(autheticationProvider).authStateChange;
  },
);
