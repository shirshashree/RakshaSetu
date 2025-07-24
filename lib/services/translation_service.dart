import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _url =
      'https://libretranslate.de/translate'; // Public instance

  /// Translates given text to English using LibreTranslate
  static Future<String> translateToEnglish(
    String text, {
    String from = 'auto',
  }) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'q': text,
        'source': from,
        'target': 'en',
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['translatedText'];
    } else {
      print("Translation failed: ${response.body}");
      return text; // fallback
    }
  }
}
