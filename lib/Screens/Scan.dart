import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:p_p/localization.dart'; // استيراد AppLocalizations
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p_p/Screens/history_page.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'diseases.dart'; // استيراد صفحة الأمراض

class ImageClassifierPage extends StatefulWidget {
  const ImageClassifierPage({super.key});

  @override
  _ImageClassifierPageState createState() => _ImageClassifierPageState();
}

class _ImageClassifierPageState extends State<ImageClassifierPage> {
  File? _image;
  List? _output;
  bool _loading = false;
  List<HistoryEntry> history = [];

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF9CCCA7),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: IconButton(
                icon: Icon(Icons.history),
                color: Colors.black45,
                onPressed: navigateToHistoryPage,
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xff3C6255), // لون مؤشر التحميل
              ),
            )
          : Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  _image == null
                      ? Center(
                          child: Lottie.asset(
                            'assets/images/scan.json',
                            width: 200,
                            height: 200,
                          ),
                        )
                      : Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _output?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                // color: Color.fromARGB(255, 241, 215, 136),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                '        ${_translateOutput(_output![index]["label"])}',
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18, // حجم الخط
                                  fontFamily: 'Roboto', // نوع الخط
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30), // إضافة مسافة بين النتيجة والأزرار
                  // عرض الأزرار بناءً على النتيجة
                  if (_output != null && _output!.isNotEmpty)
                    _buildDiseaseButtons(_output![0]["label"]),
                  SizedBox(height: 20), // إضافة مسافة بين الأزرار
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 2,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () => _getImage(ImageSource.camera),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF9CCCA7),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _getImage(ImageSource.gallery),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF9CCCA7),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // دالة لترجمة النتائج
  String _translateOutput(String label) {
    if (label.contains("Brown Spots")) {
      return AppLocalizations.of(context)!.translate("brownSpots");
    } else if (label.contains("White Scale")) {
      return AppLocalizations.of(context)!.translate("whiteScale");
    } else if (label.contains("free of diseases")) {
      return AppLocalizations.of(context)!.translate("freeOfDiseases");
    }
    return label; // إذا لم يتم العثور على ترجمة، يتم إرجاع النص الأصلي
  }

  // دالة لبناء الأزرار بناءً على النتيجة
  Widget _buildDiseaseButtons(String label) {
    if (label.contains("Brown Spots")) {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiseaseDetailsPage(
                diseaseKey: "brown",
                imageUrl: "assets/images/brownscal.jpeg",
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff3C6255),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Text(
          AppLocalizations.of(context)!.translate("viewBrownSpots"),
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      );
    } else if (label.contains("White Scale")) {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiseaseDetailsPage(
                diseaseKey: "white",
                imageUrl: "assets/images/WhiteScale.png",
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff3C6255),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Text(
          AppLocalizations.of(context)!.translate("viewWhiteScale"),
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return SizedBox(); // لا تظهر أي أزرار إذا كانت النخلة خالية من الأمراض
    }
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/Models/model_unquant.tflite",
      labels: "assets/Models/labels.txt",
    );
  }

  Future<void> _getImage(ImageSource source) async {
    await _requestPermissions(); // طلب الأذونات
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      classifyImage();
    }
  }

  void classifyImage() async {
    if (_image == null) return;

    setState(() {
      _loading = true;
    });

    var output = await Tflite.runModelOnImage(
      path: _image!.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _loading = false;
      _output = output;
    });

    addToHistory(_image!, _output![0]['label']);
  }

  void addToHistory(File image, String label) async {
    setState(() {
      history.add(HistoryEntry(image: image, label: label));
    });
    saveHistory();
  }

  void saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyStrings =
        history.map((entry) => "${entry.image.path},${entry.label}").toList();
    await prefs.setStringList('history', historyStrings);
  }

  void loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? historyStrings = prefs.getStringList('history');
    if (historyStrings != null) {
      setState(() {
        history = historyStrings.map((str) {
          final parts = str.split(',');
          return HistoryEntry(image: File(parts[0]), label: parts[1]);
        }).toList();
      });
    }
  }

  void navigateToHistoryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(history: history),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    if (await Permission.camera.request().isGranted &&
        await Permission.storage.request().isGranted) {
      // الأذونات ممنوحة، يمكنك فتح الكاميرا أو المعرض
    } else {
      // الأذونات غير ممنوحة، قم بإعلام المستخدم
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.translate("permissionRequired"))),
      );
    }
  }
}
