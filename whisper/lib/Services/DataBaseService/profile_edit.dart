import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile{
  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
    Future<bool> editProfile(String username, about,bio) async {
      print("edit profile called");
      print(FirebaseAuth.instance.currentUser!.uid);
    try {
      await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "name": username,
        "bio": bio,
        "about": about,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
    static Future<bool> saveprofilepicture(File image) async {
    try {
      final ref = FirebaseStorage.instance.ref().child("userProfile").child(
          "whisper-profile-${userCollection.id}-${FirebaseAuth.instance.currentUser!.uid}");
      await ref.putFile(image);
      final imageurl = await ref.getDownloadURL();
      //  DocumentReference userdocreference= await userCollection.add({});
      await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        "image": imageurl.toString(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}