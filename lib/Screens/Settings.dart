import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:p_p/Screens/Login.dart';
import 'package:p_p/Screens/diseases.dart';
import 'package:p_p/localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late File _imageFile;
  final picker = ImagePicker();
  List<String> languages = ['English', 'العربية'];
  String selectedLanguage = 'English';
  final TextEditingController _fullNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imageFile = File('assets/images/default_image.png');
    _loadImageFromPreferences();
    _fullNameController.text = '';
    _getFullName();
    _loadSelectedLanguage();
  }

  Future<void> _loadImageFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('imagePath');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _imageFile = File(imagePath);
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
      final compressedFile = await _compressImage(File(pickedFile.path));
      if (compressedFile != null) {
        setState(() {
          _imageFile = compressedFile;
        });
        _saveImageToPreferences(compressedFile.path);
      }
    } else {
      print('No image selected.');
    }
  }

  Future<File?> _compressImage(File imageFile) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '${imageFile.absolute.path}_compressed.jpg',
    );
    return result != null ? File(result.path) : null;
  }

  void _showImageOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("profileImage")),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Color(0xff3C6255)),
                  title: Text(
                      AppLocalizations.of(context)!.translate("openCamera")),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Color(0xff3C6255)),
                  title: Text(AppLocalizations.of(context)!
                      .translate("selectFromGallery")),
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
  }

  void _showImagePreview() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("profileImage")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(_imageFile),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child:
                        Text(AppLocalizations.of(context)!.translate("edit")),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showImageOptions();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString('fullName');
    if (fullName != null) {
      setState(() {
        _fullNameController.text = fullName;
      });
    }
  }

  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      setState(() {
        selectedLanguage = languageCode == 'en' ? 'English' : 'العربية';
      });
    }
  }

  void _changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
    Locale locale = Locale(language == 'English' ? 'en' : 'ar');
    MyApp.of(context)!.setLocale(locale);
    _saveLanguageToPreferences(language);
  }

  Future<void> _saveLanguageToPreferences(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', language == 'English' ? 'en' : 'ar');
  }

  void _openPdf() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(pdfPath: 'assets/Models/pdf.pdf'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: _showImagePreview,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: FileImage(_imageFile),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _fullNameController.text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3C6255),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                AppLocalizations.of(context)!.translate('dark_mode'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C6255),
                ),
              ),
              value: Provider.of<ThemeNotifier>(context).themeMode ==
                  ThemeMode.dark,
              onChanged: (value) {
                Provider.of<ThemeNotifier>(context, listen: false)
                    .toggleTheme(value);
                _saveDarkModePreference(value);
              },
              activeColor: Color.fromARGB(255, 72, 223, 170),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Icon(Icons.info, color: Color(0xff3C6255)),
              title: Text(
                AppLocalizations.of(context)!.translate('info'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C6255),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiseaseListPage()),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Icon(Icons.language, color: Color(0xff3C6255)),
              title: Text(
                AppLocalizations.of(context)!.translate('lang'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C6255),
                ),
              ),
              onTap: () {
                _showLanguageBottomSheet();
              },
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Icon(Icons.chat, color: Color(0xff3C6255)),
              title: Text(
                'Chat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C6255),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBotPage()),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Color(0xff3C6255)),
              title: Text(
                'فتح ملف PDF',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C6255),
                ),
              ),
              onTap: _openPdf,
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Icon(Icons.exit_to_app, color: Color(0xff3C6255)),
              title: Text(
                AppLocalizations.of(context)!.translate('logout'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3C6255),
                ),
              ),
              onTap: _showExitDialog,
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: languages.map((String language) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                    language == 'English'
                        ? 'assets/images/1.png'
                        : 'assets/images/1.png',
                  ),
                ),
                title: Text(
                  language,
                  style: TextStyle(color: Color(0xff3C6255)),
                ),
                onTap: () {
                  _changeLanguage(language);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              '🥺',
              style: TextStyle(fontSize: 50),
            ),
          ),
          content: Row(
            children: [
              SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.translate('areYouSureToExit'),
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
                    AppLocalizations.of(context)!.translate('yes'),
                    style: TextStyle(color: Color(0xff3C6255), fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    _logout(); // Call the logout function
                  },
                ),
                SizedBox(width: 25),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.translate('no'),
                    style: TextStyle(color: Color(0xff3C6255), fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _saveDarkModePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage(String message) async {
    setState(() {
      _isLoading = true;
      _messages.add({"role": "user", "content": message});
    });

    const apiKey = 'YOUR_OPENAI_API_KEY'; // استبدل بمفتاح API الخاص بك
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final botMessage = data['choices'][0]['message']['content'];

      setState(() {
        _messages.add({"role": "bot", "content": botMessage});
        _isLoading = false;
      });
    } else {
      setState(() {
        _messages
            .add({"role": "bot", "content": "حدث خطأ أثناء الاتصال بالخادم."});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Bot Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message['role'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message['role'] == 'user'
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['content']!,
                        style: TextStyle(
                            color: message['role'] == 'user'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter your message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _controller.text;
                    if (message.isNotEmpty) {
                      _controller.clear();
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;

  const PdfViewerScreen({super.key, required this.pdfPath});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final asset = await DefaultAssetBundle.of(context).load(widget.pdfPath);
    final bytes = asset.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp.pdf');
    await tempFile.writeAsBytes(bytes);

    setState(() {
      localPath = tempFile.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض PDF'),
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onRender: (pages) {},
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {},
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
