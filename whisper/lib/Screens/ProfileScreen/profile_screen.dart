import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();

  // Replace these with your actual user data
  String username = "Mahi";
  String status = "Available";
  String bio = "bio.";
  String about = "Plz tell about u.";
  String imageUrl =
      "https://images.indianexpress.com/2020/10/148841-clraytzonv-1602133322.jpg";

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      _nameController.text = _prefs.getString('name') ?? username;
      _bioController.text = _prefs.getString('bio') ?? bio;
      _aboutController.text = _prefs.getString('about') ?? about;
    });
  }

  Future<void> _saveProfileData() async {
    if (_prefs == null) return; // Add null check here
    _prefs.setString('name', _nameController.text);
    _prefs.setString('bio', _bioController.text);
    _prefs.setString('about', _aboutController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(child: Text('Profile')),
        
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person_3_rounded),
              title: Text(
                'Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _nameController.text,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog(context, 'Edit Name', _nameController);
                },
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(
                'Bio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _bioController.text,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog(context, 'Edit Bio', _bioController);
                },
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                'About',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _aboutController.text,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog(context, 'Edit About', _aboutController);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showEditDialog(
      BuildContext context, String title, TextEditingController controller) async {
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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter $title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.grey,
                      ),
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          controller.text = controller.text.trim();
                        });
                        _saveProfileData(); // Save changes to SharedPreferences
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                      ),
                      child: Text('Save'),
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
    home: ProfileScreen(),
  ));
}
