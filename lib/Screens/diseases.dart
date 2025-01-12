import 'package:flutter/material.dart';
import 'package:p_p/localization.dart'; // استيراد AppLocalizations

class DiseaseListPage extends StatelessWidget {
  final List<Map<String, String>> diseases = [
    {
      "key": "brown", 
      "imageUrl": "assets/images/brownscal.jpeg",
    },
    {
      "key": "white", 
      "imageUrl": "assets/images/WhiteScale.png",
    },
  ];

  DiseaseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate("info"),  
          style: TextStyle(
              color: Theme.of(context).appBarTheme.titleTextStyle?.color,   
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,   
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          final diseaseKey = diseases[index]["key"]!;
          final imageUrl = diseases[index]["imageUrl"]!;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                AppLocalizations.of(context)!.translate("${diseaseKey}Name"), 
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,   
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9CCCA7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiseaseDetailsPage(
                        diseaseKey: diseaseKey,
                        imageUrl: imageUrl,
                      ),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.translate("view"),  
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DiseaseDetailsPage extends StatelessWidget {
  final String diseaseKey;
  final String imageUrl;

  const DiseaseDetailsPage({super.key, required this.diseaseKey, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate("diseaseDetails"),
          style: TextStyle(
              color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imageUrl,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.translate("Name"),
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.translate("${diseaseKey}Name"),
                style: TextStyle(color: Colors.blueGrey, fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.translate("causeOfDisease"),
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.translate("${diseaseKey}Desc"),
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.translate("treatment"),
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.translate("${diseaseKey}Treatment"),
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



