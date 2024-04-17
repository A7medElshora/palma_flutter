import 'package:flutter/material.dart';
import 'package:p_p/Otp/verfication_screen.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = "/forgot-password";
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: OverflowBar(
                      overflowSpacing: 10,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Color(0xff3C6255),
                              fontSize: 34,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Please enter your email or phone number to search for your account.",
                          style: TextStyle(
                              color: Color(0xFF56B098),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 22),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          // margin: EdgeInsets.all(12),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color(0xff3C6255),
                              ),
                            ),
                            //validator
                            validator: (value) {
                              if (value!.length < 6) {
                                return 'Email must be above 6 character';
                              }
                              if (value.isEmpty) {
                                return 'Please enter your Password';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 28),
                        //send code button
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 57,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              primary: Color(0xff3C6255),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return OTPVerification();
                                }));
                              }
                            },
                            child: Text(
                              'send code',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF56B098),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
