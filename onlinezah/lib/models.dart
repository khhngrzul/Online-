import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ===== ӨНГӨ =====
const kInk = Color(0xFF3F0112), kDeep = Color(0xFF5E011C), kDark = Color(0xFF790222);
const kPri = Color(0xFF8D1538), kAcc = Color(0xFFA2304F), kSoft = Color(0xFFFBE9EE);

const gradient = BoxDecoration(
  gradient: LinearGradient(colors: [kInk, kDeep, kPri, kAcc], stops: [0, .3, .68, 1], begin: Alignment.topLeft, end: Alignment.bottomRight),
  borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
);
BoxDecoration cardBox() => BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.circular(22),
    boxShadow: [BoxShadow(color: kPri.withOpacity(.12), blurRadius: 16, offset: const Offset(0, 6))]);

// ===== МОДЕЛЬ =====
enum Kind { sell, swap, free }

extension KindX on Kind {
  String get label => const {Kind.sell: 'Зарна', Kind.swap: 'Солилцоно', Kind.free: 'Үнэгүй'}[this]!;
  Color get color => const {Kind.sell: Color(0xFF0B7A4B), Kind.swap: Color(0xFFB45309), Kind.free: Color(0xFF7C3AED)}[this]!;
}

class User {
  String name, code, pass, faculty, bio;
  int year;
  Uint8List? img;
  User(this.name, this.code, this.pass, this.faculty, this.year, [this.bio = '']);
}

class Item {
  String name, desc, price, emoji;
  Kind kind;
  User owner;
  Uint8List? img;
  Item(this.name, this.desc, this.price, this.emoji, this.kind, this.owner, [this.img]);
}

class Post {
  User author;
  String text;
  Uint8List? img;
  final likes = <User>{};
  final comments = <(User, String)>[];
  Post(this.author, this.text, [this.img]);
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

// ===== ДЭЭЖ ӨГӨГДӨЛ =====
const facts = [
  ('🐙', 'Наймаалж 3 зүрхтэй!', 'Хоёр нь заламгайд, нэг нь бие махбодод цус түгээдэг.'),
  ('🍯', 'Зөгийн бал хэзээ ч мууддаггүй', 'Эртний булшнаас олдсон бал ч идэж болохуйц байсан гэдэг.'),
  ('🐦‍⬛', 'Хэрээ хүний царайг санадаг', 'Тэд өөрт нь муу хандсан хүнийг олон жил танина.'),
];
const jobs = [
  Job('💻', 'Вэб хөгжүүлэгчийн дадлага', 'Мандах Софт', '600,000₮/сар'),
  Job('📚', 'Хагас цагийн сургалтын туслах', 'Номын сан', '7,000₮/цаг'),
  Job('📱', 'Контент бичигч / SMM', 'Кафе Ч', '450,000₮/сар'),
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
  final users = <String, User>{};
  final items = <Item>[], posts = <Post>[], sug = <Suggestion>[];
  final favs = <Item>{};
  final saved = <int>{};
  final chats = <String, List<Msg>>{};
  User? me;
  int factIdx = 0, quoteIdx = DateTime.now().day;

  AppState() {
    final a = User('Анударь', 'B230910001', '1234', 'Програм хангамж', 2, 'Номоо солилцох дуртай 📚');
    final t = User('Тэмүүжин', 'B230910002', '1234', 'Мэдээллийн систем', 3);
    final n = User('Номин', 'B230910003', '1234', 'Компьютерын ухаан', 1);
    final d = User('Демо Оюутан', 'B240101001', '1234', 'Програм хангамж', 3, 'Сайн байна уу 👋');
    for (final u in [a, t, n, d]) { users[u.code] = u; }
    items.addAll([
      Item('Алгоритмын сурах бичиг', 'Сайн хадгалагдсан, тэмдэглэлтэй.', '25,000₮', '📚', Kind.sell, a),
      Item('Ширээний гэрэл', 'LED, 2 жил ашигласан.', 'Үнэгүй', '💡', Kind.free, t),
      Item('Casio fx-991', 'Номоор солилцоно.', 'Солилцоно', '🧮', Kind.swap, n),
      Item('Чихэвч', 'Bluetooth, цэнэг сайн барьдаг.', '45,000₮', '🎧', Kind.sell, t),
    ]);
    posts.addAll([
      Post(t, 'Алгоритмын шалгалтын материал хэнд байна? 🙏'),
      Post(n, 'Номын сангийн 3-р давхарт нам гүм суудал олдож байна 📚'),
    ]);
    sug.addAll([Suggestion('Номын сангийн цагийг 22:00 хүртэл сунгаач', 34), Suggestion('Столовойд ногоон хоол нэмээч', 21)]);
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

  void logout() { me = null; notifyListeners(); }
  void change() => notifyListeners();

  void send(String other, String text) {
    chats.putIfAbsent(other, () => []).add(Msg(true, text));
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      chats[other]!.add(Msg(false, 'Сайн байна уу! Тийм ээ, байгаа. Хэзээ уулзах вэ?'));
      notifyListeners();
    });
  }
}

final app = AppState();

// ===== ТУСЛАХ ФУНКЦ =====
Future<Uint8List?> pickImage() async {
  final x = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80);
  return x?.readAsBytes();
}

Widget avatar(User? u, {double r = 20, String? fallback}) {
  if (u?.img != null) return CircleAvatar(radius: r, backgroundImage: MemoryImage(u!.img!));
  final n = u?.name ?? fallback ?? '?';
  return CircleAvatar(
    radius: r,
    backgroundColor: kPri,
    child: Text(n.isEmpty ? '?' : n[0].toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: r * .9)),
  );
}

User? userByName(String n) {
  for (final u in app.users.values) { if (u.name == n) return u; }
  return null;
}

Widget photoPicker(Uint8List? img, VoidCallback onTap, {String label = 'Зураг оруулах'}) => Column(children: [
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(46), foregroundColor: kPri, side: const BorderSide(color: kPri)),
        onPressed: onTap,
        icon: const Icon(Icons.photo_camera_outlined),
        label: Text(img == null ? label : 'Зураг солих'),
      ),
      if (img != null) Padding(padding: const EdgeInsets.only(top: 8), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.memory(img, height: 120, width: double.infinity, fit: BoxFit.cover))),
    ]);

Future<String?> textDialog(BuildContext c, String title, String hint) {
  final t = TextEditingController();
  return showDialog<String>(
    context: c,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(controller: t, autofocus: true, maxLines: null, decoration: InputDecoration(hintText: hint)),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Болих')), FilledButton(onPressed: () => Navigator.pop(ctx, t.text.trim()), child: const Text('Илгээх'))],
    ),
  );
}

Widget title(String t) => Padding(padding: const EdgeInsets.only(top: 22, bottom: 10), child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kInk)));
