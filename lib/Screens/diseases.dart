import 'package:flutter/material.dart';

class Disease {
  final String name;
  final String description;
  final String imageUrl;
  final String treatment;

  Disease(
      {required this.name,
      required this.description,
      required this.imageUrl,
      required this.treatment});
}

class DiseaseListPage extends StatelessWidget {
  final List<Disease> diseases = [
    Disease(
      name: 'Brown Scale ',

      description:
          'Brown spots in palm trees is a common problem that affects the health and beauty of these plants.\n The cause of the brown spots can be a bacterial or fungal infection,\n or a nutritional deficiency, or an insect attack, or unsuitable environmental conditions. \nThe cause can be identified by examining the symptoms and the cultivation history of the palms.\n Some causes can be treated by using biological or chemical pe',
      imageUrl: 'assets/images/brownscal.jpeg',

      treatment: '- If the cause of the brown spots is a bacterial or fungal infection, '
          '\nbiological or chemical pesticides can be used to eliminate the infection.'
          '\n- If the cause of the brown spots is a lack of nutrition, \na special palm fertilizer can be used that contains the necessary nutrients.'
          '\nIf the brown spots are caused by an insect attack, an insecticide specifically designed for the type of insect causing the problem can be used.\n',
    ),
    Disease(
      name: 'White Spots',
      description:
'White scale on palms is typically caused by infestations of scale insects, \nwhich appear as small, \nwhite or grayish bumps on the leaves and stems.\n These pests suck sap from the plant, weakening it over time.',

      imageUrl: 'assets/images/WhiteScale.png',

      treatment: 'This disease can be treated by regular inspection and treatment with horticultural oil \n or insecticidal soap\n  can help control the infestation.\n',
    ),
    // Add more diseases as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          ' Palm Disease ',
          style:
              TextStyle(color: Color(0xff3C6255), fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 30),
            child: ListTile(
              leading: Image.asset(
                diseases[index].imageUrl,
                width: 50,
                height: 50,
              ),
              title: Text(diseases[index].name),
              // subtitle: Text(diseases[index].description),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiseaseDetailsPage(
                        disease: diseases[index],
                      ),
                    ),
                  );
                },
                child: Text(
                  'View',
                  style: TextStyle(color: Color(0xFF3C6255)),
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
  final Disease disease;

  DiseaseDetailsPage({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Disease Details',
          style:
              TextStyle(color: Color(0xff3C6255), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                disease.imageUrl,
                width: 300,
                height: 300,
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Name:  ',
                  style: TextStyle(
                      color: Color(0xff3C6255),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${disease.name}',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
              // Text(
              //   'Name: ${disease.name}',
              //   style: TextStyle(fontSize: 18,color: Color(0xff3C6255),fontWeight: FontWeight.bold),
              // ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(left: 7, bottom: 10),
                child: RichText(
                  text: TextSpan(
                    text: 'Cause of Disease: \n',
                    style: TextStyle(fontSize: 18, color: Color(0xff3C6255),height: 1.5),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${disease.description}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(margin: EdgeInsets.only(left: 7),
                child: RichText(
                  text: TextSpan(
                    text: 'Treatment\n ',
                    style: TextStyle(fontSize: 18, color: Color(0xff3C6255),height: 1.5),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${disease.treatment}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
