import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:onlinezah/forgot_password.dart';
import 'package:onlinezah/login.dart';
import 'package:onlinezah/register.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int index = 0;
  final pages = [
    SchoolLoginScreen(),
    ForgotPasswordScreen(),
    SchoolRegisterScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: pages[index]),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        items: [
          TabItem(icon: Icons.list),
          TabItem(icon: Icons.calendar_today),
          TabItem(icon: Icons.assessment),
        ],
        initialActiveIndex: index,
        onTap: (int i) => {
          setState(() {
            index = i;
          }),
        },
      ),
    );
  }
}
