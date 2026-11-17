import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'models.dart';
import 'zar_chat.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (c, _) {
          final u = app.me!;
          final mine = app.items.where((i) => i.owner == u).toList();
          Widget stat(String n, String l) => Expanded(child: Column(children: [Text(n, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kDark)), Text(l, style: const TextStyle(fontSize: 12, color: Colors.black54))]));
          Widget row(Item i, String sub) => ListTile(
                leading: CircleAvatar(backgroundColor: kSoft, backgroundImage: i.img != null ? MemoryImage(i.img!) : null, child: i.img == null ? Text(i.emoji) : null),
                title: Text(i.name), subtitle: Text(sub),
                onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => ItemPage(i))),
              );
          return ListView(padding: EdgeInsets.zero, children: [
            Container(
              decoration: gradient,
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(c).padding.top + 20, 20, 30),
              child: Column(children: [
                CircleAvatar(radius: 42, backgroundColor: Colors.white, child: avatar(u, r: 38)),
                const SizedBox(height: 10),
                Text(u.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                Text('${u.faculty} · ${u.year}-р курс · ${u.code}', style: const TextStyle(color: Colors.white70)),
                if (u.bio.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text(u.bio, style: const TextStyle(color: Colors.white))),
              ]),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: cardBox(),
              child: Row(children: [stat('${mine.length}', 'Миний зар'), stat('${app.favs.length}', 'Хадгалсан'), stat('${app.posts.where((p) => p.author == u).length}', 'Нийтлэл')]),
            ),
            GestureDetector(
              onTap: () { app.quoteIdx++; app.change(); },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [kDeep, kAcc]), borderRadius: BorderRadius.circular(22)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('💌 ${u.name}, чамд зориулав', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(quotes[app.quoteIdx % quotes.length], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('Дарж дараагийн үгийг үз →', style: TextStyle(color: Color(0xFFFFD9E2), fontSize: 12)),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: OutlinedButton.icon(onPressed: () => editProfile(c), icon: const Icon(Icons.edit), label: const Text('Засах'))),
                  const SizedBox(width: 10),
                  Expanded(child: FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: kInk), onPressed: app.logout, icon: const Icon(Icons.logout), label: const Text('Гарах'))),
                ]),
                title('Миний зарууд'),
                if (mine.isEmpty) const Text('Одоогоор зар алга'),
                for (final i in mine) row(i, i.price),
                title('Хадгалсан зарууд'),
                if (app.favs.isEmpty) const Text('Хадгалсан зар алга'),
                for (final i in app.favs) row(i, '${i.owner.name} · ${i.price}'),
                const SizedBox(height: 30),
              ]),
            ),
          ]);
        },
      );
}

void editProfile(BuildContext context) {
  final u = app.me!;
  final name = TextEditingController(text: u.name), bio = TextEditingController(text: u.bio);
  var year = u.year;
  Uint8List? img = u.img;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setM) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Профайл засах', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            photoPicker(img, () async { final b = await pickImage(); if (b != null) setM(() => img = b); }, label: 'Профайлын зураг сонгох'),
            const SizedBox(height: 10),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Нэр', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: bio, maxLines: 2, decoration: const InputDecoration(labelText: 'Миний тухай', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            SegmentedButton<int>(segments: [for (final y in [1, 2, 3, 4]) ButtonSegment(value: y, label: Text('$y-р'))], selected: {year}, onSelectionChanged: (s) => setM(() => year = s.first)),
            const SizedBox(height: 14),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48), backgroundColor: kDark),
              onPressed: () {
                u.name = name.text.trim().isEmpty ? u.name : name.text.trim();
                u.bio = bio.text.trim();
                u.year = year;
                u.img = img;
                app.change();
                Navigator.pop(ctx);
              },
              child: const Text('Хадгалах'),
            ),
          ]),
        ),
      ),
    ),
  );
}
