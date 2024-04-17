import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:p_p/Screens/history_page.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ImageClassifierPage extends StatefulWidget {
  @override
  _ImageClassifierPageState createState() => _ImageClassifierPageState();
}

class _ImageClassifierPageState extends State<ImageClassifierPage> {
  File? _image;
  List? _output;
  bool _loading = false;
  List<HistoryEntry> history = []; // Store history entries

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
    // Load history from shared preferences when the page initializes
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Image Classifier'),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF9CCCA7), // Set background color to red
              borderRadius: BorderRadius.circular(20.0), // Set border radius
            ),
            child: IconButton(
              icon: Icon(Icons.history),
              color: Colors.black45, // Set the icon color to white
              onPressed: navigateToHistoryPage,
            ),
          ),

        ],
      ),
      body: _loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            _image == null
                ? Center(
              child: Lottie.asset('assets/images/scan.json'),
            )
                : Expanded(
              child: Image.file(_image!),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _output?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Container(
                      height: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFD2A92D),
                        borderRadius: BorderRadius.circular(
                            15), // Adjust the radius value as per your preference
                      ),
                      child: Text(
                        '        ${_output![index]["label"]}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),

            ///GridView
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

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/Models/model_unquant.tflite",
      labels: "assets/Models/labels.txt",
    );
  }

  Future<void> _getImage(ImageSource source) async {
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

    // Add the classified image to history
    addToHistory(_image!, _output![0]['label']);
  }

  void addToHistory(File image, String label) async {
    // Add the entry to history list
    setState(() {
      history.add(HistoryEntry(image: image, label: label));
    });

    // Save history to shared preferences
    saveHistory();
  }

  void saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyStrings = history.map((entry) => "${entry.image.path},${entry.label}").toList();
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
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:tflite_v2/tflite_v2.dart';

// class ImageClassifierPage extends StatefulWidget {
//   @override
//   _ImageClassifierPageState createState() => _ImageClassifierPageState();
// }

// class _ImageClassifierPageState extends State<ImageClassifierPage> {
//   File? _image;
//   List? _output;
//   bool _loading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loading = true;
//     loadModel().then((value) {
//       setState(() {
//         _loading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _loading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Container(
//               padding: EdgeInsets.all(15.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 100,
//                   ),
//                   _image == null
//                       ? Center(
//                           child: Lottie.asset('assets/images/scan.json'),
//                         )
//                       : Expanded(
//                           child: Image.file(_image!),
//                         ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: _output?.length ?? 0,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Container(
//                             height: 100,
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Color(0xFFD2A92D),
//                               borderRadius: BorderRadius.circular(
//                                   15), // Adjust the radius value as per your preference
//                             ),
//                             child: Text(
//                               '        ${_output![index]["label"]}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 10),

//                   ///GridView
//                   GridView.count(
//                     crossAxisCount: 2,
//                     shrinkWrap: true,
//                     childAspectRatio: 2,
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 10,
//                     children: [
//                       GestureDetector(
//                         onTap: () => _getImage(ImageSource.camera),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Color(0xFF9CCCA7),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Icon(
//                             Icons.camera_alt,
//                             color: Colors.white,
//                             size: 50,
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => _getImage(ImageSource.gallery),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Color(0xFF9CCCA7),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Icon(
//                             Icons.photo_library,
//                             color: Colors.white,
//                             size: 50,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(
//                     height: 15,
//                   ),

//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//     );
//   }

//   Future<void> loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/Models/model_unquant.tflite",
//       labels: "assets/Models/labels.txt",
//     );
//   }

//   Future<void> _getImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//       classifyImage();
//     }
//   }

//   void classifyImage() async {
//     if (_image == null) return;

//     setState(() {
//       _loading = true;
//     });

//     var output = await Tflite.runModelOnImage(
//       path: _image!.path,
//       numResults: 6,
//       threshold: 0.05,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );

//     setState(() {
//       _loading = false;
//       _output = output;
//     });
//   }

//   @override
//   void dispose() {
//     Tflite.close();
//     super.dispose();
//   }
// }
