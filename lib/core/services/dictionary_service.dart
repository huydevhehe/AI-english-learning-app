import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class DictionaryService {
  final _db = FirebaseFirestore.instance;

  static const _apiUrl =
      'https://api.mymemory.translated.net/get';

  Future<String> translateWord(String rawWord) async {
    final word = _normalize(rawWord);
    if (word.isEmpty) return "Không có nghĩa";

    // 1️⃣ Check cache Firestore
    final doc = await _db.collection('dictionary').doc(word).get();
    if (doc.exists && doc.data()?['meaning'] != null) {
      return doc['meaning'];
    }

    // 2️⃣ Gọi API
    final translated = await _translateFromApi(word);

    if (translated == null || translated.isEmpty) {
      return "Không dịch được";
    }

    // 3️⃣ Lưu cache
    await _db.collection('dictionary').doc(word).set({
      'meaning': translated,
      'from': 'en',
      'to': 'vi',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return translated;
  }

  /// Chuẩn hóa từ
  String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r"[^\w]"), "")
        .trim();
  }

  /// Gọi MyMemory + decode UTF8 chuẩn
  Future<String?> _translateFromApi(String word) async {
    try {
      final uri = Uri.parse(
        '$_apiUrl?q=$word&langpair=en|vi',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded =
            jsonDecode(utf8.decode(response.bodyBytes));

        return decoded['responseData']?['translatedText'];
      }
    } catch (e) {
      print('Translate error: $e');
    }
    return null;
  }
}
