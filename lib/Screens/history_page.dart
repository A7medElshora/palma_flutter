import 'dart:io';
import 'package:flutter/material.dart';
import 'package:p_p/Screens/diseases.dart';

class HistoryEntry {
  final File image;
  final String label;

  HistoryEntry({required this.image, required this.label});
}

class HistoryPage extends StatelessWidget {
  final List<HistoryEntry> history;

  const HistoryPage({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Color(0xff3C6255),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryDetailPage(
                    image: history[index].image,
                    label: history[index].label,
                  ),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    history[index].image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  history[index].label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3C6255),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff3C6255),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}





class HistoryDetailPage extends StatelessWidget {
  final File image;
  final String label;

  const HistoryDetailPage({Key? key, required this.image, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Details'),
        backgroundColor: Color(0xff3C6255),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.file(
                image,
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Label: $label',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff3C6255),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Based on the scan, here are possible diseases:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            // عرض الأزرار بناءً على التسمية
            _buildDiseaseButtons(context, label),
            SizedBox(height: 20),
            Text(
              'Note: This is a preliminary diagnosis. Please consult a specialist for accurate results.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // دالة لبناء الأزرار بناءً على التسمية
  Widget _buildDiseaseButtons(BuildContext context, String label) {
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
        ),
        child: Text(
          'View Brown Spots Disease',
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
        ),
        child: Text(
          'View White Scale Disease',
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
}
