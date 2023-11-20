import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/Provider/auth.dart';
import 'package:whisper/Screens/ChatScreen/chat_tile.dart';

class ChatUsers {
  String name;
  String message;
  String imageURL;
  String time;
  ChatUsers(
      {required this.name,
      required this.message,
      required this.imageURL,
      required this.time});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      const Text(
                        "Chats",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser!.email!,
                      ),
                    ],
                  ),
                  FittedBox(
                      child: TextButton(
                          onPressed: () {
                            Authentication().signOut(context);
                          },
                          child: const Text("Logout")))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8.0),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (snapshot.data!.docs[index]['id'] ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        return Container();
                      } else {
                        return ConversationList(
                            documentSnapshot: snapshot.data!.docs[index]);
                      }
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
