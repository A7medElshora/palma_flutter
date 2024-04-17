import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_p/Screens/Login.dart';
import 'package:p_p/Screens/history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p_p/Screens/diseases.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late File _imageFile;
  final picker = ImagePicker();
  List<String> languages = ['English', 'العربية']; // Example languages
  String selectedLanguage = 'English'; // Default language
  TextEditingController _fullNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imageFile = File('assets/images/default_image.png');
    _loadImageFromPreferences();
    _fullNameController.text = ''; // Initialize the full name controller
    _getFullName(); // Fetch full name from SharedPreferences
  }

  Future<void> _loadImageFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');

    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _imageFile = File(imagePath!);
      });
    }
  }

  Future<void> _saveImageToPreferences(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', imagePath);
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _saveImageToPreferences(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  //Full Name from FignUp
  Future<void> _getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString('fullName');
    if (fullName != null) {
      setState(() {
        _fullNameController.text = fullName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.exit_to_app,color: Color(0xff3C6255),),
      //       onPressed: () {
      //         _showExitDialog(); // Show the exit dialog
      //       },
      //     ),
      //   ],
      // ),
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Profile Image"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            GestureDetector(
                              child: Text('Open Camera'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _getImage(ImageSource.camera);
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                            ),
                            GestureDetector(
                              child: Text('Select from Gallery'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _getImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: FileImage(_imageFile),
                  ),
                  SizedBox(height: 20),
                  // Display Full Name
                  Text(
                    _fullNameController.text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
          // Dark Mode Switch
          Container(
            margin: EdgeInsets.fromLTRB(7, 20, 7, 50),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3C6255)),
                  ),
                  value: Provider.of<ThemeNotifier>(context).themeMode ==
                      ThemeMode.dark,
                  onChanged: (value) {
                    Provider.of<ThemeNotifier>(context, listen: false)
                        .toggleTheme(value);
                    _saveDarkModePreference(value);
                  },
                  activeColor: Color(0xFF3C6255),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HistoryPage(
                                history: [],
                              )),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 20, 7, 0),
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      "History",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3C6255)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiseaseListPage()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 20, 7, 0),
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      "Info",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3C6255)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 20, 7, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Language',
                        style: TextStyle(
                            color: Color(0xff3C6255),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      // SizedBox(width: 180),
                      DropdownButton<String>(
                        value: selectedLanguage,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                          });
                        },
                        items: languages
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Color(0xff3C6255),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                // Log Out
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 20, 7, 10),
                      child: GestureDetector(
                        onTap: () {
                          _showExitDialog();
                        },
                        child: Row(
                          children: [
                            // Icon(
                            //   Icons.logout,
                            //   color: Color(0xff3C6255),
                            // ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              'LogOut ',
                              style: TextStyle(
                                  color: Color(0xff3C6255),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // Function to show the exit dialog
  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            '🥺',
            style: TextStyle(fontSize: 50),
          )),
          content: Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Are you sure to exit?',
                style: TextStyle(color: Color(0xff3C6255), fontSize: 22),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Color(0xff3C6255), fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    _logout(); // Call the logout function
                  },
                ),
                SizedBox(
                  width: 25,
                ),
                TextButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Color(0xff3C6255), fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // Function to handle logout
  void _logout() async {
    // Clear user data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Function to save dark mode
  Future<void> _saveDarkModePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}
