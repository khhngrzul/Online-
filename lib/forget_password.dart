import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  // 🍷 Wine Color Palette кодууд (Өмнөх Login/Register-тэй ижил)
  static const Color wine1 = Color(0xFFA2304F);
  static const Color wine2 = Color(0xFF8D1538);
  static const Color wine3 = Color(0xFF790222);
  static const Color wine4 = Color(0xFF5E011C);
  static const Color wine5 = Color(0xFF3F0112);

  static const Color darkText = Color(0xFF2D3748);
  static const Color inputBorderColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        decoration: const BoxDecoration(
          // 🍷 Wine өнгөний төгс уусалттай (Gradient) дэвсгэр
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [wine1, wine2, wine4, wine5],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ================= 1. ДЭЭД ХЭСЭГ =================
              const SizedBox(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_reset_rounded,
                      size: 55,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'НУУЦ ҮГ СЭРГЭЭХ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),

              // ================= 2. ДООД ХЭСЭГ (Цагаан карт) =================
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 25,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Шинэ нууц үг үүсгэх',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Та бүртгэлтэй и-мэйл болон шинэ нууц үгээ оруулна уу.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 1. И-мэйл эсвэл Утасны дугаар
                        _buildLabel('И-мэйл / Утасны дугаар'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          hintText: 'И-мэйл хаяг | Утасны дугаар',
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 16),

                        // 2. Шинэ нууц үг
                        _buildLabel('Шинэ нууц үг'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          hintText: 'Шинэ нууц үгээ оруулна уу',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          obscureText: obscurePassword,
                          onTogglePassword: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // 3. Шинэ нууц үг давтах
                        _buildLabel('Нууц үг баталгаажуулах'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          hintText: 'Шинэ нууц үгээ давтан оруулна уу',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          obscureText: obscureConfirmPassword,
                          onTogglePassword: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                        const SizedBox(height: 30),

                        // Нууц үг шинэчлэх товч (Wine Gradient)
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [wine1, wine2, wine3]),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: wine2.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              // Нууц үг шинэчлэх логик
                            },
                            child: const Text(
                              'НУУЦ ҮГ ШИНЭЧЛЭХ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Нэвтрэх хэсэг рүү буцах холбоос
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Нэвтрэх хэсэг рүү буцах',
                              style: TextStyle(
                                color: wine2,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: inputBorderColor, width: 1.2),
      ),
      child: TextField(
        obscureText: obscureText,
        style: const TextStyle(fontSize: 13, color: darkText),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
          prefixIcon: Icon(icon, color: wine2, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: wine2,
                    size: 20,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
