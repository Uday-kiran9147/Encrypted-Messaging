import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/Screens/Secure/secure_file_storage.dart';

import '../../Provider/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  File? _file;
  // Replace these with your actual user data
  String username = "-";
  String status = "Available";
  String bio = "bio";
  String about = "Plz tell about u.";
  String imageUrl = "";

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 250,
    );
    if (pickedImage != null) {
      setState(() {
        _file = File(pickedImage.path);
      });
    }
  }

  Future<void> _loadProfileData() async {
    // _prefs = await SharedPreferences.getInstance();
    DocumentSnapshot userdocumentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      _nameController.text = userdocumentSnapshot['name'] ?? username;
      _bioController.text = userdocumentSnapshot['bio'] ?? bio;
      _aboutController.text = userdocumentSnapshot["about"] ?? about;
      imageUrl = userdocumentSnapshot["image"] ?? "";
    });
    print(userdocumentSnapshot.toString());
  }

  Future<void> _saveProfileData() async {
    // _prefs.setString('name', _nameController.text);
    // _prefs.setString('bio', _bioController.text);
    // _prefs.setString('about', _aboutController.text);
    await Provider.of<Auth>(context, listen: false).editProfile(
        _nameController.text, _bioController.text, _aboutController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2C384A),
        title: const Center(child: Text('Profile')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              if (_file != null) {
                await Provider.of<Auth>(context, listen: false).saveprofilepicture(_file!).then((value) {
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile picture updated'),
                      ),
                    );
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(backgroundColor: Colors.red,
                        content: Text('Something went wrong picture not updated!'),
                      ),
                    );
                  }
                 
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap:_getImage,
              child: Container(
                width: 145,
                height: 145,
                decoration: BoxDecoration(
                
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: _file != null || imageUrl.isEmpty
                    ? _file != null
                        ? CircleAvatar(
                            radius: 53, backgroundImage: FileImage(_file!))
                        : const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 220, 214, 214),
                            radius: 53,
                            child: Icon(
                              color:Color(0xFF262A34),
                              Icons.person,
                              size: 53,
                            ))
                    : CircleAvatar(
                        radius: 50, backgroundImage: NetworkImage(imageUrl)),
                // IconButton.outlined(
                // (imageUrl.isEmpty || imageUrl.startsWith('http') == false)
                //     ? const CircleAvatar(
                //         radius: 53,
                //         child: Icon(
                //           Icons.person,
                //           size: 53,
                //         ))
                //     : CircleAvatar(
                //         radius: 53,
                //         backgroundImage: NetworkImage(imageUrl)),
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.person_3_rounded),
              title: const Text(
                'Name',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _nameController.text,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog(context, 'Edit Name', _nameController);
                },
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text(
                'Bio',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _bioController.text,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog(context, 'Edit Bio', _bioController);
                },
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text(
                'About',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _aboutController.text,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog(context, 'Edit About', _aboutController);
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 45,
              width: 130,
              child: ElevatedButton(
                
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF262A34),
                  shadowColor:Colors.grey,
                  elevation: 10,
                  
                ),
                onPressed: (){
                
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SecureFile()));
              }, child: Text('Secure storage')),
            )
          ],
        ),
      ),
    );
  }

  _showEditDialog(BuildContext context, String title,
      TextEditingController controller) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter $title',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          controller.text = controller.text.trim();
                        });
                        _saveProfileData(); // Save changes to SharedPreferences
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF262A34),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _editProfile(BuildContext context) {
    _showEditDialog(context, 'Edit Name', _nameController);
    _showEditDialog(context, 'Edit Bio', _bioController);
    _showEditDialog(context, 'Edit About', _aboutController);
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const ProfileScreen(),
  ));
}
