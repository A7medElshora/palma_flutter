import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:p_p/Screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image or Content
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/bg.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Bottom Container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 2 / 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                            color: Color(0xff3C6255),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        //Full Name
                        TextFormField(
                          controller: _fullNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your First name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xff3C6255),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        //Email
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            // You can add more complex email validation logic here
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Email",
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xff3C6255),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        //Phone
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Phone';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Phone",
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Color(0xff3C6255),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Password",
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color(0xff3C6255),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscurePassword = !_isObscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        //Confirm Password
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _isObscureConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color(0xff3C6255),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscureConfirmPassword =
                                      !_isObscureConfirmPassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              Log_in(context); // Pass the context here
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF9CCCA7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(100, 7, 100, 7),
                              child: Text(
                                '  Sign Up  ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don\'t have an account?",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    " Log In",
                                    style: TextStyle(
                                        color: Color(0xff3C6255),
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){print("FaceBook");},
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/images/FB.png'), // Replace with your Facebook logo image
                                radius: 30,
                              ),
                            ),
                            SizedBox(width: 16), // Adjust spacing between the icons and divider

                            SizedBox(width: 20), // Adjust spacing between the icons and divider
                            GestureDetector(
                              onTap: (){print("GooGle");},
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('assets/images/Google.png'), // Replace with your Google logo image
                                radius: 30,

                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void Log_in(BuildContext context) async {
    try {
      // Make your API request here to register the user
      // Example Dio request:
      final response = await Dio().post(
        "https://api.escuelajs.co/api/v1/users/",
        data: {
          "name": _fullNameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "avatar": "https://api.lorem.space/image/face?w=640&h=480"
        },
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      // Save the full name to SharedPreferences
      await prefs.setString('fullName', _fullNameController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on DioError catch (e) {
      print("Registration error: ${e.response}");
      if (e.response!.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid email or password!'),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print("Unexpected error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An unexpected error occurred. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
