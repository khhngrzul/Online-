import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'models.dart';

// ===== ЗАР =====
Widget itemPic(Item it, double h, double emoji) => Container(
      height: h,
      width: double.infinity,
      color: kSoft,
      alignment: Alignment.center,
      child: it.img != null ? Image.memory(it.img!, height: h, width: double.infinity, fit: BoxFit.cover) : Text(it.emoji, style: TextStyle(fontSize: emoji)),
    );

class MarketTab extends StatefulWidget {
  const MarketTab({super.key});
  @override
  State<MarketTab> createState() => _MarketTabState();
}

class _MarketTabState extends State<MarketTab> {
  Kind? filter;
  String q = '';
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (_, __) {
          final shown = app.items.where((i) => (filter == null || i.kind == filter) && i.name.toLowerCase().contains(q.toLowerCase())).toList();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Солилцоо, зарууд', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kInk)),
                const SizedBox(height: 10),
                SearchBar(hintText: 'Хайх...', leading: const Icon(Icons.search), elevation: const WidgetStatePropertyAll(0), onChanged: (v) => setState(() => q = v)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  FilterChip(label: const Text('Бүгд'), selected: filter == null, selectedColor: kSoft, onSelected: (_) => setState(() => filter = null)),
                  for (final k in Kind.values) FilterChip(label: Text(k.label), selected: filter == k, selectedColor: kSoft, onSelected: (_) => setState(() => filter = k)),
                ]),
                const SizedBox(height: 10),
                Expanded(
                  child: shown.isEmpty
                      ? const Center(child: Text('Зар олдсонгүй 🔍'))
                      : GridView.builder(
                          itemCount: shown.length,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 220, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .85),
                          itemBuilder: (c, i) => itemCard(c, shown[i]),
                        ),
                ),
              ]),
            ),
          );
        },
      );
}

Widget itemCard(BuildContext c, Item it) => InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => ItemPage(it))),
      child: Container(
        decoration: cardBox(),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            itemPic(it, 100, 46),
            Positioned(left: 8, top: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(99)), child: Text(it.kind.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: it.kind.color)))),
            if (app.favs.contains(it)) const Positioned(right: 8, top: 8, child: Icon(Icons.favorite, color: Colors.redAccent, size: 20)),
          ]),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(it.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text('👤 ${it.owner.name}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
              Text(it.price, style: const TextStyle(color: kDark, fontWeight: FontWeight.w800)),
            ]),
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
              if (!mine) IconButton(icon: Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? Colors.redAccent : null), onPressed: () { fav ? app.favs.remove(it) : app.favs.add(it); app.change(); }),
              if (mine) IconButton(icon: const Icon(Icons.delete_outline), onPressed: () { app.items.remove(it); app.change(); Navigator.pop(c); }),
            ]),
            body: ListView(padding: const EdgeInsets.all(18), children: [
              ClipRRect(borderRadius: BorderRadius.circular(24), child: itemPic(it, 220, 90)),
              const SizedBox(height: 16),
              Align(alignment: Alignment.centerLeft, child: Chip(label: Text(it.kind.label), labelStyle: TextStyle(color: it.kind.color, fontWeight: FontWeight.w700))),
              Text(it.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              Text(it.price, style: const TextStyle(fontSize: 20, color: kDark, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text(it.desc.isEmpty ? 'Тайлбар байхгүй' : it.desc),
              const Divider(height: 32),
              ListTile(contentPadding: EdgeInsets.zero, leading: avatar(it.owner), title: Text(it.owner.name, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text('${it.owner.faculty} · ${it.owner.year}-р курс')),
              const SizedBox(height: 10),
              if (!mine) FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: kAcc),
                onPressed: () => Navigator.push(c, MaterialPageRoute(builder: (_) => ChatPage(it.owner.name))),
                icon: const Icon(Icons.chat), label: const Text('Мессеж бичих'),
              ),
            ]),
          );
        },
      );
}

void addItemSheet(BuildContext context) {
  final name = TextEditingController(), desc = TextEditingController(), price = TextEditingController();
  var kind = Kind.sell, emoji = '🛍️';
  Uint8List? img;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setM) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Шинэ зар', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            SegmentedButton<Kind>(segments: [for (final k in Kind.values) ButtonSegment(value: k, label: Text(k.label))], selected: {kind}, onSelectionChanged: (s) => setM(() => kind = s.first)),
            const SizedBox(height: 10),
            Wrap(spacing: 6, children: [for (final e in ['🛍️', '📚', '💻', '🎧', '🧥', '🚲', '🎮', '🪑']) ChoiceChip(label: Text(e), selected: emoji == e, onSelected: (_) => setM(() => emoji = e))]),
            const SizedBox(height: 10),
            photoPicker(img, () async { final b = await pickImage(); if (b != null) setM(() => img = b); }),
            const SizedBox(height: 10),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Нэр', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(labelText: 'Тайлбар', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            if (kind == Kind.sell) TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Үнэ ₮', border: OutlineInputBorder())),
            const SizedBox(height: 14),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48), backgroundColor: kAcc),
              onPressed: () {
                if (name.text.trim().isEmpty) return;
                app.items.insert(0, Item(name.text.trim(), desc.text.trim(), kind == Kind.sell ? '${price.text.isEmpty ? '—' : price.text}₮' : kind.label, emoji, kind, app.me!, img));
                app.change();
                Navigator.pop(ctx);
              },
              child: const Text('Нийтлэх'),
            ),
          ]),
        ),
      ),
    ),
  );
}

// ===== ЧАТ =====
class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (c, _) => SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.all(16), child: Text('Мессеж', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kInk))),
            Expanded(
              child: app.chats.isEmpty
                  ? const Center(child: Text('Зарын хуудаснаас мессеж эхлүүлээрэй 💬'))
                  : ListView(children: [
                      for (final e in app.chats.entries)
                        ListTile(
                          leading: avatar(userByName(e.key), fallback: e.key),
                          title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(e.value.last.text, maxLines: 1, overflow: TextOverflow.ellipsis),
                          onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => ChatPage(e.key))),
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
            appBar: AppBar(title: Row(children: [avatar(userByName(widget.other), r: 16, fallback: widget.other), const SizedBox(width: 10), Text(widget.other)])),
            body: Column(children: [
              Expanded(
                child: ListView(padding: const EdgeInsets.all(14), children: [
                  for (final m in msgs)
                    Align(
                      alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(c).size.width * .75),
                        decoration: BoxDecoration(color: m.mine ? kPri : Colors.white, borderRadius: BorderRadius.circular(18), border: m.mine ? null : Border.all(color: const Color(0xFFF0D5DC))),
                        child: Text(m.text, style: TextStyle(color: m.mine ? Colors.white : Colors.black87)),
                      ),
                    ),
                ]),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    Expanded(child: TextField(controller: t, decoration: InputDecoration(hintText: 'Мессеж бичих...', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none)))),
                    const SizedBox(width: 8),
                    IconButton.filled(style: IconButton.styleFrom(backgroundColor: kDark), onPressed: () { if (t.text.trim().isEmpty) return; app.send(widget.other, t.text.trim()); t.clear(); }, icon: const Icon(Icons.send)),
                  ]),
                ),
              ),
            ]),
          );
        },
      );
}
