import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../services/translation_service.dart';
// import '../services/secure_mode_manager.dart';

class MessageScannerScreen extends StatefulWidget {
  const MessageScannerScreen({super.key});

  @override
  _MessageScannerScreenState createState() => _MessageScannerScreenState();
}

class _MessageScannerScreenState extends State<MessageScannerScreen> {
  List<SmsMessage> _messages = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    fetchSms();
  }

  Future<void> fetchSms() async {
    setState(() {
      _loading = true;
    });

    var status = await Permission.sms.status;
    if (!status.isGranted) {
      status = await Permission.sms.request();
    }

    if (status.isGranted) {
      SmsQuery query = SmsQuery();
      List<SmsMessage> all = await query.getAllSms;
      setState(() {
        _messages = all.reversed.take(50).toList(); // latest 50
        _loading = false;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("SMS permission denied")));
      setState(() => _loading = false);
    }
  }

  Future<void> processMessage(SmsMessage message) async {
    final rawText = message.body ?? "";
    final translated = await TranslationService.translateToEnglish(rawText);

    if (isPhishing(translated)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("⚠️ Phishing Detected"),
          content: Text(translated),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("✅ Safe Message"),
          content: Text(translated),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  bool isPhishing(String text) {
    final lower = text.toLowerCase();

    final patterns = [
      RegExp(r"account.*(blocked|closed)"),
      RegExp(r"click.*link"),
      RegExp(r"urgent.*action"),
      RegExp(r"bank.*details"),
      RegExp(r"otp.*immediately"),
    ];

    return patterns.any((p) => p.hasMatch(lower));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📩 SMS Scanner"),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: fetchSms)],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ListTile(
                  title: Text(msg.sender ?? "Unknown"),
                  subtitle: Text(
                    msg.body ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => processMessage(msg),
                );
              },
            ),
    );
  }
}
