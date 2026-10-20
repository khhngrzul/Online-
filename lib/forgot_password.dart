import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE6F8F5),
              Color(0xFFFFFFFF),
              Color(0xFFE0F4F8),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF112211),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Сургуулийн имэйл болон шинэ нууц үгээ оруулна уу.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // School Email
                  const Text(
                    'School email',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'you@school.edu',
                      hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                      prefixIcon: const Icon(Icons.mail_outline, color: Colors.black54, size: 20),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // New Password
                  const Text(
                    'New Password',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Шинэ нууц үгээ оруулна уу',
                      hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.black54, size: 20),
                      suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.black54, size: 20),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm New Password
                  const Text(
                    'Confirm New Password',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Шинэ нууц үгээ дахин оруулна уу',
                      hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                      prefixIcon: const Icon(Icons.lock_reset_outlined, color: Colors.black54, size: 20),
                      suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.black54, size: 20),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Reset Password товч
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF191942),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Энд нууц үг шинэчлэх backend/database холболт бичигдэнэ
                      },
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Буцах холбоос
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Нэвтрэх хэсэг рүү буцах',
                        style: TextStyle(
                          color: Color(0xFF11382A),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}