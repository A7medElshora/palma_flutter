import 'dart:io';

import 'package:flutter/material.dart';

// Define a class to represent a single history entry
class HistoryEntry {
  final File image;
  final String label;

  HistoryEntry({required this.image, required this.label});
}

// Define a HistoryPage widget to display the history
class HistoryPage extends StatelessWidget {
  final List<HistoryEntry> history;

  const HistoryPage({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.file(
              history[index].image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(history[index].label),
          );
        },
      ),
    );
  }
}
