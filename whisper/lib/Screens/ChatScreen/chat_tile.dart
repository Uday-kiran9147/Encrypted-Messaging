import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../ChatDetailScreen/chat_detail_screen.dart';

class ConversationList extends StatefulWidget {
  DocumentSnapshot documentSnapshot;

  ConversationList({
    super.key,
    required this.documentSnapshot,
  });
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
  final String imageurl = widget.documentSnapshot['image'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                      randomUserEmail: widget.documentSnapshot['phoneNumber'],
                      randomUserId: widget.documentSnapshot['id'],
                      image: widget.documentSnapshot['image'],
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
                    imageurl.isEmpty?  const CircleAvatar(
                            maxRadius: 30,
                            child: Icon(
                              Icons.person,
                              size: 30,
                            ))
                    : CircleAvatar(
                        maxRadius: 30, backgroundImage: NetworkImage(imageurl)),
                  
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.documentSnapshot['phoneNumber'],
                            style: const TextStyle(fontSize: 16),
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
