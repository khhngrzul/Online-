import 'package:flutter/material.dart';
import 'models.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), code = TextEditingController(), pass = TextEditingController();
  bool login = true, hide = true;
  String faculty = 'Програм хангамж';
  int year = 1;
  String? error;

  void submit() {
    if (!form.currentState!.validate()) return;
    final c = code.text.trim().toUpperCase();
    setState(() => error = login ? app.login(c, pass.text) : app.register(User(name.text.trim(), c, pass.text, faculty, year)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFDBE4), Color(0xFFF7C6D4), Color(0xFFFFE6CF)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                width: double.infinity,
                decoration: gradient,
                padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 40, 24, 60),
                child: const Column(children: [
                  Text('🎓', style: TextStyle(fontSize: 52)),
                  SizedBox(height: 8),
                  Text('Campus Hub', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                  Text('Сургуулийн оюутны кодоороо нэвтэрнэ', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 14),
                  Text('🎒  📚  🎨  🎧  🧪  ⚽', style: TextStyle(fontSize: 26)),
                ]),
              ),
              Transform.translate(
                offset: const Offset(0, -34),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: cardBox(),
                  child: Form(
                    key: form,
                    child: Column(children: [
                      SegmentedButton<bool>(
                        segments: const [ButtonSegment(value: true, label: Text('Нэвтрэх')), ButtonSegment(value: false, label: Text('Бүртгүүлэх'))],
                        selected: {login},
                        onSelectionChanged: (s) => setState(() { login = s.first; error = null; }),
                      ),
                      const SizedBox(height: 16),
                      if (!login) ...[
                        TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Нэр', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder()),
                            validator: (v) => v!.trim().isEmpty ? 'Нэрээ оруулна уу' : null),
                        const SizedBox(height: 12),
                      ],
                      TextFormField(
                        controller: code,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(labelText: 'Оюутны код (жишээ: B230910001)', prefixIcon: Icon(Icons.badge_outlined), border: OutlineInputBorder()),
                        validator: (v) => RegExp(r'^[A-Z]\d{6,9}$').hasMatch(v!.trim().toUpperCase()) ? null : 'Оюутны код буруу байна',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: pass,
                        obscureText: hide,
                        decoration: InputDecoration(
                          labelText: 'Нууц үг', prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder(),
                          suffixIcon: IconButton(icon: Icon(hide ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => hide = !hide)),
                        ),
                        validator: (v) => v!.length < 4 ? 'Дор хаяж 4 тэмдэгт' : null,
                      ),
                      if (!login) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: faculty,
                          decoration: const InputDecoration(labelText: 'Салбар', border: OutlineInputBorder()),
                          items: ['Програм хангамж', 'Мэдээллийн систем', 'Компьютерын ухаан', 'Сүлжээ'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                          onChanged: (v) => setState(() => faculty = v!),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          value: year,
                          decoration: const InputDecoration(labelText: 'Курс', border: OutlineInputBorder()),
                          items: [1, 2, 3, 4].map((y) => DropdownMenuItem(value: y, child: Text('$y-р курс'))).toList(),
                          onChanged: (v) => setState(() => year = v!),
                        ),
                      ],
                      if (error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(error!, style: const TextStyle(color: Colors.red))),
                      const SizedBox(height: 16),
                      SizedBox(width: double.infinity, height: 48, child: FilledButton(style: FilledButton.styleFrom(backgroundColor: kDark), onPressed: submit, child: Text(login ? 'Нэвтрэх' : 'Бүртгэл үүсгэх'))),
                      if (login) TextButton(onPressed: () { code.text = 'B240101001'; pass.text = '1234'; }, child: const Text('Демо акаунтаар оролдох')),
                    ]),
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
}
