import 'package:flutter/material.dart';

class CustomAvatarWidget extends StatelessWidget {
  final String imageUrl;
  final Color backgroundColor;
  final Color borderColor;
  final String name;
  const CustomAvatarWidget({
    required this.backgroundColor,
    required this.borderColor,
    required this.imageUrl,
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1.25),
            borderRadius: BorderRadius.circular(100),
          ),
          child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        ),
        Text(name, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
