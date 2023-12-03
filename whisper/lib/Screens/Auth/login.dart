import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:whisper/Provider/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String verify = "";
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();

  String? validatePhoneNumber(String value) {
    if (value.length != 10) {
      return 'Phone number must have exactly 10 digits';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.network(
                    'https://lottie.host/70325e3a-ede7-4735-a1df-5b7f5d9f2b6d/uT2PqYdXQ5.json'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Phone Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Please sign up your phone before getting started",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .baseline, // or CrossAxisAlignment.center
                    textBaseline:
                        TextBaseline.ideographic, // or TextBaseline.ideographic
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: phone,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your phone number",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a mobile number";
                            } else if (value.length != 10) {
                              return "Please enter a valid Mobile number";
                            }
                            // return validatePhoneNumber(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await Provider.of<Auth>(context, listen: false)
                            .submitPhoneNumber(phone.text.toString(), context);
                      }
                    },
                    child: Text("Send OTP"),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(160, 119, 39, 176),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
