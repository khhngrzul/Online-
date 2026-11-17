import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login.dart';

class SchoolRegisterScreen extends StatefulWidget {
  const SchoolRegisterScreen({super.key});

  @override
  State<SchoolRegisterScreen> createState() => _SchoolRegisterScreenState();
}

class _SchoolRegisterScreenState extends State<SchoolRegisterScreen> with TickerProviderStateMixin {
  bool agreeToTerms = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  String? selectedCourse;
  final List<String> courseOptions = ['1-р курс', '2-р курс', '3-р курс', '4-р курс'];

  String? selectedDepartment;
  final List<String> departmentOptions = [
    'Програм хангамж',
    'Мэдээллийн систем',
    'Компьютерийн ухаан',
    'Кибер аюулгүй байдал',
    'Хиймэл оюун ухаан',
    'Бусад',
  ];

  final TextEditingController _customDepartmentController = TextEditingController();
  late final AnimationController _lottieController;

  // 🍷 Wine Color Palette кодууд[cite: 7]
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
    _customDepartmentController.dispose();
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
        child: SafeArea(
          child: Column(
            children: [
              // ================= 1. ДЭЭД ХЭСЭГ =================
              SizedBox(
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 65,
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

              // ================= 2. ДООД ХЭСЭГ (Цагаан карт) =================
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
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
                                  _buildTextField(hintText: 'Овог', icon: Icons.person_outline_rounded),
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
                                  _buildTextField(hintText: 'Нэр', icon: Icons.person_outline_rounded),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // 2. Оюутны код
                        _buildLabel('Оюутны код'),
                        const SizedBox(height: 4),
                        _buildTextField(hintText: 'Оюутны кодоо оруулна уу', icon: Icons.badge_outlined),
                        const SizedBox(height: 12),

                        // 3. И-мэйл хаяг
                        _buildLabel('И-мэйл хаяг'),
                        const SizedBox(height: 4),
                        _buildTextField(
                          hintText: 'name@example.com',
                          icon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),

                        // 4. Курс & Тэнхим
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
                                    onChanged: (val) => setState(() => selectedCourse = val),
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
                                    onChanged: (val) => setState(() => selectedDepartment = val),
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
                            style: const TextStyle(fontSize: 13, color: darkText),
                            decoration: InputDecoration(
                              hintText: 'Тэнхимийн нэрээ бичнэ үү',
                              hintStyle: const TextStyle(color: Colors.black38, fontSize: 12),
                              prefixIcon: const Icon(Icons.edit_outlined, color: wine2, size: 18),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: inputBorderColor, width: 1.2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: inputBorderColor, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: wine2, width: 1.5),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),

                        // 5. Нууц үг
                        _buildLabel('Нууц үг'),
                        const SizedBox(height: 4),
                        _buildTextField(
                          hintText: 'Нууц үгээ оруулна уу',
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

                        // 6. Нууц үг давтах
                        _buildLabel('Нууц үг давтах'),
                        const SizedBox(height: 4),
                        _buildTextField(
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                                'Үйлчилгээний нөхцөл болон Нууцлалын бодлогыг зөвшөөрч байна.',
                                style: TextStyle(fontSize: 11, color: Colors.black87),
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
                            gradient: const LinearGradient(colors: [wine1, wine2, wine3]),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            onPressed: () {},
                            child: const Text(
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: wine3),
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
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
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: darkText),
    );
  }

  Widget _buildTextField({
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
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: wine2,
                    size: 18,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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