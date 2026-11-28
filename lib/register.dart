import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'nevtreh.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api.dart';

class SchoolRegisterScreen extends StatefulWidget {
  const SchoolRegisterScreen({super.key});

  @override
  State<SchoolRegisterScreen> createState() => _SchoolRegisterScreenState();
}

class _SchoolRegisterScreenState extends State<SchoolRegisterScreen>
    with TickerProviderStateMixin {
  bool agreeToTerms = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool _loading = false;

  String? selectedCourse;
  final List<String> courseOptions = [
    '1-р курс',
    '2-р курс',
    '3-р курс',
    '4-р курс'
  ];

  String? selectedDepartment;
  final List<String> departmentOptions = [
    'Програм хангамж',
    'Мэдээллийн систем',
    'Компьютерийн ухаан',
    'Кибер аюулгүй байдал',
    'Хиймэл оюун ухаан',
    'Бусад',
  ];

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _customDepartmentController =
      TextEditingController();
  late final AnimationController _lottieController;

  // 🍷 Wine Color Palette
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

  @override
  void dispose() {
    _lottieController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _customDepartmentController.dispose();
    super.dispose();
  }

  void _msg(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _submit() async {
    if (_lastNameController.text.trim().isEmpty ||
        _firstNameController.text.trim().isEmpty ||
        _codeController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _msg('Бүх талбарыг бөглөнө үү');
      return;
    }
    if (_passwordController.text.length < 8) {
      _msg('Нууц үг хамгийн багадаа 8 тэмдэгт байна');
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      _msg('Нууц үг таарахгүй байна');
      return;
    }
    if (!agreeToTerms) {
      _msg('Үйлчилгээний нөхцөлийг зөвшөөрнө үү');
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await http.post(
        Uri.parse('${Api.base}/api/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'last_name': _lastNameController.text.trim(),
          'first_name': _firstNameController.text.trim(),
          'student_code': _codeController.text.trim(),
          'phone_number': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );
      final body = utf8.decode(response.bodyBytes);
      debugPrint('хариу: ${response.statusCode} $body');
      if (!mounted) return;

      if (response.statusCode == 201) {
        _msg('Амжилттай бүртгэгдлээ');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SchoolLoginScreen()),
        );
      } else {
        _msg('Алдаа (${response.statusCode}): $body');
      }
    } catch (e) {
      debugPrint('АЛДАА: $e');
      if (mounted) _msg('Сервертэй холбогдож чадсангүй: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
        child: SafeArea(
          child: Column(
            children: [
              // ================= 1. ДЭЭД ХЭСЭГ =================
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Lottie.network(
                        'https://lottie.host/1c5d2fa7-c7d6-4def-847f-3111b218d11a/X2w9Je8Z4W.lottie',
                        controller: _lottieController,
                        fit: BoxFit.contain,
                        onLoaded: (composition) {
                          _lottieController.duration = composition.duration;
                          _lottieController.repeat();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person_add_alt_1_rounded,
                            size: 40,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'БҮРТГЭЛ ҮҮСГЭХ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Оюутны мэдээллээ бүрэн оруулна уу',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
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
                        // Нэвтрэх / Бүртгүүлэх шилжих Toggle товч
                        _buildAuthToggle(isLogin: false),
                        const SizedBox(height: 16),

                        // 1. Овог болон Нэр
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Овог'),
                                  const SizedBox(height: 4),
                                  _buildTextField(
                                      controller: _lastNameController,
                                      hintText: 'Овог',
                                      icon: Icons.person_outline_rounded),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Нэр'),
                                  const SizedBox(height: 4),
                                  _buildTextField(
                                      controller: _firstNameController,
                                      hintText: 'Нэр',
                                      icon: Icons.person_outline_rounded),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // 2. Оюутны код
                        _buildLabel('Оюутны код'),
                        const SizedBox(height: 4),
                        _buildTextField(
                            controller: _codeController,
                            hintText: 'Оюутны кодоо оруулна уу',
                            icon: Icons.badge_outlined),
                        const SizedBox(height: 12),

                        // 3. Утасны дугаар
                        _buildLabel('Утасны дугаар'),
                        const SizedBox(height: 4),
                        _buildTextField(
                          controller: _phoneController,
                          hintText: 'Утасны дугаараа оруулна уу',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),

                        // 4. И-мэйл хаяг
                        _buildLabel('И-мэйл хаяг'),
                        const SizedBox(height: 4),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'name@example.com',
                          icon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),

                        // 5. Курс & Тэнхим
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Курс'),
                                  const SizedBox(height: 4),
                                  _buildDropdown(
                                    hintText: 'Сонгох',
                                    value: selectedCourse,
                                    items: courseOptions,
                                    onChanged: (val) =>
                                        setState(() => selectedCourse = val),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Тэнхим'),
                                  const SizedBox(height: 4),
                                  _buildDropdown(
                                    hintText: 'Тэнхим сонгох',
                                    value: selectedDepartment,
                                    items: departmentOptions,
                                    onChanged: (val) => setState(
                                        () => selectedDepartment = val),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Хэрэв "Бусад" сонгогдвол гарч ирэх TextField
                        if (selectedDepartment == 'Бусад') ...[
                          const SizedBox(height: 12),
                          _buildLabel('Бусад тэнхимийн нэр'),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _customDepartmentController,
                            style:
                                const TextStyle(fontSize: 13, color: darkText),
                            decoration: InputDecoration(
                              hintText: 'Тэнхимийн нэрээ бичнэ үү',
                              hintStyle: const TextStyle(
                                  color: Colors.black38, fontSize: 12),
                              prefixIcon: const Icon(Icons.edit_outlined,
                                  color: wine2, size: 18),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: inputBorderColor, width: 1.2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: inputBorderColor, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: wine2, width: 1.5),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),

                        // 6. Нууц үг
                        _buildLabel('Нууц үг'),
                        const SizedBox(height: 4),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: 'Нууц үгээ оруулна уу (8+ тэмдэгт)',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          obscureText: obscurePassword,
                          onTogglePassword: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 12),

                        // 7. Нууц үг давтах
                        _buildLabel('Нууц үг давтах'),
                        const SizedBox(height: 4),
                        _buildTextField(
                          controller: _confirmController,
                          hintText: 'Нууц үгээ дахин оруулна уу',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                          obscureText: obscureConfirmPassword,
                          onTogglePassword: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                        const SizedBox(height: 12),

                        // Үйлчилгээний нөхцөл Checkbox
                        Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                value: agreeToTerms,
                                activeColor: wine2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onChanged: (value) {
                                  setState(() {
                                    agreeToTerms = value ?? false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Үйлчилгээний нөхцөлийг зөвшөөрч байна',
                                style:
                                    TextStyle(fontSize: 12, color: darkText),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // БҮРТГҮҮЛЭХ Товчлуур
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [wine1, wine2, wine3]),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: wine2.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            onPressed: _loading ? null : _submit,
                            child: _loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'БҮРТГҮҮЛЭХ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
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

  // Segmented Toggle Товчлуур
  Widget _buildAuthToggle({required bool isLogin}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: wine1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SchoolLoginScreen(),
                    transitionDuration: Duration.zero,
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Нэвтрэх',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: wine3),
                ),
              ),
            ),
          ),
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
                      color: wine2.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Бүртгүүлэх',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
          fontSize: 12, fontWeight: FontWeight.bold, color: darkText),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
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
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, color: darkText),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 12),
          prefixIcon: Icon(icon, color: wine2, size: 18),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: wine2,
                    size: 18,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: inputBorderColor, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        hint: Text(
          hintText,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black38, fontSize: 12),
        ),
        icon: const Padding(
          padding: EdgeInsets.only(right: 6.0),
          child: Icon(Icons.keyboard_arrow_down, color: wine2, size: 18),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12.5, color: darkText),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}