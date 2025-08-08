import 'package:flutter/material.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/presentation/widgets/custom_avatar_widget.dart';
import 'package:g6_assessment/features/chat/presentation/widgets/custom_list_tile_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: screenHeight / 3.5,
            decoration: BoxDecoration(color: Colors.blue),
            child: Row(
              children: [
                CustomAvatarWidget(
                  backgroundColor: Colors.amber,
                  borderColor: Colors.amber,
                  imageUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                  name: 'Yafet',
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(itemBuilder: (context, index) {}),
            ),
          ),
        ],
      ),
    );
  }
}
