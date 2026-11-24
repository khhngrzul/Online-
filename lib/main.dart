import 'package:flutter/material.dart';
import 'package:liquid_bottom_nav_bar/liquid_bottom_nav_bar.dart';
import 'models.dart';
import 'nevtreh.dart';
import 'nuur.dart';
import 'zar_chat.dart' hide addItemSheet;
import 'profile.dart';

void main() => runApp(const CampusApp());

class CampusApp extends StatelessWidget {
  const CampusApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Campus Hub',
        themeMode: ThemeMode.light,
        theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: kPri,
            scaffoldBackgroundColor: const Color(0xFFFFF8F9)),
        home: ListenableBuilder(
            listenable: app,
            builder: (_, __) =>
                app.me == null ? const SchoolLoginScreen() : const Shell()),
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

  static const items = <LiquidNavItem>[
    LiquidNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Нүүр',
    ),
    LiquidNavItem(
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront,
      label: 'Зар',
    ),
    LiquidNavItem(
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum,
      label: 'Самбар',
    ),
    LiquidNavItem(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Чат',
    ),
    LiquidNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Профайл',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const tabs = [HomeTab(), MarketTab(), BoardTab(), ChatsTab(), ProfileTab()];
    return Scaffold(
      body: tabs[idx],
      floatingActionButton: switch (idx) {
        1 => FloatingActionButton.extended(
            backgroundColor: kAcc,
            foregroundColor: Colors.white,
            onPressed: () => addItemSheet(context),
            icon: const Icon(Icons.add),
            label: const Text('Зар нэмэх')),
        2 => FloatingActionButton.extended(
            backgroundColor: kAcc,
            foregroundColor: Colors.white,
            onPressed: () => addPostSheet(context),
            icon: const Icon(Icons.edit),
            label: const Text('Нийтлэх')),
        _ => null,
      },
      bottomNavigationBar: LiquidBottomNavBar(
        currentIndex: idx,
        items: items,
        onTap: (index) => setState(() => idx = index),
        onDrag: (index) => setState(() => idx = index),
        height: 56,
        iconSize: 20,
        showLabel: true,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        liquidColor: kPri,
        activeIconColor: Colors.white,
        inactiveIconColor: kPri,
        containerColor: Colors.white,
        borderSide: const BorderSide(color: kSoft),
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        labelStyle: const TextStyle(
          color: kPri,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        activeLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
