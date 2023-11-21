// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/Services/DataBaseService/database_services.dart';
import 'package:cryptography/cryptography.dart';
import '../../Models/message.dart';

class ChatDetailScreen extends StatefulWidget {
  final String randomUserId;
  final String randomUserEmail;
  const ChatDetailScreen({
    Key? key,
    required this.randomUserId,
    required this.randomUserEmail,
  }) : super(key: key);
  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final DataBaseService _dataService = DataBaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> getRandonUserPublicKey() async {
    DocumentSnapshot userSnapshot = await _firebaseFirestore
        .collection('users')
        .doc(widget.randomUserId)
        .get();

    final String public = userSnapshot['public_key'];
    randomUserPublicKey = public;
    return public;
  }

  Future<List> getCurrentUserPrivateKey() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    final List privateKey = userSnapshot['private_key'];
    currentUserPrivateKey = privateKey.cast<int>().toList();
    return privateKey;
  }

  @override
  void initState() {
    getKeys();
    super.initState();
  }

  getKeys() async {
    await getRandonUserPublicKey().then((value) {
      randomUserPublicKey = value;
      print("Random user Public\n" + randomUserPublicKey);
    });
    await getCurrentUserPrivateKey().then((List value) {
      currentUserPrivateKey = value.cast<int>().toList();
      print("private key");
      print(currentUserPrivateKey);
    });
  }

  String randomUserPublicKey = '';
  List currentUserPrivateKey = [];
  String publicKeyUserB = '';
  final algorithm = X25519();
  final TextEditingController _messageController = TextEditingController();
  List<int>? encryptedMessage = null;
  String? decryptedMessage = null;
  String sharedSecret = '';

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _dataService.sendMessage(
          widget.randomUserId, _messageController.text);
      print(_messageController.text);
      _messageController.clear();
    } else {
      print("Empty Message");
    }
  }

  Future<void> encryptDecrypt() async {
    final userAKeyPair = await algorithm.newKeyPair();
    final userBKeyPair = await algorithm.newKeyPair();

    final userAPublicKey = await userAKeyPair.extractPublicKey();
    final userBPublicKey = await userBKeyPair.extractPublicKey();

    final sharedSecretKeyUserA = await algorithm.sharedSecretKey(
      keyPair: userAKeyPair,
      remotePublicKey: userBPublicKey,
    );

    final sharedSecretKeyUserB = await algorithm.sharedSecretKey(
      keyPair: userBKeyPair,
      remotePublicKey: userAPublicKey,
    );

    if (sharedSecretKeyUserA == sharedSecretKeyUserB) {
      final secretBoxAlgorithm = AesGcm.with256bits();
      final nonce = secretBoxAlgorithm.newNonce();

      final secretBox = await secretBoxAlgorithm.encrypt(
        _messageController.text.codeUnits,
        secretKey: sharedSecretKeyUserA,
        nonce: nonce,
      );

      final clearText = await secretBoxAlgorithm.decrypt(
        secretBox,
        secretKey: sharedSecretKeyUserB,
      );

      setState(() {
        encryptedMessage = secretBox.cipherText;
        decryptedMessage = String.fromCharCodes(clearText);
        // chatMessages.add('User A: ${myController.text}');
        // chatMessages.add('User B: $decryptedMessage');
        // myController.clear();
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, widget.randomUserEmail),
      body: Stack(
        children: <Widget>[
          ListView(
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
                                .data() as Map<String, dynamic>));
                      },
                    );
                  }),
              const SizedBox(
                // Try to match height and below container height
                height: 60,
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.deepPurple[50],
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
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
                    backgroundColor: Colors.blue,
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

  AppBar _buildAppBar(BuildContext context, String emali) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
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
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://buffer.com/library/content/images/2023/10/free-images.jpg"),
                maxRadius: 20,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      emali,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Online",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.settings,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.messages,
  });

  final Message messages;

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
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
          padding: const EdgeInsets.all(16),
          child: Text(
            messages.message,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}