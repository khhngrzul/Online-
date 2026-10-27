
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

const String apiBaseUrl = 'http://127.0.0.1:8000';

class PostApi {
  // Зураг болон зарын мэдээллийг нэг хүсэлтээр илгээнэ.
  static Future<Map<String, dynamic>> createPost({
    required String postType,
    required String title,
    required String category,
    required String audience,
    required String content,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiBaseUrl/api/posts/'),
    );

    request.fields['post_type'] = postType;
    request.fields['title'] = title;
    request.fields['category'] = category;
    request.fields['audience'] = audience;
    request.fields['content'] = content;

    if (imageBytes != null && imageBytes.isNotEmpty) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName ?? 'post_image.jpg',
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final dynamic decoded = jsonDecode(
      utf8.decode(response.bodyBytes),
    );

    if (response.statusCode != 201) {
      final error = decoded is Map
          ? decoded['error'] ?? decoded['detail'] ?? decoded.toString()
          : decoded.toString();

      throw Exception('Зар бүртгэхэд алдаа гарлаа: $error');
    }

    return Map<String, dynamic>.from(decoded as Map);
  }

  // Бүртгэгдсэн заруудыг авна.
  static Future<List<dynamic>> getPosts() async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/api/posts/'),
    );

    if (response.statusCode != 200) {
      throw Exception('Заруудыг авахад алдаа гарлаа.');
    }

    return jsonDecode(
      utf8.decode(response.bodyBytes),
    ) as List<dynamic>;
  }
}
