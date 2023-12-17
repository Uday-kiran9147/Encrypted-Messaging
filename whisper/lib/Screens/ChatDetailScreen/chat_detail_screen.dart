// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/Encryption/encryption.dart';
import 'package:whisper/Services/DataBaseService/database_services.dart';

import '../../Models/message.dart';

class ChatDetailScreen extends StatefulWidget {
  final String randomUserId;
  final String randomUserEmail;
  final String image;
  const ChatDetailScreen({
    Key? key,
    required this.randomUserId,
    required this.randomUserEmail,
    required this.image,
  }) : super(key: key);
  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with WidgetsBindingObserver {
  final DataBaseService _dataService = DataBaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  EncryptionService em = EncryptionService();

  final TextEditingController _messageController = TextEditingController();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String statu = "";

  Keys currentUserKey = Keys(0, 0);
  Keys randomUserKey = Keys(0, 0);

  Future<void> getRandonUserPublicKey() async {
    DocumentSnapshot userSnapshot = await _firebaseFirestore
        .collection('users')
        .doc(widget.randomUserId)
        .get();

    final int randomUserPublicKEY = userSnapshot['public_key'];

    final int randomUserprivateKEY = userSnapshot['private_key'];

    randomUserKey.public = randomUserPublicKEY;
    randomUserKey.private = randomUserprivateKEY;

    print(randomUserKey.toString());
  }

  Future<void> getCurrentUserPrivateKey() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    final int currentUserPrivateKEY = userSnapshot['private_key'];
    final int currentUserPublicKEY = userSnapshot['public_key'];
    currentUserKey.private = currentUserPrivateKEY;
    currentUserKey.public = currentUserPublicKEY;

    // print(currentUserKey.toString());
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      List<int> encryptedValues = em.encrypt(_messageController.text,
          (currentUserKey.public + randomUserKey.public).toString());
      await _dataService.sendMessage(widget.randomUserId, encryptedValues);
      _messageController.clear();
    } else {
      // print("Empty Message");
    }
  }

  @override
  void initState() {
    getKeys();
    super.initState();
    WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
    setStatus("Online");
  }

  void setStatus(String status) async {
    setState(() {
      statu = status;
    });
    print('Status updated to: $status');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //Online
      setStatus("online");
    } else {
      //Offline
      setStatus("Offline");
    }
  }

  getKeys() async {
    await getRandonUserPublicKey();
    await getCurrentUserPrivateKey();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(statu);
    return Scaffold(
      backgroundColor: Color(0xFF262A34),
      appBar: _buildAppBar(context, widget.randomUserEmail, widget.image),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                StreamBuilder(
                    stream: _dataService.getMessages(
                        _auth.currentUser!.uid, widget.randomUserId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return MessageWidget(
                            messages: Message.fromMap(snapshot.data!.docs[index]
                                .data() as Map<String, dynamic>),
                            currentUserKeys: currentUserKey,
                            randomUserKeys: randomUserKey,
                          );
                        },
                      );
                    }),
                const SizedBox(
                  // Try to match height and below container height
                  height: 60,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.deepPurple[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFF2C384A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                          fillColor: Color.fromARGB(255, 204, 183, 240),
                          filled: true,
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: sendMessage,
                    backgroundColor: Color(0xFF2C384A),
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String emali, String imageurl) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                imageurl.isEmpty
                    ? const CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Color(0xFF2C384A),
                        child: Icon(
                          Icons.person,
                          size: 30,
                        ))
                    : CircleAvatar(
                        maxRadius: 30, backgroundImage: NetworkImage(imageurl)),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          emali,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 6,
                      // ),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          statu,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.more_vert,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  MessageWidget({
    Key? key,
    required this.messages,
    required this.currentUserKeys,
    required this.randomUserKeys,
  }) : super(key: key);

  final Message messages;
  final Keys currentUserKeys;
  final Keys randomUserKeys;
  EncryptionService em = EncryptionService();

  @override
  Widget build(BuildContext context) {
    String decryptedString = em.decryptMessage(messages.message.toList(),
        (currentUserKeys.public + randomUserKeys.public).toString());
    BorderRadius borderRadius =
        messages.senderId == FirebaseAuth.instance.currentUser!.uid
            ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))
            : const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20));

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Align(
        alignment: messages.senderId == FirebaseAuth.instance.currentUser!.uid
            ? Alignment.topRight
            : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
              color:
                  (messages.senderId == FirebaseAuth.instance.currentUser!.uid
                      ? Colors.deepPurple[100]
                      : Colors.grey.shade200),
              borderRadius: borderRadius),
          padding: const EdgeInsets.all(10),
          child: Text(
            decryptedString,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
