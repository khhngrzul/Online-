import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Оюутны систем',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF0EEFF),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const navy = Color(0xFF171F32);
  static const teal = Color(0xFF19A99A);
  static const mint = Color(0xFF63E4D2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF1FF), Color(0xFFF0EEFF), Color(0xFFEAE7FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Дээд хэсэг
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.school_rounded, color: teal, size: 32),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Мандах их сургууль',
                            style: TextStyle(
                              color: Color(0xFF687184),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Миний профайл',
                            style: TextStyle(
                              color: navy,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: navy,
                      child: Text(
                        'A',
                        style: TextStyle(color: Colors.white, fontSize: 21),
                      ),
                    ),
                  ],
                ),
              ),

              // Гүйлгэж болох үндсэн хэсэг
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                  children: [
                    // Профайлын том карт
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: navy,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: navy.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: mint,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              radius: 43,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person_rounded,
                                size: 55,
                                color: navy,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Анужин',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Програм хангамжийн оюутан',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFB9C2D4),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: teal.withOpacity(0.22),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Оюутны эрх идэвхтэй',
                              style: TextStyle(
                                color: mint,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Expanded(
                                child: _Stat(
                                  value: '3-р курс',
                                  label: 'Түвшин',
                                ),
                              ),
                              Expanded(
                                child: _Stat(value: '2026', label: 'Элссэн он'),
                              ),
                              Expanded(
                                child: _Stat(value: 'Идэвхтэй', label: 'Төлөв'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Хувийн мэдээлэл',
                      style: TextStyle(
                        color: navy,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _InfoCard(
                      items: const [
                        _InfoItem(
                          icon: Icons.person_outline,
                          title: 'Үндсэн мэдээлэл',
                          subtitle: 'Нэр, оюутны код',
                        ),
                        _InfoItem(
                          icon: Icons.email_outlined,
                          title: 'И-мэйл хаяг',
                          subtitle: 'И-мэйлээ шинэчлэх',
                        ),
                        _InfoItem(
                          icon: Icons.phone_outlined,
                          title: 'Утасны дугаар',
                          subtitle: 'Дугаараа шинэчлэх',
                        ),
                        _InfoItem(
                          icon: Icons.school_outlined,
                          title: 'Сургалтын мэдээлэл',
                          subtitle: 'Мэргэжил, курс, анги',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Тохиргоо',
                      style: TextStyle(
                        color: navy,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _InfoCard(
                      items: const [
                        _InfoItem(
                          icon: Icons.notifications_none,
                          title: 'Мэдэгдэл',
                          subtitle: 'Мэдэгдлийн тохиргоо',
                        ),
                        _InfoItem(
                          icon: Icons.lock_outline,
                          title: 'Нууц үг солих',
                          subtitle: 'Бүртгэлээ хамгаалах',
                        ),
                        _InfoItem(
                          icon: Icons.logout_rounded,
                          title: 'Системээс гарах',
                          subtitle: 'Бүртгэлээс гарах',
                          isLogout: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Доод цэс
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE7E8EF))),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: const Row(
              children: [
                _NavItem(icon: Icons.home_outlined, label: 'Нүүр'),
                _NavItem(icon: Icons.grid_view_rounded, label: 'Зар'),
                _NavItem(
                  icon: Icons.bookmark_border_rounded,
                  label: 'Хадгалсан',
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Профайл',
                  selected: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFB9C2D4), fontSize: 11),
        ),
      ],
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLogout;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLogout = false,
  });
}

class _InfoCard extends StatelessWidget {
  final List<_InfoItem> items;

  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF171F32).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3),
              leading: Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: items[i].isLogout
                      ? const Color(0xFFFFEEEE)
                      : const Color(0xFFE8F9F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  items[i].icon,
                  color: items[i].isLogout
                      ? Colors.redAccent
                      : const Color(0xFF19A99A),
                ),
              ),
              title: Text(
                items[i].title,
                style: TextStyle(
                  color: items[i].isLogout
                      ? Colors.redAccent
                      : const Color(0xFF171F32),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                items[i].subtitle,
                style: const TextStyle(color: Color(0xFF858D9B), fontSize: 11),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF8991A0),
              ),
              onTap: () {},
            ),
            if (i < items.length - 1) const Divider(height: 1, indent: 56),
          ],
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 78,
            height: 40,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFD6FBF4) : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              color: selected
                  ? const Color(0xFF168F83)
                  : const Color(0xFF454B4D),
              size: 25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF55585F),
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
