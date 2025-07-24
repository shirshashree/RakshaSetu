import 'package:flutter/material.dart';
import '../models/scanned_message.dart';

class MessageCard extends StatelessWidget {
  final ScannedMessage message;

  MessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: message.isSpam ? Colors.red[100] : Colors.green[100],
      child: ListTile(
        title: Text(message.address),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.body),
            SizedBox(height: 4),
            Text(
              message.date.toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Icon(
          message.isSpam ? Icons.warning : Icons.check_circle,
          color: message.isSpam ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}
