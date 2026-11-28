import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'models.dart';
import 'register.dart';
import 'forget_password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';

class SchoolLoginScreen extends StatefulWidget {
  const SchoolLoginScreen({super.key});

  @override
  State<SchoolLoginScreen> createState() => _SchoolLoginScreenState();
}

class _SchoolLoginScreenState extends State<SchoolLoginScreen>
    with TickerProviderStateMixin {
  bool rememberMe = false;
  bool obscurePassword = true;
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  String? loginError;
  bool _isLoading = false;

  late final AnimationController _lottieController;

  // 🍷 Wine Color Palette кодууд
  static const Color wine1 = Color(0xFFA2304F);
  static const Color wine2 = Color(0xFF8D1538);
  static const Color wine3 = Color(0xFF790222);
  static const Color wine4 = Color(0xFF5E011C);
  static const Color wine5 = Color(0xFF3F0112);

  static const Color darkText = Color(0xFF2D3748);
  static const Color inputBorderColor = Color(0xFFE2E8F0);

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  Future<void> _submitLogin() async {
    final code = codeController.text.trim();
    final password = passwordController.text;
    if (code.isEmpty || password.isEmpty) {
      setState(() => loginError = 'Оюутны код болон нууц үгээ оруулна уу');
      return;
    }
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      loginError = null;
    });
    try {
      final response = await http.post(
        Uri.parse('${Api.base}/api/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': code, 'password': password}),
      );
      if (!mounted) return;

      if (response.statusCode != 200) {
        final localError = app.login(code, password);
        if (localError == null) {
          await app.loadRemote();
          if (mounted) setState(() => loginError = null);
          return;
        }
        setState(() => loginError = 'Оюутны код эсвэл нууц үг буруу');
        return;
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final access = data['access'] as String?;
      final refresh = data['refresh'] as String?;
      if (access == null || refresh == null) {
        setState(() => loginError = 'Серверээс буруу хариу ирлээ');
        return;
      }

      // Хэрэглэгчийн мэдээллийг Django-оос авах
      final meRes = await http.get(
        Uri.parse('${Api.base}/api/auth/me/'),
        headers: {'Authorization': 'Bearer $access'},
      );
      if (!mounted) return;
      if (meRes.statusCode != 200) {
        setState(() => loginError = 'Хэрэглэгчийн мэдээлэл авч чадсангүй');
        return;
      }
      final me = jsonDecode(utf8.decode(meRes.bodyBytes));
      Api.access = access;
      Api.refresh = refresh;

      final studentCode = (me['student_code'] ?? code).toString();
      final fullName =
          '${me['last_name'] ?? ''} ${me['first_name'] ?? ''}'.trim();

      // Апп доторх хэрэглэгч болгож хадгалаад үндсэн дэлгэц рүү шилжинэ
      final user = User(
        fullName.isEmpty ? studentCode : fullName,
        studentCode,
        password,
        '', // тэнхим: backend-д хадгалдаггүй
        1, // курс: backend-д хадгалдаггүй
      );
      app.users.remove(studentCode);
      app.register(user); // app.me = user болж, Shell рүү шилжинэ
      await app.loadRemote();

      if (!mounted) return;

      setState(() => loginError = null);
    } catch (e) {
      debugPrint('НЭВТРЭХ АЛДАА: $e');
      if (mounted) {
        final localError = app.login(code, password);
        if (localError != null) {
          setState(
              () => loginError = 'Сервертэй холбогдож чадсангүй: $e');
        } else {
          await app.loadRemote();
          if (mounted) setState(() => loginError = null);
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loginAsDemo() {
    codeController.text = 'B240101001';
    passwordController.text = '1234';
    _submitLogin();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    codeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [wine1, wine2, wine4, wine5],
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                // ================= 1. ДЭЭД ХЭСЭГ =================
                Expanded(
                  flex: 4,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 130,
                          child: Lottie.network(
                            'https://lottie.host/1c5d2fa7-c7d6-4def-847f-3111b218d11a/X2w9Je8Z4W.lottie',
                            controller: _lottieController,
                            fit: BoxFit.contain,
                            onLoaded: (composition) {
                              _lottieController.duration = composition.duration;
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.wine_bar_rounded,
                                  size: 55,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'НЭВТРЭХ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Эрдэм номын жимээр хамтдаа урагшилъя!',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ================= 2. ДООД ХЭСЭГ (Цагаан карт) =================
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 25.0),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Нэвтрэх / Бүртгүүлэх шилжих Toggle товч
                          _buildAuthToggle(isLogin: true),
                          const SizedBox(height: 20),

                          // Оюутны код
                          _buildLabel('Оюутны код'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            hintText: 'Оюутны кодоо оруулна уу',
                            icon: Icons.person_outline_rounded,
                            controller: codeController,
                          ),
                          const SizedBox(height: 16),

                          // Нууц үг
                          _buildLabel('Нууц үг'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            hintText: 'Нууц үгээ оруулна уу',
                            icon: Icons.lock_outline_rounded,
                            controller: passwordController,
                            isPassword: true,
                            obscureText: obscurePassword,
                            onTogglePassword: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                                if (obscurePassword) {
                                  _lottieController.reverse();
                                } else {
                                  _lottieController.forward();
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 12),

                          if (loginError != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                loginError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                          // Намайг сана & Нууц үг мартсан
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Checkbox(
                                      value: rememberMe,
                                      activeColor: wine2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          rememberMe = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Намайг сана',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: darkText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              // 👇 Энд дархад Нууц үг сэргээх хуудас руу шилжинэ
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Нууц үгээ мартаад\nбайна уу?',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: wine2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // НЭВТРЭХ Товчлуур
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
                              onPressed: _submitLogin,
                              child: const Text(
                                'НЭВТРЭХ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              onPressed: _loginAsDemo,
                              icon: const Icon(Icons.science_outlined),
                              label: const Text('Демо эрхээр нэвтрэх'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Segmented Toggle Товчлуур
  Widget _buildAuthToggle({required bool isLogin}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: wine1.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [wine1, wine2, wine3]),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: wine2.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Нэвтрэх',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SchoolRegisterScreen(),
                    transitionDuration: Duration.zero,
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Бүртгүүлэх',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: wine3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.bold, color: darkText),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    TextEditingController? controller,
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
        controller: controller,
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
