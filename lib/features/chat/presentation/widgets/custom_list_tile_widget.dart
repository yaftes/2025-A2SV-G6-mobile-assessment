import 'package:flutter/material.dart';

class CustomListTileWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String lastMessage;
  final String lastSeen;
  final int? unReadMessage;
  final void Function() onTap;
  const CustomListTileWidget({
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.onTap,
    required this.lastSeen,
    this.unReadMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(name, style: TextStyle(fontSize: 16)),
      subtitle: Text(lastMessage, style: TextStyle(color: Colors.grey)),
      trailing: Column(
        children: [
          Text(lastSeen, style: TextStyle(color: Colors.grey)),
          if (unReadMessage != null)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  unReadMessage.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
