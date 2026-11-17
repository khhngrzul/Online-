import 'package:flutter/material.dart';
import 'models.dart';
import 'nevtreh.dart';
import 'nuur.dart';
import 'zar_chat.dart';
import 'profile.dart';

void main() => runApp(const CampusApp());

class CampusApp extends StatelessWidget {
  const CampusApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Campus Hub',
        themeMode: ThemeMode.light,
        theme: ThemeData(useMaterial3: true, brightness: Brightness.light, colorSchemeSeed: kPri, scaffoldBackgroundColor: const Color(0xFFFFF8F9)),
        home: ListenableBuilder(listenable: app, builder: (_, __) => app.me == null ? const AuthPage() : const Shell()),
      );
}

// ===== ДООД ЦЭС (SHELL) =====
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int idx = 0;
  @override
  Widget build(BuildContext context) {
    const tabs = [HomeTab(), MarketTab(), BoardTab(), ChatsTab(), ProfileTab()];
    return Scaffold(
      body: tabs[idx],
      floatingActionButton: switch (idx) {
        1 => FloatingActionButton.extended(backgroundColor: kAcc, foregroundColor: Colors.white, onPressed: () => addItemSheet(context), icon: const Icon(Icons.add), label: const Text('Зар нэмэх')),
        2 => FloatingActionButton.extended(backgroundColor: kAcc, foregroundColor: Colors.white, onPressed: () => addPostSheet(context), icon: const Icon(Icons.edit), label: const Text('Нийтлэх')),
        _ => null,
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        indicatorColor: kSoft,
        onDestinationSelected: (i) => setState(() => idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: kPri), label: 'Нүүр'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront, color: kPri), label: 'Зар'),
          NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum, color: kPri), label: 'Самбар'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble, color: kPri), label: 'Чат'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: kPri), label: 'Профайл'),
        ],
      ),
    );
  }
}
