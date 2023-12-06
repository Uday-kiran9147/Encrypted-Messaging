import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/Models/message.dart';

class DataBaseService {
  // get instance of Auth and Firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // SEND message
  Future<void> sendMessage(String receiverId, String messageText) async {
    print('database');
    // getcurrent user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.phoneNumber!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message message = Message(
        senderId: currentUserId,
        senderEmali: currentUserEmail,
        receiverId: receiverId,
        message: messageText,
        timeStamp: timestamp);

    List<String> userids = [currentUserId, receiverId];
    userids
        .sort(); // sort ids first to make sure that the same chat room is created between two users
    // construct chart room between sender and receiver
    String chatRoomId = userids.join("_");
    // add new message to database
    await _firebaseFirestore
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('Messages')
        .add(message.toMap());
  }

  // GET messages
  Stream<QuerySnapshot> getMessages(String currentUserId, randomUserId) {
    List<String> userids = [currentUserId, randomUserId];
    userids.sort();
    String chatRoomId = userids.join("_");
    return _firebaseFirestore
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('Messages')
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }
}
