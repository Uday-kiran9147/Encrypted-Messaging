// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  final TextEditingController _messageController = TextEditingController();

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _dataService.sendMessage(
          widget.randomUserId, _messageController.text);
      // print(_messageController.text);
      _messageController.clear();
    } else {
      // print("Empty Message");
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
