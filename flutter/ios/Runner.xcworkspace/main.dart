import 'package:flutter/material.dart';

void main() => runApp(const MandakhApp());

const _primary = Color(0xFF1E1B4B); // Deep Navy/Indigo
const _accent = Color(0xFF0D9488);  // Vibrant Teal
const _bgGradient1 = Color(0xFFE0F2FE); // Vibrant Light Blue
const _bgGradient2 = Color(0xFFF3E8FF); // Soft Purple tint
const _cardBg = Colors.white;
const _textDark = Color(0xFF0F172A);
const _textMuted = Color(0xFF64748B);

class MandakhApp extends StatelessWidget {
  const MandakhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mandakh Portal',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _accent),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _selectedChip = 0;
  final Set<int> _savedAds = {};

  final List<String> _chips = ['Бүгд', 'Судалгаа', 'Чөлөөт цаг', 'Дадлага, ажил', 'Оюутны зар'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgGradient1, _bgGradient2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildFeatureCard(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 12),
              _buildChipsRow(),
              const SizedBox(height: 20),
              _buildSectionHeader('Сүүлийн зарууд', 'Шинэ эхэнд v'),
              const SizedBox(height: 12),
              _buildAdsList(),
              const SizedBox(height: 20),
              _buildSectionHeader('Ойрын өдрүүдэд', 'Бүх үйл ажиллагаа →'),
              const SizedBox(height: 12),
              _buildEventsList(),
              const SizedBox(height: 20),
              _buildSectionHeader('Хэрэгтэй холбоосууд', ''),
              const SizedBox(height: 12),
              _buildLinksList(),
              const SizedBox(height: 24),
              _buildFooterNote(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.white,
        elevation: 10,
        indicatorColor: const Color(0xFFCCFBF1),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded, color: _accent), label: 'Нүүр'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded, color: _accent), label: 'Зар'),
          NavigationDestination(icon: Icon(Icons.bookmark_border_rounded), selectedIcon: Icon(Icons.bookmark_rounded, color: _accent), label: 'Хадгалсан'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded, color: _accent), label: 'Профайл'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Мандах сургуулийн албан ёсны лого
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 2))],
            image: const DecorationImage(
              image: NetworkImage('logo(mandakh).jpeg'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Мандах Мэдээллийн Технологийн их сургууль',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted)),
              SizedBox(height: 2),
              Text('Сайн уу, Анужин!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _textDark)),
            ],
          ),
        ),
        CircleAvatar(
          backgroundColor: _primary,
          child: const Text('А', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildFeatureCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Онцлох мэдээлэл', style: TextStyle(color: Color(0xFF5EEAD4), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                const Text('Улирлын шалгалтын хуваарь харах уу?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                const Text('Хичээл бүрийн шалгалтын тов, зөвлөмжийг нэг дороос үзнэ үү.',
                    style: TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  icon: const Text('Дэлгэрэнгүй', style: TextStyle(fontSize: 12)),
                  label: const Icon(Icons.arrow_forward_rounded, size: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.assignment_turned_in_rounded, size: 64, color: Color(0xFF5EEAD4)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Зар, мэдээлэл хайх...',
        hintStyle: const TextStyle(color: _textMuted, fontSize: 14),
        prefixIcon: const Icon(Icons.search_rounded, color: _accent),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildChipsRow() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedChip == index;
          return ChoiceChip(
            label: Text(_chips[index], style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : _textDark, fontWeight: FontWeight.bold)),
            selected: isSelected,
            selectedColor: _primary,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: (val) => setState(() => _selectedChip = index),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _textDark)),
        if (action.isNotEmpty)
          Text(action, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _accent)),
      ],
    );
  }

  Widget _buildAdsList() {
    final ads = [
      {'title': 'Mouse алга болсон харсан хүн надтай холбогдоорой. Утас: 89998899', 'tag': 'Алга болсон зүйл', 'time': '1 цагийн өмнө', 'user': 'Програмчлалын клубын гишүүн'},
      {'title': 'Веб хөгжүүлэлтийн дадлагын багт нэгдээрэй', 'tag': 'Дадлага, ажил', 'time': '2 цагийн өмнө', 'user': 'Б. Тэмүүжин'},
      {'title': 'Algorithm ном авна. Надтай холбогдоорой. Утас: 90953227', 'tag': 'Оюутны зар', 'time': '3 цагийн өмнө', 'user': 'Н. Энхжин'},
    ];

    return Column(
      children: ads.asMap().entries.map((entry) {
        int idx = entry.key;
        var ad = entry.value;
        bool isSaved = _savedAds.contains(idx);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
                    child: Text(ad['tag']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: isSaved ? _accent : _textMuted, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => setState(() {
                      if (isSaved) {
                        _savedAds.remove(idx);
                      } else {
                        _savedAds.add(idx);
                      }
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(ad['title']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 12, color: _textMuted),
                  const SizedBox(width: 4),
                  Text(ad['user']!, style: const TextStyle(fontSize: 11, color: _textMuted)),
                  const Spacer(),
                  const Icon(Icons.access_time, size: 12, color: _textMuted),
                  const SizedBox(width: 4),
                  Text(ad['time']!, style: const TextStyle(fontSize: 11, color: _textMuted)),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventsList() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          _eventItem('28', 'САР', 'Програмчлалын клубын уулзалт', '16:00 - 18:00 цаг'),
          const Divider(height: 20),
          _eventItem('29', 'САР', 'Заал авах уу?', '19:00 - Заал'),
          const Divider(height: 20),
          _eventItem('30', 'САР', 'Төслийн санаагаа хуваалцах өдөр', '17:00 - 19:00 цаг'),
        ],
      ),
    );
  }

  Widget _eventItem(String date, String month, String title, String time) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Text(month, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _textMuted)),
              Text(date, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _primary)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 2),
              Text(time, style: const TextStyle(fontSize: 11, color: _textMuted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinksList() {
    final links = [
      {'title': 'Хичээлийн хуваарь', 'icon': Icons.calendar_today_rounded},
      {'title': 'Цахим номын сан', 'icon': Icons.menu_book_rounded},
      {'title': 'Сургалтын мэдээлэл', 'icon': Icons.info_outline_rounded},
      {'title': 'Тусламж, заавар', 'icon': Icons.help_outline_rounded},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: links.map((link) {
          return ListTile(
            leading: Icon(link['icon'] as IconData, color: _accent, size: 20),
            title: Text(link['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: _textMuted),
            onTap: () {},
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFooterNote() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user_rounded, size: 14, color: _accent),
            SizedBox(width: 6),
            Text('Хүндэтгэлтэй орчин, хэрэгтэй мэдээлэл', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
          ],
        ),
        SizedBox(height: 4),
        Text('Зард зөв ангилж, хувийн мэдээллээ хамгаалаарай.', style: TextStyle(fontSize: 11, color: _textMuted)),
      ],
    );
  }
}