import 'dart:async';
import 'package:flutter/material.dart';
import 'models.dart';

// ===== ЗАР =====
Widget itemPic(Item it, double h, double emoji) => Container(
      height: h,
      width: double.infinity,
      color: kSoft,
      alignment: Alignment.center,
      child: it.img != null
          ? Image.memory(it.img!,
              height: h, width: double.infinity, fit: BoxFit.cover)
          : it.imageUrl != null
              ? Image.network(it.imageUrl!,
                  height: h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Text(
                      it.emoji.isEmpty ? '🛍️' : it.emoji,
                      style: TextStyle(fontSize: emoji)))
              : Text(it.emoji.isEmpty ? '🛍️' : it.emoji,
                  style: TextStyle(fontSize: emoji)),
    );

class MarketTab extends StatefulWidget {
  const MarketTab({super.key});
  @override
  State<MarketTab> createState() => _MarketTabState();
}

class _MarketTabState extends State<MarketTab> {
  Kind? filter;
  ItemCategory? categoryFilter;
  String q = '';

  @override
  void initState() {
    super.initState();
    unawaited(app.loadItems());
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (_, __) {
          final shown = app.items
              .where((i) =>
                  (filter == null || i.kind == filter) &&
                  (categoryFilter == null || i.category == categoryFilter) &&
                  (i.name.toLowerCase().contains(q.toLowerCase()) ||
                      i.desc.toLowerCase().contains(q.toLowerCase()) ||
                      i.category.label
                          .toLowerCase()
                          .contains(q.toLowerCase()) ||
                      i.kind.label.toLowerCase().contains(q.toLowerCase())))
              .toList();
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                              'Солилцоо, зарууд',
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
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
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
                        'Хэрэгцээтэй бараа, номоо хялбар хайгаарай',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      SearchBar(
                        hintText: 'Зар хайх...',
                        hintStyle: const WidgetStatePropertyAll(
                            TextStyle(color: Colors.white70)),
                        textStyle: const WidgetStatePropertyAll(
                            TextStyle(color: Colors.white)),
                        elevation: const WidgetStatePropertyAll(0),
                        backgroundColor:
                            const WidgetStatePropertyAll(Color(0x33FFFFFF)),
                        leading: const Icon(Icons.search, color: Colors.white),
                        onChanged: (v) => setState(() => q = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(spacing: 8, children: [
                    FilterChip(
                        label: const Text('Бүгд'),
                        selected: filter == null,
                        selectedColor: kPri,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                            color: filter == null ? Colors.white : kInk,
                            fontWeight: FontWeight.w700),
                        onSelected: (_) => setState(() => filter = null)),
                    for (final k in Kind.values)
                      FilterChip(
                          label: Text(k.label),
                          selected: filter == k,
                          selectedColor: kPri,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                              color: filter == k ? Colors.white : kInk,
                              fontWeight: FontWeight.w700),
                          onSelected: (_) => setState(() => filter = k)),
                  ]),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('Бүх ангилал'),
                            selected: categoryFilter == null,
                            selectedColor: kSoft,
                            onSelected: (_) =>
                                setState(() => categoryFilter = null),
                          ),
                        ),
                        for (final category in ItemCategory.values
                            .where((value) => value != ItemCategory.all))
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category.label),
                              selected: categoryFilter == category,
                              selectedColor: kSoft,
                              onSelected: (_) =>
                                  setState(() => categoryFilter = category),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    child: app.itemsLoading
                        ? const Center(child: CircularProgressIndicator())
                        : app.itemsError != null
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.wifi_off,
                                        size: 36, color: kPri),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Backend-тэй холбогдож чадсангүй.\n${app.itemsError}',
                                      textAlign: TextAlign.center,
                                    ),
                                    TextButton.icon(
                                      onPressed: () =>
                                          unawaited(app.loadItems(force: true)),
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Дахин оролдох'),
                                    ),
                                  ],
                                ),
                              )
                            : shown.isEmpty
                                ? const Center(child: Text('Зар олдсонгүй 🔍'))
                                : GridView.builder(
                                    itemCount: shown.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 240,
                                            mainAxisSpacing: 12,
                                            crossAxisSpacing: 12,
                                            childAspectRatio: .78),
                                    itemBuilder: (c, i) =>
                                        itemCard(c, shown[i]),
                                  ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}

Widget itemCard(BuildContext c, Item it) => InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () =>
          Navigator.push(c, MaterialPageRoute(builder: (_) => ItemPage(it))),
      child: Container(
        decoration: cardBox(),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            itemPic(it, 100, 46),
            Positioned(
                left: 8,
                top: 8,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(99)),
                    child: Text(it.kind.label,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: it.kind.color)))),
            if (app.favs.contains(it))
              const Positioned(
                  right: 8,
                  top: 8,
                  child:
                      Icon(Icons.favorite, color: Colors.redAccent, size: 20)),
          ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(it.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: kSoft,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          it.category.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 9,
                              color: kInk,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('👤 ${it.owner.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black54)),
                    const SizedBox(height: 4),
                    Text(it.price,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: kDark, fontWeight: FontWeight.w800)),
                  ]),
            ),
          ),
        ]),
      ),
    );

class ItemPage extends StatelessWidget {
  final Item it;
  const ItemPage(this.it, {super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (c, _) {
          final mine = it.owner == app.me, fav = app.favs.contains(it);
          return Scaffold(
            appBar: AppBar(title: const Text('Зарын дэлгэрэнгүй'), actions: [
              if (!mine)
                IconButton(
                    icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                        color: fav ? Colors.redAccent : null),
                    onPressed: () {
                      fav ? app.favs.remove(it) : app.favs.add(it);
                      app.change();
                    }),
              if (mine)
                IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      try {
                        await app.deleteListing(it);
                        if (c.mounted) Navigator.pop(c);
                      } on Exception catch (error) {
                        if (c.mounted) {
                          ScaffoldMessenger.of(c).showSnackBar(
                            SnackBar(content: Text(error.toString())),
                          );
                        }
                      }
                    }),
            ]),
            body: ListView(padding: const EdgeInsets.all(18), children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: itemPic(it, 220, 90)),
              const SizedBox(height: 16),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                      label: Text(it.kind.label),
                      labelStyle: TextStyle(
                          color: it.kind.color, fontWeight: FontWeight.w700))),
              Text(it.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800)),
              Text(it.price,
                  style: const TextStyle(
                      fontSize: 20, color: kDark, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(it.desc.isEmpty ? 'Тайлбар байхгүй' : it.desc),
              const Divider(height: 32),
              ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: avatar(it.owner),
                  title: Text(it.owner.name,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle:
                      Text('${it.owner.faculty} ·${it.owner.year}-р курс')),
              const SizedBox(height: 10),
              if (!mine)
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: kAcc),
                  onPressed: () => Navigator.push(
                      c,
                      MaterialPageRoute(
                          builder: (_) => ChatPage(it.owner.name))),
                  icon: const Icon(Icons.chat),
                  label: const Text('Мессеж бичих'),
                ),
            ]),
          );
        },
      );
}

// ===== ЧАТ =====
class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (c, _) => SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kInk, kPri],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(26)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Мессеж',
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Зарын талаар шуурхай харилцаарай',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
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
            ),
            Expanded(
              child: app.chats.isEmpty
                  ? const Center(
                      child: Text('Зарын хуудаснаас мессеж эхлүүлээрэй 💬'))
                  : ListView(children: [
                      for (final e in app.chats.entries)
                        ListTile(
                          leading: avatar(userByName(e.key), fallback: e.key),
                          title: Text(e.key,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(e.value.last.text,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          onTap: () => Navigator.push(
                              c,
                              MaterialPageRoute(
                                  builder: (_) => ChatPage(e.key))),
                        ),
                    ]),
            ),
          ]),
        ),
      );
}

class ChatPage extends StatefulWidget {
  final String other;
  const ChatPage(this.other, {super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final t = TextEditingController();
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (c, _) {
          final msgs = app.chats[widget.other] ?? [];
          return Scaffold(
            appBar: AppBar(
                title: Row(children: [
              avatar(userByName(widget.other), r: 16, fallback: widget.other),
              const SizedBox(width: 10),
              Text(widget.other)
            ])),
            body: Column(children: [
              Expanded(
                child: ListView(padding: const EdgeInsets.all(14), children: [
                  for (final m in msgs)
                    Align(
                      alignment:
                          m.mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(c).size.width * .75),
                        decoration: BoxDecoration(
                            color: m.mine ? kPri : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: m.mine
                                ? null
                                : Border.all(color: const Color(0xFFF0D5DC))),
                        child: Text(m.text,
                            style: TextStyle(
                                color: m.mine ? Colors.white : Colors.black87)),
                      ),
                    ),
                ]),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    Expanded(
                        child: TextField(
                            controller: t,
                            decoration: InputDecoration(
                                hintText: 'Мессеж бичих...',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none)))),
                    const SizedBox(width: 8),
                    IconButton.filled(
                        style: IconButton.styleFrom(backgroundColor: kDark),
                        onPressed: () {
                          if (t.text.trim().isEmpty) return;
                          app.send(widget.other, t.text.trim());
                          t.clear();
                        },
                        icon: const Icon(Icons.send)),
                  ]),
                ),
              ),
            ]),
          );
        },
      );
}
