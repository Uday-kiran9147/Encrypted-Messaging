
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whisper/Screens/Auth/otp.dart';
import 'package:whisper/Screens/home_screen.dart';
class LoginScreen extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2C384A),
        title: Center(child: Text('Login')),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
          
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.network("https://lottie.host/2395d6da-2bef-4233-b076-9782273216d1/K7LxMjwK1U.json", animate: true),
        
              
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              Container(
                height: 45,
                width: 130,
                child: _buildButton(
                  
                  onPressed: () async {
                    print(_emailController.text);
                    print(_passwordController.text);
                    await signInWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    ).then((val) {
                      if (val) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                    });
                  },
                  
                  label: 'Login',
                  color: Color(0xFF262A34),
              
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: Text('Sign Up',style: TextStyle(color: Colors.black),),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
    Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
         labelStyle: TextStyle(color: Colors.black), 
        prefixIcon: Icon(icon,color: Colors.black,),
        focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black), // Change the border color here
        borderRadius: BorderRadius.circular(12.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black), // Change the border color here
        borderRadius: BorderRadius.circular(12.0),
      ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print("User signed in: ${userCredential.user?.uid}");
    // SHP.saveUserLoggedinStatusSP(true);
    return true;
  } catch (e) {
    print("Error during sign in: $e");
    // Fluttertoast.showToast(msg: e.toString());
    return false;

  }
}