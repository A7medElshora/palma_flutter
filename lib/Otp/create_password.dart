import 'package:flutter/material.dart';
import 'package:p_p/Otp/changed_password.dart';

class CreateNewPassword extends StatefulWidget {
  static const routeName = "/create-new-password";
  const CreateNewPassword({Key? key}) : super(key: key);

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final _formKey = GlobalKey<FormState>();

  //isObscureText
  bool isObscureText = true;
  bool isObscureTextTwo = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordagainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: OverflowBar(
                  overflowSpacing: 10,
                  children: [
                    SizedBox(height: 12,),
                    Text(
                      "Create New Password",
                      style: TextStyle(
                          color: Color(0xff3C6255),
                          fontSize: 34,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Create a new, strong password that you don't use for other Applications",
                      style: TextStyle(
                          color: Color(0xFF56B098),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 22),
                    //Password
                    Container(
                      margin: EdgeInsets.all(3),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: passwordController,
                        obscureText: isObscureText,
                        decoration: InputDecoration(
                          hintText: 'Create Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF56B098),
                            // color: Color(0xff9098B1),
                          ),
                          suffixIcon: IconButton(
                            color: Color(0xFF56B098),
                            onPressed: () {
                              setState(() {
                                isObscureText = !isObscureText;
                              });
                            },
                            icon: isObscureText
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility), // false
                          ),
                        ),
                        //validator
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return null;
                        },
                      ),
                    ),
                    //Confirm Password
                    Container(
                      margin: EdgeInsets.all(3),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: passwordagainController,
                        obscureText: isObscureTextTwo,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF56B098),
                          ),
                          suffixIcon: IconButton(
                            color: Color(0xFF56B098),
                            onPressed: () {
                              setState(() {
                                isObscureTextTwo = !isObscureTextTwo;
                              });
                            },
                            icon: isObscureTextTwo
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility), // false
                          ),
                        ),
                        //validator
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
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
                            if (passwordController.text ==
                                passwordagainController.text) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return PasswordChanged();
                              }));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("password don't match!!"),
                              ));
                            }
                          }
                        },
                        child: Text(
                          'Save Password',
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
      ),
    );
  }
}
