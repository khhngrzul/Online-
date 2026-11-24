import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';

// ===== ӨНГӨ =====
const kInk = Color(0xFF3F0112),
    kDeep = Color(0xFF5E011C),
    kDark = Color(0xFF790222);
const kPri = Color(0xFF8D1538),
    kAcc = Color(0xFFA2304F),
    kSoft = Color(0xFFFBE9EE);

const gradient = BoxDecoration(
  gradient: LinearGradient(
      colors: [kInk, kDeep, kPri, kAcc],
      stops: [0, .3, .68, 1],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight),
  borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
);
BoxDecoration cardBox() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: kPri.withAlpha((255 * 0.12).round()),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ]);

// ===== МОДЕЛЬ =====
enum Kind { sell, swap, free }

extension KindX on Kind {
  String get label => const {
        Kind.sell: 'Зарна',
        Kind.swap: 'Солилцоно',
        Kind.free: 'Үнэгүй'
      }[this]!;
  Color get color => const {
        Kind.sell: Color(0xFF0B7A4B),
        Kind.swap: Color(0xFFB45309),
        Kind.free: Color(0xFF7C3AED)
      }[this]!;
}

enum ItemCategory {
  all,
  books,
  electronics,
  accessories,
  clothing,
  transport,
  sports,
}

extension ItemCategoryX on ItemCategory {
  String get label {
    switch (this) {
      case ItemCategory.all:
        return 'Бүгд';
      case ItemCategory.books:
        return 'Ном';
      case ItemCategory.electronics:
        return 'Электроник';
      case ItemCategory.accessories:
        return 'Бусад';
      case ItemCategory.clothing:
        return 'Хувцас';
      case ItemCategory.transport:
        return 'Унаа';
      case ItemCategory.sports:
        return 'Спорт';
    }
  }
}

class User {
  String name, code, pass, faculty, bio;
  int year;
  Uint8List? img;
  User(this.name, this.code, this.pass, this.faculty, this.year,
      [this.bio = '']);
}

class Item {
  String name, desc, price, emoji;
  Kind kind;
  ItemCategory category;
  User owner;
  Uint8List? img;
  String? imageUrl;
  int? backendId;
  Item(this.name, this.desc, this.price, this.emoji, this.kind, this.owner,
      [this.img,
      this.category = ItemCategory.electronics,
      this.imageUrl,
      this.backendId]);
}

class Post {
  User author;
  String text;
  Uint8List? img;
  String? imageUrl;
  String category;
  bool showAllComments = false;
  final likes = <User>{};
  final comments = <(User, String)>[];
  Post(this.author, this.text,
      [this.img, this.imageUrl, this.category = 'Бусад']);
}

class Suggestion {
  String text;
  int votes;
  bool liked = false;
  Suggestion(this.text, this.votes);
}

class Job {
  final String emoji, title, company, pay;
  const Job(this.emoji, this.title, this.company, this.pay);
}

class Msg {
  final bool mine;
  final String text;
  Msg(this.mine, this.text);
}

const facts = [
  (
    '🐙',
    'Наймаалж 3 зүрхтэй!',
    'Хоёр нь заламгайд, нэг нь бие махбодод цус түгээдэг.'
  ),
  (
    '🍯',
    'Зөгийн бал хэзээ ч мууддаггүй',
    'Эртний булшнаас олдсон бал ч идэж болохуйц байсан гэдэг.'
  ),
  (
    '🐦‍⬛',
    'Хэрээ хүний царайг санадаг',
    'Тэд өөрт нь муу хандсан хүнийг олон жил танина.'
  ),
];
const jobs = [
  Job('https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=80',
      'Вэб хөгжүүлэгчийн дадлага', 'Мандах Софт', '600,000₮/сар'),
  Job('https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=800&q=80',
      'Хагас цагийн сургалтын туслах', 'Номын сан', '7,000₮/цаг'),
  Job('https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=800&q=80',
      'Контент бичигч / SMM', 'Кафе Ч', '450,000₮/сар'),
];
const quotes = [
  'Өнөөдөр хийсэн жижиг алхам маргаашийн том амжилт болно 🌱',
  'Чи өөрийнхөө бодож байгаагаас илүү хүчтэй, чадалтай 💪',
  'Алдаа бол суралцах хамгийн сайн арга. Үргэлжлүүл! 🚀',
  'Нэг хичээл, нэг даалгавар — аажмаар ч тогтвортой 📚',
  'Өөртөө итгэ, чи чадна ✨',
  'Хэцүү өдөр ч өнгөрнө, чи улам хүчтэй болно 🌈',
];

// ===== ТӨЛӨВ (STATE) =====
class AppState extends ChangeNotifier {
  final _api = ApiService();
  final users = <String, User>{};
  final items = <Item>[], posts = <Post>[], sug = <Suggestion>[];
  final favs = <Item>{};
  final saved = <int>{};
  final chats = <String, List<Msg>>{};
  User? me;
  bool itemsLoading = false;
  bool itemsLoaded = false;
  String? itemsError;
  Map<String, int> _categoryIds = {};
  int factIdx = 0, quoteIdx = DateTime.now().day;

  AppState() {
    final a = User('Анударь', 'B230910001', '1234', 'Програм хангамж', 2,
        'Номоо солилцох дуртай 📚');
    final t = User('Тэмүүжин', 'B230910002', '1234', 'Мэдээллийн систем', 3);
    final n = User('Номин', 'B230910003', '1234', 'Компьютерын ухаан', 1);
    final d = User('Демо Оюутан', 'B240101001', '1234', 'Програм хангамж', 3,
        'Сайн байна уу 👋');
    for (final u in [a, t, n, d]) {
      users[u.code] = u;
    }
    posts.addAll([
      Post(
          t,
          'Алгоритмын шалгалтын материал хэнд байна?',
          null,
          'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&w=800&q=80',
          'Материал'),
      Post(
          n,
          'Өгөгдлийн шалгалт цуг бэлдэх хүүхэд байна уу?',
          null,
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80',
          'Шалгалт'),
    ]);
    sug.addAll([
      Suggestion('Сургуулийн энд тэнд битгий юм наагаад бай', 34),
      Suggestion('Шалгалтын хувиараа сунгая', 21)
    ]);
    chats.addAll({
      'Анударь': [
        Msg(false, 'hi nom sonirhoh uu '),
        Msg(true, 'za une ni hed ve?'),
      ],
    });
  }

  Future<void> loadItems({bool force = false}) async {
    if (itemsLoading || (itemsLoaded && !force)) return;
    itemsLoading = true;
    itemsError = null;
    notifyListeners();
    try {
      await _loadCategoryIds();
      final data = await _api.fetchItems();
      items
        ..clear()
        ..addAll(data.map(_itemFromApi));
      itemsLoaded = true;
    } on Exception catch (error) {
      itemsError = error.toString();
    } finally {
      itemsLoading = false;
      notifyListeners();
    }
  }

  Future<Item> createListing({
    required String title,
    required String description,
    required String price,
    required Kind kind,
    required ItemCategory category,
    required Uint8List image,
  }) async {
    final owner = me;
    if (owner == null) {
      throw const ApiException('Зар нэмэхийн тулд нэвтэрнэ үү.');
    }
    if (_categoryIds.isEmpty) await _loadCategoryIds();
    final categoryId = _categoryIds[category.label];
    if (categoryId == null) {
      throw ApiException('Backend-д "${category.label}" ангилал олдсонгүй.');
    }

    final normalizedPrice =
        price.replaceAll(',', '').replaceAll(RegExp(r'[^0-9.]'), '');
    final data = await _api.createItem(
      title: title,
      description: description,
      price: kind == Kind.sell && normalizedPrice.isNotEmpty
          ? normalizedPrice
          : '0',
      kind: kind.name,
      ownerName: owner.name,
      categoryId: categoryId,
      image: image,
    );
    final item = _itemFromApi(data);
    items.insert(0, item);
    notifyListeners();
    return item;
  }

  Future<void> deleteListing(Item item) async {
    final id = item.backendId;
    if (id == null) {
      throw const ApiException('Зарын серверийн ID олдсонгүй.');
    }
    await _api.deleteItem(id);
    items.remove(item);
    favs.remove(item);
    notifyListeners();
  }

  Future<void> _loadCategoryIds() async {
    final categories = await _api.fetchCategories();
    _categoryIds = {
      for (final category in categories)
        if (category['name'] is String && category['id'] is int)
          category['name'] as String: category['id'] as int,
    };
  }

  Item _itemFromApi(Map<String, dynamic> data) {
    final ownerName = data['owner_name'] as String? ?? 'Оюутан';
    User owner;
    if (me != null && me!.name == ownerName) {
      owner = me!;
    } else {
      owner = users.values.firstWhere(
        (user) => user.name == ownerName,
        orElse: () => User(ownerName, 'remote-$ownerName', '', '', 1),
      );
    }
    final categoryName = data['category_name'] as String? ?? '';
    final category = ItemCategory.values.firstWhere(
      (value) => value != ItemCategory.all && value.label == categoryName,
      orElse: () => ItemCategory.electronics,
    );
    final kind = Kind.values.firstWhere(
      (value) => value.name == data['kind'],
      orElse: () => Kind.sell,
    );
    final amount = double.tryParse('${data['price'] ?? 0}') ?? 0;
    final formattedAmount = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
        );
    final price = switch (kind) {
      Kind.sell => '$formattedAmount₮',
      Kind.swap => Kind.swap.label,
      Kind.free => Kind.free.label,
    };
    final image = data['image'] as String?;
    final imageUrl =
        (image == null || image.isEmpty) ? data['image_url'] as String? : image;

    return Item(
      data['title'] as String? ?? '',
      data['description'] as String? ?? '',
      price,
      '',
      kind,
      owner,
      null,
      category,
      imageUrl,
      data['id'] as int?,
    );
  }

  String? login(String code, String pass) {
    final u = users[code];
    if (u == null || u.pass != pass) return 'Оюутны код эсвэл нууц үг буруу';
    me = u;
    notifyListeners();
    return null;
  }

  String? register(User u) {
    if (users.containsKey(u.code)) return 'Энэ оюутны код бүртгэлтэй байна';
    users[u.code] = u;
    me = u;
    notifyListeners();
    return null;
  }

  void logout() {
    me = null;
    notifyListeners();
  }

  void change() => notifyListeners();

  void send(String other, String text) {
    chats.putIfAbsent(other, () => []).add(Msg(true, text));
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      chats[other]!.add(Msg(false,
          'Сайн байна уу! Тийм ээ, байгаа. Хэзээ уулзах вэ хө? Авах нь яг баттай юу хө?'));
      notifyListeners();
    });
  }
}

final app = AppState();

// ===== ТУСЛАХ ФУНКЦ =====
Future<Uint8List?> pickImage() async {
  final x = await ImagePicker()
      .pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80);
  return x?.readAsBytes();
}

Widget avatar(User? u, {double r = 20, String? fallback}) {
  if (u?.img != null)
    return CircleAvatar(radius: r, backgroundImage: MemoryImage(u!.img!));
  final n = u?.name ?? fallback ?? '?';
  return CircleAvatar(
    radius: r,
    backgroundColor: kPri,
    child: Text(n.isEmpty ? '?' : n[0].toUpperCase(),
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: r * .9)),
  );
}

User? userByName(String n) {
  for (final u in app.users.values) {
    if (u.name == n) return u;
  }
  return null;
}

Widget photoPicker(Uint8List? img, VoidCallback onTap,
        {String label = 'Зураг оруулах'}) =>
    Column(children: [
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(46),
            foregroundColor: kPri,
            side: const BorderSide(color: kPri)),
        onPressed: onTap,
        icon: const Icon(Icons.photo_camera_outlined),
        label: Text(img == null ? label : 'Зураг солих'),
      ),
      if (img != null)
        Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.memory(img,
                    height: 120, width: double.infinity, fit: BoxFit.cover))),
    ]);

Future<String?> textDialog(BuildContext c, String title, String hint) {
  final t = TextEditingController();
  return showDialog<String>(
    context: c,
    barrierColor: kInk.withAlpha(150),
    builder: (ctx) => Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800, color: kInk),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close),
                  color: Colors.black38,
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: t,
              autofocus: true,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: const Color(0xFFF9F5F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      foregroundColor: kPri,
                      side: const BorderSide(color: kPri),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Болих'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx, t.text.trim()),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      backgroundColor: kPri,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Илгээх'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget title(String t) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 10),
    child: Text(t,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w800, color: kInk)));

// ===== ШИНЭЧЛЭГДСЭН ЗАР НЭМЭХ ЦОНХ (ADD ITEM SHEET) =====
void addItemSheet(BuildContext context) {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  Kind selectedKind = Kind.sell;
  ItemCategory selectedCategory = ItemCategory.books;
  Uint8List? img;
  bool saving = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setM) => Container(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Шинэ зар нэмэх 📢',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: kInk,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: Kind.values.map((kind) {
                    bool isSelected = selectedKind == kind;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setM(() => selectedKind = kind),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSelected
                                ? [
                                    const BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            kind.label,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected ? kPri : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Ангилал',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final category in ItemCategory.values
                      .where((category) => category != ItemCategory.all))
                    ChoiceChip(
                      label: Text(category.label),
                      selected: selectedCategory == category,
                      selectedColor: kPri,
                      labelStyle: TextStyle(
                        color:
                            selectedCategory == category ? Colors.white : kInk,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) =>
                          setM(() => selectedCategory = category),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () async {
                  final b = await pickImage();
                  if (b != null) setM(() => img = b);
                },
                child: Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: img != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(img!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo_outlined,
                                color: kPri, size: 28),
                            const SizedBox(height: 6),
                            const Text(
                              'Зураг оруулах',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Зарын гарчиг / Нэр',
                  hintText: 'Жишээ: Math ном зарна',
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Дэлгэрэнгүй тайлбар',
                  hintText: 'Барааны төлөв байдал...',
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              if (selectedKind == Kind.sell) ...[
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Үнэ (₮)',
                    hintText: '25,000₮',
                    filled: true,
                    fillColor: const Color(0xFFF8F9FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: kPri,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: saving
                    ? null
                    : () async {
                        if (titleController.text.trim().isEmpty ||
                            app.me == null) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                                content: Text('Зарын нэрээ оруулна уу')),
                          );
                          return;
                        }
                        if (img == null) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                                content: Text('Зарын зургийг сонгоно уу')),
                          );
                          return;
                        }

                        setM(() => saving = true);
                        try {
                          await app.createListing(
                            title: titleController.text.trim(),
                            description: descController.text.trim(),
                            price: priceController.text.trim(),
                            kind: selectedKind,
                            category: selectedCategory,
                            image: img!,
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                        } on Exception catch (error) {
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                          }
                        } finally {
                          if (ctx.mounted) setM(() => saving = false);
                        }
                      },
                child: saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Нийтлэх',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
