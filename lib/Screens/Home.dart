import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:p_p/Screens/create_post.dart';
import 'package:p_p/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  List<bool> _isLiked = [];
  List<bool> _isCommenting = [];
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? postsString = prefs.getStringList('posts');
    if (postsString != null) {
      setState(() {
        posts = postsString.map((post) => Map<String, dynamic>.from(json.decode(post))).toList();
        // Initialize _isLiked and _isCommenting lists based on the number of posts
        _isLiked = List<bool>.filled(posts.length, false);
        _isCommenting = List<bool>.filled(posts.length, false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> sliderImages = [
      'assets/images/2.png',
      'assets/images/3.png',
      'assets/images/4.png',
      'assets/images/8.png',
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPost = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostPage(),
            ),
          );
          if (newPost != null) {
            setState(() {
              posts.insert(0, newPost); // Add the new post to the beginning of the list
              _isLiked.insert(0, false); // Initialize the like state for the new post
              _isCommenting.insert(0, false); // Initialize the comment state for the new post
            });
            final prefs = await SharedPreferences.getInstance();
            await prefs.setStringList('posts', posts.map((post) => json.encode(post)).toList());
          }
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xff3C6255),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                AppLocalizations.of(context)!.translate("header"),
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
                  margin: EdgeInsets.symmetric(horizontal: 5),
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
              position: _currentIndex.toInt(),
              decorator: DotsDecorator(
                color: Colors.grey,
                activeColor: Color(0xff32B768),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate("discover"),
                    style: TextStyle(
                      color: Color(0xff3C6255),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCard(
                    context,
                    'assets/images/Siwa.png',
                    AppLocalizations.of(context)!.translate("siwaName"),
                    AppLocalizations.of(context)!.translate("siwaDiscription"),
                    'assets/images/profile1.png',
                    0,
                  ),
                  _buildCard(
                    context,
                    'assets/images/SaPalms.PNG',
                    AppLocalizations.of(context)!.translate("alulaName"),
                    AppLocalizations.of(context)!.translate("alulaDiscription"),
                    'assets/images/profile2.png',
                    1,
                  ),
                  _buildCard(
                    context,
                    'assets/images/Sapalms2.png',
                    AppLocalizations.of(context)!.translate("toshkaName"),
                    AppLocalizations.of(context)!.translate("toshkaDiscription"),
                    'assets/images/profile3.png',
                    2,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  for (int i = 0; i < posts.length; i++)
                    _buildFacebookPost(
                      posts[i]["userName"] ?? "مستخدم جديد",
                      posts[i]["image"],
                      posts[i]["text"],
                      i,
                      posts[i]["userImage"] ?? 'assets/images/person00.png',
                      posts[i],
                    ),
                  _buildFacebookPost(
                    'عبد الفتاح السيسي',
                    'assets/images/7.png',
                    AppLocalizations.of(context)!.translate("post1"),
                    0,
                    'assets/images/person1.png',
                    null,
                  ),
                  _buildFacebookPost(
                    'مارك',
                    null,
                    AppLocalizations.of(context)!.translate("post2"),
                    1,
                    'assets/images/person3.png',
                    null,
                  ),
                  _buildFacebookPost(
                    'إيلون ماسك',
                    'assets/images/2.png',
                    AppLocalizations.of(context)!.translate("post3"),
                    2,
                    'assets/images/ilonMusk.png',
                    null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String imagePath, String title,
      String detail, String profileImage, int index) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(imagePath: imagePath, title: title, detail: detail),
          ),
        );
      },
      child: Container(
        width: 300,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(isDarkMode ? 0.1 : 0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: isDarkMode ? Colors.white : Color(0xff3C6255),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    detail,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacebookPost(String name, String? imagePath, String text,
      int index, String profileImage, Map<String, dynamic>? postData) {
    // التحقق من صحة الفهرس قبل الوصول إلى القوائم
    if (index < 0 || index >= _isLiked.length || index >= _isCommenting.length) {
      return SizedBox(); // تجنب الخطأ عن طريق إرجاع ويدجت فارغة إذا كان الفهرس غير صالح
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: profileImage.startsWith('assets/')
                      ? AssetImage(profileImage) as ImageProvider
                      : FileImage(File(profileImage)),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imagePath.startsWith('assets/')
                    ? Image.asset(
                        imagePath,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(imagePath),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            if (postData != null && (postData["location"] != null || postData["feeling"] != null || postData["taggedFriends"] != null))
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (postData["location"] != null)
                      Text("الموقع: ${postData["location"]}", style: TextStyle(color: Colors.grey[700])),
                    if (postData["feeling"] != null)
                      Text("الشعور: ${postData["feeling"]}", style: TextStyle(color: Colors.grey[700])),
                    if (postData["taggedFriends"] != null)
                      Text("الأصدقاء المميزون: ${postData["taggedFriends"]}", style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    _isLiked[index] ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked[index] ? Colors.red : Color(0xff3C6255),
                  ),
                  onPressed: () {
                    setState(() {
                      _isLiked[index] = !_isLiked[index];
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment, color: Color(0xff3C6255)),
                  onPressed: () {
                    setState(() {
                      _isCommenting[index] = !_isCommenting[index];
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Color(0xff3C6255)),
                  onPressed: () {
                    // Add functionality for share button
                  },
                ),
              ],
            ),
            if (_isCommenting[index])
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'اكتب تعليق...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String detail;

  const DetailPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      color: Color(0xff3C6255),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    detail,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff70b6a7f),
                      height: 2,
                    ),
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