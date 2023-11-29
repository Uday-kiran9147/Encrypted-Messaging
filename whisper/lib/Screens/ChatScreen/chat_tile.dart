import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../ChatDetailScreen/chat_detail_screen.dart';

class ConversationListTile extends StatefulWidget {
  DocumentSnapshot documentSnapshot;

  ConversationListTile({
    super.key,
    required this.documentSnapshot,
  });
  @override
  _ConversationListTileState createState() => _ConversationListTileState();
}

class _ConversationListTileState extends State<ConversationListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                      randomUserEmail: widget.documentSnapshot['email'],
                      randomUserId: widget.documentSnapshot['id'],
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
        ),
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.w3schools.com/howto/img_avatar.png'),
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FittedBox(fit: BoxFit.contain,
                            child: Text(
                              widget.documentSnapshot['email'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const Text(
                            'Recent message',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              '8:09 PM',
            ),
          ],
        ),
      ),
    );
  }
}
