import 'package:flutter/material.dart';
import 'package:whisper/Screens/ProfileScreen/profile_screen.dart';
import 'ChatScreen/chat_screen.dart';

class User {
  final String name;
  final String message;
  final String time;
  final String imageUrl;

  User({
    required this.name,
    required this.message,
    required this.time,
    required this.imageUrl,
  });
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  static List<Widget> bottomlist = <Widget>[const ChatScreen(), const ProfileScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomlist.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        type: BottomNavigationBarType.shifting,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Profile"),
        ],
      ),
    );
  }
}
