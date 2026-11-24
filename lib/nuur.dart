import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'models.dart';

// ===== НҮҮР =====
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (c, _) {
          final u = app.me!;
          final f = facts[app.factIdx % facts.length];
          final n = DateTime.now();

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                decoration: gradient,
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(c).padding.top + 18,
                  20,
                  64,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Мандах МТ Их Сургууль',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            'Сайн уу, ${u.name}! ☀️',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${u.faculty} ·${u.year}-р курс · ${n.month}/${n.day}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '12°',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text('УБ ☁️', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -40),
                child: GestureDetector(
                  onTap: () {
                    app.factIdx++;
                    app.change();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFE9C9), Color(0xFFFFD0DA)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Text(f.$1, style: const TextStyle(fontSize: 38)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.$2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: kInk,
                                ),
                              ),
                              Text(
                                f.$3,
                                style: const TextStyle(fontSize: 13, color: kInk),
                              ),
                              const Text(
                                'Дараагийнх →',
                                style: TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                  color: kInk,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          title('Ажил, дадлагын зар 💼'),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: jobs.length,
                            itemBuilder: (context, i) {
                              final job = jobs[i];
                              final isSaved = app.saved.contains(i);
                              return Container(
                                decoration: cardBox(),
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 110,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: kSoft,
                                            borderRadius:
                                                BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              job.emoji,
                                              style: const TextStyle(fontSize: 48),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                job.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  color: kInk,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                job.company,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                job.pay,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 12,
                                                  color: kPri,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          isSaved ? app.saved.remove(i) : app.saved.add(i);
                                          app.change();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: Colors.white70,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isSaved
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 18,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -24),
                      child: title('Сургуулийн мэдээ'),
                    ),
                    for (final n in const [
                      ('🎬', 'MOVIE CLUB — шинэ элсэлт', 'Баасан бүр 18:00'),
                      ('🎓', 'Эрдэм шинжилгээний хурал XII', '11-р сарын 30 хүртэл'),
                      ('🏀', 'Сагсан бөмбөгийн лиг', 'Спорт заалд бүртгүүлнэ'),
                    ])
                      Transform.translate(
                        offset: const Offset(0, -24),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: cardBox(),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: kSoft,
                              child: Text(n.$1),
                            ),
                            title: Text(
                              n.$2,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(n.$3),
                          ),
                        ),
                      ),
                    Transform.translate(
                      offset: const Offset(0, -24),
                      child: title('Санал, гомдлын хайрцаг 💌'),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -24),
                      child: Column(
                        children: [
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(46),
                              backgroundColor: kAcc,
                            ),
                            onPressed: () async {
                              final t = await textDialog(
                                c,
                                'Санал, гомдол (нэрээ нууцлана)',
                                'Юу гэж хэлэх вэ?',
                              );
                              if (t != null && t.isNotEmpty) {
                                app.sug.insert(0, Suggestion(t, 0));
                                app.change();
                              }
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Санал бичих'),
                          ),
                          const SizedBox(height: 10),
                          for (final s in app.sug)
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
                              decoration: cardBox(),
                              child: Row(
                                children: [
                                  Expanded(child: Text(s.text)),
                                  ActionChip(
                                    backgroundColor: s.liked ? kPri : kSoft,
                                    label: Text(
                                      '👍 ${s.votes + (s.liked ? 1 : 0)}',
                                      style: TextStyle(
                                        color: s.liked ? Colors.white : kDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    onPressed: () {
                                      s.liked = !s.liked;
                                      app.change();
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          );
        },
      );
}

// ===== САМБАР =====
class BoardTab extends StatelessWidget {
  const BoardTab({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (c, _) => SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Оюутнуудын самбар',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: kInk,
                ),
              ),
              const SizedBox(height: 12),
              for (final p in app.posts)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: cardBox(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          avatar(p.author, r: 16),
                          const SizedBox(width: 10),
                          Text(
                            p.author.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '  · ${p.author.year}-р курс',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (p.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(p.text),
                        ),
                      if (p.img != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.memory(
                              p.img!,
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      for (final cm in p.comments)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, left: 8),
                          child: Text(
                            '💬 ${cm.$1.name}: ${cm.$2}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              p.likes.contains(app.me)
                                  ? p.likes.remove(app.me)
                                  : p.likes.add(app.me!);
                              app.change();
                            },
                            icon: Icon(
                              p.likes.contains(app.me)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                            label: Text('${p.likes.length}'),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final t = await textDialog(
                                c,
                                'Сэтгэгдэл',
                                'Сэтгэгдэл бичих...',
                              );
                              if (t != null && t.isNotEmpty) {
                                p.comments.add((app.me!, t));
                                app.change();
                              }
                            },
                            icon: const Icon(
                              Icons.mode_comment_outlined,
                              size: 18,
                            ),
                            label: Text('${p.comments.length}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
}

void addPostSheet(BuildContext context) {
  final text = TextEditingController();
  Uint8List? img;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setM) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Шинэ нийтлэл',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              photoPicker(
                img,
                () async {
                  final b = await pickImage();
                  if (b != null) {
                    setM(() => img = b);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: text,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Нийтлэл',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: kAcc,
                ),
                onPressed: () {
                  final value = text.text.trim();
                  if (value.isEmpty && img == null) return;
                  app.posts.insert(0, Post(app.me!, value, img));
                  app.change();
                  Navigator.pop(ctx);
                },
                child: const Text('Нийтлэх'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
