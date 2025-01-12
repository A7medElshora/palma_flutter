import 'package:flutter/material.dart';
import 'package:p_p/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:p_p/Otp/forgot_password.dart';
import 'package:p_p/Screens/NavBar.dart';
import 'package:p_p/Screens/SignUp.dart';
import 'package:p_p/localization.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool _isObscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.language),
      //       onPressed: () {
      //         final localeNotifier =
      //             Provider.of<LocaleNotifier>(context, listen: false);
      //         final currentLocale = localeNotifier.currentLocale;
      //         final newLocale = currentLocale.languageCode == 'en'
      //             ? Locale('ar')
      //             : Locale('en');
      //         localeNotifier.changeLocale(newLocale.languageCode);
      //       },
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Form Container
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
                          AppLocalizations.of(context)!.translate('Login'),
                          style: TextStyle(
                            color: Color(0xff3C6255),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('Sign in to your account'),
                          style: TextStyle(color: Color(0xff61876E)),
                        ),
                        SizedBox(height: 30),
                        // Email Field
                        _buildTextField(
                          controller: _emailController,
                          labelText:
                              AppLocalizations.of(context)!.translate('Email'),
                          prefixIcon: Icons.email,
                          validator: (value) => value == null || value.isEmpty
                              ? AppLocalizations.of(context)!
                                  .translate('Please enter your email')
                              : null,
                        ),
                        SizedBox(height: 10),
                        // Password Field
                        _buildTextField(
                          controller: _passwordController,
                          labelText: AppLocalizations.of(context)!
                              .translate('Password'),
                          prefixIcon: Icons.lock,
                          obscureText: _isObscurePassword,
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
                          validator: (value) => value == null || value.isEmpty
                              ? AppLocalizations.of(context)!
                                  .translate('Please enter your password')
                              : null,
                        ),
                        SizedBox(height: 15),
                        // Remember Me and Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (newValue) {
                                    setState(() {
                                      rememberMe = newValue!;
                                    });
                                  },
                                  activeColor: Color(0xff3C6255),
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate('Remember Me'),
                                  style: TextStyle(
                                    color: Color(0xff3C6255),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ForgotPassword();
                                }));
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('Forgot Password?'),
                                style: TextStyle(color: Color(0xff3C6255)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        // Login Button
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              logIn();
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
                                AppLocalizations.of(context)!.translate('Login'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translate("Don't have an account? "),
                              style: TextStyle(color: Colors.black54),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("Sign Up"),
                                style: TextStyle(
                                    color: Color(0xff3C6255),
                                    fontWeight: FontWeight.bold),
                              ),
                            )
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(prefixIcon, color: Color(0xff3C6255)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void logIn() async {
    try {
      final response = await Dio().post(
        "https://api.escuelajs.co/api/v1/auth/login",
        data: {
          "email": _emailController.text,
          "password": _passwordController.text,
        },
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavyBar(title: '')),
      );
    } on DioException catch (e) {
      print("Login error: ${e.response}");
      if (e.response?.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!
              .translate('Invalid email or password!')),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
