import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

/// Django backend-тэй харилцах нэг газар.
class Api {
  static const String _configuredBase =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static String get base {
    if (_configuredBase.isNotEmpty) return _configuredBase;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8001';
    }
    return 'http://127.0.0.1:8001';
  }

  static String? access;
  static String? refresh;

  static Map<String, String> _headers({bool auth = true}) => {
        'Content-Type': 'application/json; charset=utf-8',
        if (auth && access != null) 'Authorization': 'Bearer $access',
      };

  static Future<bool> _refreshToken() async {
    if (refresh == null) return false;
    final res = await http.post(
      Uri.parse('$base/api/auth/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refresh}),
    );
    if (res.statusCode != 200) return false;
    final data = jsonDecode(res.body);
    access = data['access'] as String?;
    if (data['refresh'] != null) refresh = data['refresh'] as String;
    return access != null;
  }

  static Future<http.Response> _send(
      Future<http.Response> Function() call) async {
    var res = await call();
    if (res.statusCode == 401 && await _refreshToken()) {
      res = await call();
    }
    return res;
  }

  static Future<List<Map<String, dynamic>>> _getList(String path) async {
    final uri = Uri.parse('$base$path');
    var res = await _send(() => http.get(uri, headers: _headers()));
    if (res.statusCode == 401) {
      res = await http.get(uri, headers: _headers(auth: false));
    }
    if (res.statusCode != 200) {
      throw Exception('Алдаа (${res.statusCode})');
    }
    final data = jsonDecode(utf8.decode(res.bodyBytes));
    return (data is Map ? data['results'] as List : data as List)
        .cast<Map<String, dynamic>>();
  }

  static Future<Uint8List?> _download(dynamic url) async {
    if (url == null) return null;
    var u = '$url';
    if (u.isEmpty) return null;
    if (u.startsWith('/')) u = '$base$u';
    try {
      final r = await http.get(Uri.parse(u));
      if (r.statusCode == 200) return r.bodyBytes;
    } catch (_) {}
    return null;
  }

  static Future<Map<String, dynamic>> _postAction(String path,
      [Map<String, dynamic>? body]) async {
    final uri = Uri.parse('$base$path');
    final res = await _send(() => http.post(uri,
        headers: _headers(), body: body == null ? null : jsonEncode(body)));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(
          'Алдаа (${res.statusCode}): ${utf8.decode(res.bodyBytes)}');
    }
    return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  }

  static User _userFrom(String? name, String? code) =>
      User(name ?? 'Оюутан', code ?? '', '', '', 1);

  // ================= ЗАР =================
  static Future<List<Item>> fetchItems() async {
    final list = await _getList('/api/items/');
    final items = list.map(_itemFromJson).toList();
    final imgs = await Future.wait(list.map((j) => _download(j['image'])));
    for (var i = 0; i < items.length; i++) {
      items[i].img = imgs[i];
    }
    return items;
  }

  static Future<Item> createItem({
    required String title,
    String description = '',
    required String price,
    String location = '',
    String phone = '',
    required Kind kind,
    Uint8List? imageBytes,
  }) async {
    final fields = <String, String>{
      'title': title,
      'description': description,
      'price': _priceToNumber(price, kind),
      'location': location,
      'phone': phone,
      'kind': kind.name,
    };
    final uri = Uri.parse('$base/api/items/');

    Future<http.Response> once() async {
      final req = http.MultipartRequest('POST', uri)..fields.addAll(fields);
      if (access != null) req.headers['Authorization'] = 'Bearer $access';
      if (imageBytes != null) {
        req.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'photo.jpg',
        ));
      }
      return http.Response.fromStream(await req.send());
    }

    var res = await once();
    if (res.statusCode == 401 && await _refreshToken()) {
      res = await once();
    }
    if (res.statusCode != 201) {
      throw Exception('Зар нэмж чадсангүй: ${utf8.decode(res.bodyBytes)}');
    }
    return _itemFromJson(jsonDecode(utf8.decode(res.bodyBytes)));
  }

  static String _priceToNumber(String price, Kind kind) {
    if (kind != Kind.sell) return '0';
    final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? '0' : digits;
  }

  static String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  static Item _itemFromJson(Map<String, dynamic> j) {
    final kind = Kind.values.firstWhere(
      (k) => k.name == j['kind'],
      orElse: () => Kind.sell,
    );
    final p = double.tryParse('${j['price']}') ?? 0;
    final String price;
    if (kind == Kind.free) {
      price = 'Үнэгүй';
    } else if (kind == Kind.swap) {
      price = 'Солилцоно';
    } else {
      price = '${_fmt(p.round())}₮';
    }
    return Item(
      '${j['title'] ?? ''}',
      '${j['description'] ?? ''}',
      price,
      '📦',
      kind,
      _userFrom('${j['owner_name'] ?? 'Оюутан'}', '${j['owner_code'] ?? ''}'),
      null,
      ItemCategory.values.firstWhere(
        (category) => category.name == j['category']?.toString(),
        orElse: () => ItemCategory.electronics,
      ),
      (j['id'] as num?)?.toInt(),
    );
  }

  // ================= НИЙТЛЭЛ =================
  static void _applyPost(Post p, Map<String, dynamic> j) {
    p.likes
      ..clear()
      ..addAll(((j['like_codes'] as List?) ?? const [])
          .map((c) => _userFrom(null, '$c')));
    p.comments
      ..clear()
      ..addAll(((j['comments'] as List?) ?? const [])
          .map<(User, String)>((c) {
        final m = c as Map<String, dynamic>;
        return (
          _userFrom('${m['author_name']}', '${m['author_code']}'),
          '${m['text'] ?? ''}'
        );
      }));
  }

  static Post _postFromJson(Map<String, dynamic> j) {
    final p = Post(
      _userFrom('${j['author_name']}', '${j['author_code']}'),
      '${j['text'] ?? ''}',
    );
    p.id = (j['id'] as num?)?.toInt();
    _applyPost(p, j);
    return p;
  }

  static Future<List<Post>> fetchPosts() async {
    final list = await _getList('/api/posts/');
    final posts = list.map(_postFromJson).toList();
    final imgs = await Future.wait(list.map((j) => _download(j['image'])));
    for (var i = 0; i < posts.length; i++) {
      posts[i].img = imgs[i];
    }
    return posts;
  }

  static Future<Post> createPost(String text, Uint8List? image) async {
    final uri = Uri.parse('$base/api/posts/');
    Future<http.Response> once() async {
      final req = http.MultipartRequest('POST', uri)..fields['text'] = text;
      if (access != null) req.headers['Authorization'] = 'Bearer $access';
      if (image != null) {
        req.files.add(http.MultipartFile.fromBytes('image', image,
            filename: 'post.jpg'));
      }
      return http.Response.fromStream(await req.send());
    }

    var res = await once();
    if (res.statusCode == 401 && await _refreshToken()) res = await once();
    if (res.statusCode != 201) {
      throw Exception('Нийтлэл нэмж чадсангүй: ${utf8.decode(res.bodyBytes)}');
    }
    final p = _postFromJson(
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>);
    p.img = image;
    return p;
  }

  static Future<void> likePost(Post p) async {
    _applyPost(p, await _postAction('/api/posts/${p.id}/like/'));
  }

  static Future<void> commentPost(Post p, String text) async {
    _applyPost(
        p, await _postAction('/api/posts/${p.id}/comment/', {'text': text}));
  }

  // ================= САНАЛ ГОМДОЛ =================
  static void _applySuggestion(Suggestion s, Map<String, dynamic> j) {
    final liked = j['liked'] == true;
    final total = (j['votes'] as num?)?.toInt() ?? 0;
    s.liked = liked;
    s.votes = liked ? total - 1 : total; // UI өөрийн саналыг тусад нь нэмдэг
  }

  static Suggestion _suggestionFromJson(Map<String, dynamic> j) {
    final s = Suggestion('${j['text'] ?? ''}', 0);
    s.id = (j['id'] as num?)?.toInt();
    _applySuggestion(s, j);
    return s;
  }

  static Future<List<Suggestion>> fetchSuggestions() async {
    final list = await _getList('/api/suggestions/');
    return list.map(_suggestionFromJson).toList();
  }

  static Future<Suggestion> createSuggestion(String text) async {
    return _suggestionFromJson(
        await _postAction('/api/suggestions/', {'text': text}));
  }

  static Future<void> voteSuggestion(Suggestion s) async {
    _applySuggestion(s, await _postAction('/api/suggestions/${s.id}/vote/'));
  }
}