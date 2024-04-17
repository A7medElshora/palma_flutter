import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:p_p/main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();
  List<bool> _isLiked = [false, false, false]; // Track liked state for each post
  List<bool> _isCommenting = [false, false, false];

  @override
  Widget build(BuildContext context) {
    List<String> sliderImages = [
      'assets/images/2.png',
      'assets/images/3.png',
      'assets/images/4.png',
      'assets/images/8.png',
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "Let's make your \nworld greener.",
                style: TextStyle(
                  color: Color(0xff3C6255),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            CarouselSlider(
              items: sliderImages.map((item) {
                return Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      item,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 170.0,
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              carouselController: _controller,
            ),
            SizedBox(height: 20),
            DotsIndicator(
              dotsCount: sliderImages.length,
              position: _currentIndex.toDouble().toInt(),
              decorator: DotsDecorator(
                color: Colors.grey,
                activeColor: Color(0xff32B768),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 20, 3, 0),
                  child: Text(
                    "Let's discover More About Palm",
                    style: TextStyle(
                        color: Color(0xff3C6255),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  //Palm Cards
                  _buildCard(
                    context,
                    'assets/images/Siwa.png',
                    'Siwa Oasis palm trees',
                    'Siwa Oasis in Egypt is considered one of the main oases in the Western Desert,\n and is characterized by great importance for the environment, economy and culture of Egypt,\n Agriculture and agricultural \nproduction: Siwa Oasis is considered an important source of tropical agricultural \nproduction such as dates, various fruits and vegetables, \nthanks to the traditional irrigation system and its benefit from deep underground water.',
                    'assets/images/profile1.png', // Added profile image for each post
                    0, // Added index to track liked state individually
                  ),
                  _buildCard(
                    context,
                    'assets/images/SaPalms.PNG',
                    'AlUla Oasis',
                    'AlUla\'s 2.3 million palm trees produce more than 90,000 tons of dates\nOne of the most favorite types, this type of dates is characterized by its light Turkish color,\n and it also contains many benefits for the human body, \nto be able to provide the person with what is necessary and also contributes to the treatment of some diseases such as abdominal tumors.\n',
                    'assets/images/profile2.png', // Added profile image for each post
                    1, // Added index to track liked state individually
                  ),
                  _buildCard(
                    context,
                    'assets/images/Sapalms2.png',
                    '    Toshka',
                    'An official report by the Ministry of Agriculture and Land Reclamation stated that the date palm farm in Toshka, Aswan Governorate,\n is the largest palm farm planted in a single area in the world,\n which made it entered the Guinness Book of World Records.\n'
                        'It enjoys a global reputation thanks to the quality and diversity of its products.\n Toshka Farm is located in an area with an ideal tropical climate in the depths of the desert,\n which provides ideal conditions for planting and growing dates in large quantities and high quality.',
                    'assets/images/profile3.png', // Added profile image for each post
                    2, // Added index to track liked state individually
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Text(
            //   "Facebook Posts",
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            SizedBox(height: 10),
            // Display Facebook Posts
            Column(
              children: [
                _buildFacebookPost(
                  'AbdelFattah Elsisi',
                  'assets/images/7.png',
                  'I faced this problem in one of my existing Palm trees \n what is this problem abd what its treatment? ',
                  0, // Added index to track liked state individually
                  'assets/images/person1.png', // Different profile picture
                ),
                _buildFacebookPost(
                  'Mark ',
                  null, // No image
                  ' what are the best types of palm seedlings that can be growen in Egypt !!? ',
                  1, // Added index to track liked state individually
                  'assets/images/person3.png', // Different profile picture
                ),
                _buildFacebookPost(
                  'Elon Musk',
                  'assets/images/2.png',
                  ' I think my palm tree is enfected with some disease , but idon\'t know what it is ?? ',
                  2, // Added index to track liked state individually
                  'assets/images/ilonMusk.png', // Different profile picture
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Cards
  Widget _buildCard(BuildContext context, String imagePath, String title,
      String detail, String profileImage, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
                imagePath: imagePath, title: title, detail: detail),
          ),
        );
      },
      child: Container(
        width: 300,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: '${imagePath}_unique_tag',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff3C6255)),
            ),
          ],
        ),
      ),
    );
  }

  //Posts
  Widget _buildFacebookPost(
      String name, String? imagePath, String text, int index, String profileImage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                      profileImage,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (imagePath != null)
                Image.asset(
                  imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked[index] ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked[index] ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        _isLiked[index] = !_isLiked[index];
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      setState(() {
                        _isCommenting[index] = !_isCommenting[index];
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      // Add functionality for share button
                    },
                  ),
                ],
              ),
              if (_isCommenting[index])
                //Write a comment
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//Details Page
class DetailPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String detail;

  const DetailPage(
      {Key? key,
        required this.imagePath,
        required this.title,
        required this.detail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Detail Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: imagePath,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff3C6255)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    detail,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff70B6A7F),
                        height: 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
