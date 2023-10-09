import 'package:flutter/material.dart';

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
  final List<User> users = [
    User(
      name: "John Doe",
      message: "Hey, how's it going?",
      time: "10:30 AM",
      imageUrl:
          "https://randomuser.me/api/portraits/men/1.jpg", // Example image URL
    ),
    User(
      name: "Jane Smith",
      message: "Hello!",
      time: "9:45 AM",
      imageUrl:
          "https://randomuser.me/api/portraits/women/2.jpg", // Example image URL
    ),
    User(
      name: "Alice Johnson",
      message: "What's up?",
      time: "Yesterday",
      imageUrl:
          "https://randomuser.me/api/portraits/women/3.jpg", // Example image URL
    ),
     User(
      name: "John Doe",
      message: "Hey, how's it going?",
      time: "10:30 AM",
      imageUrl:
          "https://randomuser.me/api/portraits/men/1.jpg", // Example image URL
    ),
    User(
      name: "Jane Smith",
      message: "Hello!",
      time: "9:45 AM",
      imageUrl:
          "https://randomuser.me/api/portraits/women/2.jpg", // Example image URL
    ),
    User(
      name: "Alice Johnson",
      message: "What's up?",
      time: "Yesterday",
      imageUrl:
          "https://randomuser.me/api/portraits/women/3.jpg", // Example image URL
    ),
     User(
      name: "John Doe",
      message: "Hey, how's it going?",
      time: "10:30 AM",
      imageUrl:
          "https://randomuser.me/api/portraits/men/1.jpg", // Example image URL
    ),
    User(
      name: "Jane Smith",
      message: "Hello!",
      time: "9:45 AM",
      imageUrl:
          "https://randomuser.me/api/portraits/women/2.jpg", // Example image URL
    ),
    User(
      name: "Alice Johnson",
      message: "What's up?",
      time: "Yesterday",
      imageUrl:
          "https://randomuser.me/api/portraits/women/3.jpg", // Example image URL
    ),
     User(
      name: "John Doe",
      message: "Hey, how's it going?",
      time: "10:30 AM",
      imageUrl:
          "https://randomuser.me/api/portraits/men/1.jpg", // Example image URL
    ),
    User(
      name: "Jane Smith",
      message: "Hello!",
      time: "9:45 AM",
      imageUrl:
          "https://randomuser.me/api/portraits/women/2.jpg", // Example image URL
    ),
    User(
      name: "Alice Johnson",
      message: "What's up?",
      time: "Yesterday",
      imageUrl:
          "https://randomuser.me/api/portraits/women/3.jpg", // Example image URL
    ),
    // Add more users as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl),
            ),
            title: Text(user.name),
            subtitle: Text(user.message),
            trailing: Text(user.time),
          );
        },
      ),
    );
  }
}
