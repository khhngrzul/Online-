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
          final saved = app.favs.where((i) => i.owner != u).toList();
          var selectedTab = 'mine';
          Widget stat(String n, String l) => Expanded(
                  child: Column(children: [
                Text(n,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: kDark)),
                Text(l,
                    style: const TextStyle(fontSize: 12, color: Colors.black54))
              ]));
          Widget row(Item i, String sub) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: kSoft,
                  backgroundImage: i.img != null
                      ? MemoryImage(i.img!)
                      : i.imageUrl != null
                          ? NetworkImage(i.imageUrl!)
                          : null,
                  child: i.img == null && i.imageUrl == null
                      ? Text(i.emoji.isEmpty ? '📦' : i.emoji)
                      : null,
                ),
                title: Text(i.name),
                subtitle: Text(sub),
                onTap: () => Navigator.push(
                    c, MaterialPageRoute(builder: (_) => ItemPage(i))),
              );
          return StatefulBuilder(
              builder: (context, setProfileState) => ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        decoration: gradient,
                        padding: EdgeInsets.fromLTRB(
                            20, MediaQuery.of(c).padding.top + 20, 20, 30),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 42,
                                height: 42,
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://cdn.greensoft.mn/uploads/site/883/photos/block/38857_20201027152420_ab74ab6c05f0982361cae703d98810e9.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.school, color: kPri),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            CircleAvatar(
                                radius: 42,
                                backgroundColor: Colors.white,
                                child: avatar(u, r: 38)),
                            const SizedBox(height: 10),
                            Text(u.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800)),
                            Text('${u.faculty} · ${u.year}-р курс · ${u.code}',
                                style: const TextStyle(color: Colors.white70)),
                            if (u.bio.isNotEmpty)
                              Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(u.bio,
                                      style: const TextStyle(
                                          color: Colors.white))),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: cardBox(),
                        child: Row(children: [
                          stat('${mine.length}', 'Миний зар'),
                          stat('${app.favs.length}', 'Хадгалсан'),
                          stat(
                              '${app.posts.where((p) => p.author == u).length}',
                              'Нийтлэл')
                        ]),
                      ),
                      GestureDetector(
                        onTap: () {
                          app.quoteIdx++;
                          app.change();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                              gradient:
                                  const LinearGradient(colors: [kDeep, kAcc]),
                              borderRadius: BorderRadius.circular(22)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('💌 ${u.name}, чамд зориулав',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 10),
                                Text(quotes[app.quoteIdx % quotes.length],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                const Text('Дарж дараагийн үгийг үз →',
                                    style: TextStyle(
                                        color: Color(0xFFFFD9E2),
                                        fontSize: 12)),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => editProfile(c),
                                    icon: const Icon(Icons.edit_outlined,
                                        color: kPri),
                                    label: const Text(
                                      'Засах',
                                      style: TextStyle(
                                          color: kPri,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48),
                                      side: const BorderSide(color: kPri),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FilledButton.icon(
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48),
                                      backgroundColor: kInk,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                    ),
                                    onPressed: app.logout,
                                    icon: const Icon(Icons.logout),
                                    label: const Text('Гарах'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2E9EC),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setProfileState(
                                          () => selectedTab = 'mine'),
                                      child: Container(
                                        height: 42,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: selectedTab == 'mine'
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: selectedTab == 'mine'
                                              ? const [
                                                  BoxShadow(
                                                      color: Color(0x1A5E011C),
                                                      blurRadius: 5)
                                                ]
                                              : null,
                                        ),
                                        child: Text(
                                          'Миний зарууд',
                                          style: TextStyle(
                                            color: selectedTab == 'mine'
                                                ? kPri
                                                : kInk,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setProfileState(
                                          () => selectedTab = 'saved'),
                                      child: Container(
                                        height: 42,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: selectedTab == 'saved'
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Хадгалсан зарууд',
                                          style: TextStyle(
                                            color: selectedTab == 'saved'
                                                ? kPri
                                                : kInk,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (selectedTab == 'mine' && mine.isEmpty)
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 36, 20, 28),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                      color: kPri.withAlpha(70),
                                      style: BorderStyle.solid),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 58,
                                      height: 58,
                                      decoration: const BoxDecoration(
                                          color: kSoft, shape: BoxShape.circle),
                                      child: const Icon(
                                          Icons.storefront_outlined,
                                          color: kPri,
                                          size: 30),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Одоогоор зар алга',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: kInk),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Хэрэглэхүй ном, хэрэглээний зүйлийг\nуюулж зар эхлүүлээрэй',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    const SizedBox(height: 16),
                                    FilledButton.icon(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: kPri,
                                        minimumSize: const Size(220, 48),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14)),
                                      ),
                                      onPressed: () => addItemSheet(c),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Анхны зар нэмэх'),
                                    ),
                                  ],
                                ),
                              ),
                            if (selectedTab == 'mine')
                              for (final i in mine) row(i, i.price),
                            if (selectedTab == 'saved')
                              if (saved.isEmpty)
                                const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Text('Хадгалсан зар алга'),
                                ))
                              else
                                for (final i in saved)
                                  row(i, '${i.owner.name} · ${i.price}'),
                          ],
                        ),
                      ),
                    ],
                  ));
        },
      );
}

void editProfile(BuildContext context) {
  final u = app.me!;
  final name = TextEditingController(text: u.name),
      bio = TextEditingController(text: u.bio);
  var year = u.year;
  Uint8List? img = u.img;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setM) => Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.72),
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                  color: const Color(0xFFD9C5CA),
                  borderRadius: BorderRadius.circular(99)),
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Профайл засах',
                    style: TextStyle(
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
            const SizedBox(height: 8),
            photoPicker(img, () async {
              final b = await pickImage();
              if (b != null) setM(() => img = b);
            }, label: 'Профайлын зураг сонгох'),
            const SizedBox(height: 10),
            TextField(
                controller: name,
                decoration: const InputDecoration(
                    labelText: 'Оюутны нэр',
                    filled: true,
                    fillColor: Color(0xFFF9F9FB),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none))),
            const SizedBox(height: 10),
            TextField(
                controller: bio,
                maxLines: 2,
                decoration: const InputDecoration(
                    labelText: 'Мэргэжил',
                    filled: true,
                    fillColor: Color(0xFFF9F9FB),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none))),
            const SizedBox(height: 10),
            SegmentedButton<int>(segments: [
              for (final y in [1, 2, 3, 4])
                ButtonSegment(value: y, label: Text('$y-р'))
            ], selected: {
              year
            }, onSelectionChanged: (s) => setM(() => year = s.first)),
            const SizedBox(height: 14),
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: kDark),
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
