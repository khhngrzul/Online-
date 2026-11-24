import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );
  static const _timeout = Duration(seconds: 20);
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  String get _baseUrl {
    if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
  }

  Uri _endpoint(String path, [Map<String, String>? query]) {
    final base = _baseUrl.endsWith('/') ? _baseUrl : '$_baseUrl/';
    return Uri.parse(base).resolve('$path/').replace(queryParameters: query);
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response =
        await _client.get(_endpoint('categories')).timeout(_timeout);
    final data = _decodeResponse(response);
    if (data is! List) {
      throw const ApiException('Ангиллын өгөгдөл буруу форматтай байна.');
    }
    return data.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final response = await _client.get(_endpoint('items')).timeout(_timeout);
    final data = _decodeResponse(response);
    final results = data is List
        ? data
        : data is Map<String, dynamic>
            ? data['results']
            : null;
    if (results is! List) {
      throw const ApiException('Зарын өгөгдөл буруу форматтай байна.');
    }
    return results.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createItem({
    required String title,
    required String description,
    required String price,
    required String kind,
    required String ownerName,
    required int categoryId,
    required Uint8List image,
  }) async {
    final request = http.MultipartRequest('POST', _endpoint('items'));
    request.fields.addAll({
      'title': title,
      'description': description,
      'price': price,
      'kind': kind,
      'owner_name': ownerName,
      'category': '$categoryId',
      'location': '',
      'phone': '',
    });
    request.files.add(
      http.MultipartFile.fromBytes('image', image, filename: 'listing.jpg'),
    );

    final streamed = await _client.send(request).timeout(_timeout);
    final response = await http.Response.fromStream(streamed);
    final data = _decodeResponse(response);
    if (data is! Map<String, dynamic>) {
      throw const ApiException('Шинэ зарын хариу буруу форматтай байна.');
    }
    return data;
  }

  Future<void> deleteItem(int id) async {
    final response =
        await _client.delete(_endpoint('items/$id')).timeout(_timeout);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      _decodeResponse(response);
    }
  }

  dynamic _decodeResponse(http.Response response) {
    dynamic data;
    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(utf8.decode(response.bodyBytes));
      } on FormatException {
        data = response.body;
      }
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      if (data is Map<String, dynamic>) {
        final detail = data['detail'] ??
            data.entries
                .map((entry) => '${entry.key}: ${entry.value}')
                .join('\n');
        throw ApiException('API алдаа (${response.statusCode}): $detail');
      }
      throw ApiException('API алдаа (${response.statusCode}): $data');
    }
    return data;
  }
}
