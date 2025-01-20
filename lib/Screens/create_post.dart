import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p_p/localization.dart'; // استيراد AppLocalizations

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postController = TextEditingController();
  File? _image; 
  String? _location; 
  String? _feeling; 
  List<String> _taggedFriends = []; 
  String? _userName; 
  File? _userImage; 

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('fullName'); 
      String? imagePath = prefs.getString('imagePath'); 
      if (imagePath != null && File(imagePath).existsSync()) {
        _userImage = File(imagePath); 
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("addLocation")),  
          content: TextField(
            onChanged: (value) {
              _location = value;
            },
            decoration: InputDecoration(hintText: AppLocalizations.of(context)!.translate("enterLocation")),  
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.translate("cancel")),  
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {});
              },
              child: Text(AppLocalizations.of(context)!.translate("save")),  
            ),
          ],
        );
      },
    );
  }

  void _showFeelingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("addFeeling")),  
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.translate("happy")),  
                onTap: () {
                  _feeling = AppLocalizations.of(context)!.translate("happy");
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.translate("sad")),  
                onTap: () {
                  _feeling = AppLocalizations.of(context)!.translate("sad");
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.translate("optimistic")),  
                onTap: () {
                  _feeling = AppLocalizations.of(context)!.translate("optimistic");
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTagFriendsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("tagFriends")),  
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _taggedFriends.add(value);
                  }
                },
                decoration: InputDecoration(hintText: AppLocalizations.of(context)!.translate("enterFriendName")),  
              ),
              SizedBox(height: 10),
              Wrap(
                children: _taggedFriends
                    .map((friend) => Chip(
                          label: Text(friend),
                          onDeleted: () {
                            setState(() {
                              _taggedFriends.remove(friend);
                            });
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.translate("done")),  
            ),
          ],
        );
      },
    );
  }

  void _savePost() async {
    if (_postController.text.isEmpty && _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate("postCannotBeEmpty"))),  
      );
      return;
    }

    final postData = {
      "text": _postController.text,
      "image": _image?.path,
      "location": _location,
      "feeling": _feeling,
      "taggedFriends": _taggedFriends.join(", "),
      "userName": _userName, 
      "userImage": _userImage?.path, 
    };

    Navigator.pop(context, postData); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate("createNewPost")),  
        backgroundColor: Color(0xff3C6255),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            
            if (_userName != null || _userImage != null)
              Row(
                children: [
                  if (_userImage != null)
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: FileImage(_userImage!),
                    ),
                  SizedBox(width: 10),
                  if (_userName != null)
                    Text(
                      _userName!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            SizedBox(height: 20),
            TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.translate("whatsOnYourMind"),  
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.photo_library, color: Color(0xff3C6255)),
                  onPressed: _pickImage,
                  tooltip: AppLocalizations.of(context)!.translate("addImage"),  
                ),
                IconButton(
                  icon: Icon(Icons.location_on, color: Color(0xff3C6255)),
                  onPressed: _showLocationDialog,
                  tooltip: AppLocalizations.of(context)!.translate("addLocation"),  
                ),
                IconButton(
                  icon: Icon(Icons.emoji_emotions, color: Color(0xff3C6255)),
                  onPressed: _showFeelingDialog,
                  tooltip: AppLocalizations.of(context)!.translate("addFeeling"),  
                ),
                IconButton(
                  icon: Icon(Icons.person_add, color: Color(0xff3C6255)),
                  onPressed: _showTagFriendsDialog,
                  tooltip: AppLocalizations.of(context)!.translate("tagFriends"),  
                ),
              ],
            ),
            if (_location != null || _feeling != null || _taggedFriends.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_location != null)
                      Text("${AppLocalizations.of(context)!.translate("location")}: $_location", style: TextStyle(color: Colors.grey[700])),
                    if (_feeling != null)
                      Text("${AppLocalizations.of(context)!.translate("feeling")}: $_feeling", style: TextStyle(color: Colors.grey[700])),
                    if (_taggedFriends.isNotEmpty)
                      Text("${AppLocalizations.of(context)!.translate("taggedFriends")}: ${_taggedFriends.join(", ")}", style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePost,
              child: Text(AppLocalizations.of(context)!.translate("post")),  
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff3C6255),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}