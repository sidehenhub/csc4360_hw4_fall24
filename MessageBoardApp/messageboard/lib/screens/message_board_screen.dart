import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MessageBoardScreen extends StatelessWidget {
  final List<Map<String, String>> boards = [
    {'name': 'Study', 'image': 'assets/img1_study.png'},
    {'name': 'Sports', 'image': 'assets/img2_sports.png'},
    {'name': 'Travel', 'image': 'assets/img3_travel.png'},
    {'name': 'Music', 'image': 'assets/img4_music.png'},
  ];

  Widget _buildMessageBoardItem(String name, String imagePath, bool isIconOnLeft) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (isIconOnLeft) ...[
            Image.asset(imagePath, width: 80, height: 80),
            SizedBox(width: 16),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ] else ...[
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 16),
            Image.asset(imagePath, width: 80, height: 80),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Message Boards")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text('Menu')),
            ListTile(
              title: Text('Message Boards'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MessageBoardScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()), 
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()), 
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(boardName: boards[index]['name']!),
                ),
              );
            },
            child: _buildMessageBoardItem(
              boards[index]['name']!,
              boards[index]['image']!,
              index % 2 == 0, 
            ),
          );
        },
      ),
    );
  }
}
