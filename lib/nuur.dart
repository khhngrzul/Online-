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
                          Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://cdn.greensoft.mn/uploads/site/883/photos/block/38857_20201027152420_ab74ab6c05f0982361cae703d98810e9.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.school,
                                      size: 20,
                                      color: kPri,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Мандах МТ Их Сургууль',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                              ),
                            ],
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
                                style:
                                    const TextStyle(fontSize: 13, color: kInk),
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
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          child: Center(
                                            child: job.emoji.startsWith('http')
                                                ? ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                      top: Radius.circular(16),
                                                    ),
                                                    child: Image.network(
                                                      job.emoji,
                                                      height: 110,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (_, __, ___) =>
                                                              const Text(
                                                        '💼',
                                                        style: TextStyle(
                                                            fontSize: 48),
                                                      ),
                                                    ),
                                                  )
                                                : Text(
                                                    job.emoji,
                                                    style: const TextStyle(
                                                        fontSize: 48),
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
                                          isSaved
                                              ? app.saved.remove(i)
                                              : app.saved.add(i);
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
                      (
                        '🎓',
                        'Эрдэм шинжилгээний хурал XII',
                        '11-р сарын 30 хүртэл'
                      ),
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
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
class BoardTab extends StatefulWidget {
  const BoardTab({super.key});

  @override
  State<BoardTab> createState() => _BoardTabState();
}

class _BoardTabState extends State<BoardTab> {
  String query = '';
  String category = 'Бүгд';

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (c, _) => SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kInk, kPri],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Оюутнуудын самбар',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: 42,
                          height: 42,
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: ClipOval(
                            child: Image.network(
                              'https://cdn.greensoft.mn/uploads/site/883/photos/block/38857_20201027152420_ab74ab6c05f0982361cae703d98810e9.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.school, color: kPri),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Асуулт асуух, мэдлэгээ хуваалцаарай',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    SearchBar(
                      hintText: 'Хэлэлцүүлэг хайх...',
                      hintStyle: const WidgetStatePropertyAll(
                        TextStyle(color: Colors.white70),
                      ),
                      textStyle: const WidgetStatePropertyAll(
                        TextStyle(color: Colors.white),
                      ),
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor:
                          const WidgetStatePropertyAll(Color(0x33FFFFFF)),
                      leading: const Icon(Icons.search, color: Colors.white),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onChanged: (value) => setState(() => query = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final item in [
                      'Бүгд',
                      'Шалгалт',
                      'Материал',
                      'Асуулт',
                      'Чөлөө',
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(item),
                          selected: category == item,
                          selectedColor: kPri,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: category == item ? Colors.white : kInk,
                            fontWeight: FontWeight.w700,
                          ),
                          side: BorderSide(
                              color: category == item ? kPri : kSoft),
                          onSelected: (_) => setState(() => category = item),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              for (final p in app.posts.where((p) {
                final matchesQuery = query.isEmpty ||
                    p.text.toLowerCase().contains(query.toLowerCase()) ||
                    p.author.name.toLowerCase().contains(query.toLowerCase());
                final matchesCategory =
                    category == 'Бүгд' || p.category == category;
                return matchesQuery && matchesCategory;
              }))
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.author.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                                Text(
                                  '${p.author.year}-р курс · 2ц өмнө',
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: kSoft,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              '#${p.category}',
                              style: const TextStyle(
                                  color: kPri,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      if (p.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            p.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      if (p.comments.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBF7F8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '💬 ${p.comments.first.$1.name}: ${p.comments.first.$2}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                if (p.comments.length > 1) ...[
                                  const SizedBox(height: 6),
                                  if (p.showAllComments)
                                    for (final cm in p.comments.skip(1))
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          '💬 ${cm.$1.name}: ${cm.$2}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                  TextButton(
                                    onPressed: () {
                                      p.showAllComments = !p.showAllComments;
                                      app.change();
                                    },
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                      foregroundColor: kPri,
                                    ),
                                    child: Text(
                                      p.showAllComments
                                          ? 'Сэтгэгдэл нуух'
                                          : 'Бусад ${p.comments.length - 1} сэтгэгдэл',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ],
                            ),
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
  var category = 'Материал';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setM) => Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.82),
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9C5CA),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Шинэ нийтлэл',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: kInk),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                    color: Colors.black38,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Ангилал',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final item in [
                    'Шалгалт',
                    'Материал',
                    'Асуулт',
                    'Чөлөө',
                    'Бусад',
                  ])
                    ChoiceChip(
                      label: Text(item),
                      selected: category == item,
                      selectedColor: kPri,
                      labelStyle: TextStyle(
                        color: category == item ? Colors.white : kInk,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (_) => setM(() => category = item),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final b = await pickImage();
                  if (b != null) {
                    setM(() => img = b);
                  }
                },
                child: Container(
                  height: img == null ? 150 : 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9FB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kPri.withAlpha(100), width: 1.2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: img != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(img!, fit: BoxFit.cover),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit_outlined,
                                    size: 18, color: kPri),
                              ),
                            ),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 34, color: kPri),
                            SizedBox(height: 8),
                            Text(
                              'Зураг оруулах',
                              style: TextStyle(
                                  color: kPri, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: text,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Нийтлэлийн агуулга...',
                  filled: true,
                  fillColor: const Color(0xFFF9F9FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
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
                  app.posts
                      .insert(0, Post(app.me!, value, img, null, category));
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
