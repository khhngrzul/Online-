import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'login.dart';

class SchoolRegisterScreen extends StatefulWidget {
  const SchoolRegisterScreen({super.key});

  @override
  State<SchoolRegisterScreen> createState() => _SchoolRegisterScreenState();
}

class _SchoolRegisterScreenState extends State<SchoolRegisterScreen>
    with TickerProviderStateMixin {
  // Wine color palette
  static const Color wine1 = Color(0xFFA2304F);
  static const Color wine2 = Color(0xFF8D1538);
  static const Color wine3 = Color(0xFF790222);
  static const Color wine4 = Color(0xFF5E011C);
  static const Color darkText = Color(0xFF2D3748);
  static const Color mutedText = Color(0xFF94A3B8);
  static const Color borderColor = Color(0xFFEAECEF);
  static const Color background = Color(0xFFF8F7F9);

  final _formKey = GlobalKey<FormState>();

  final surnameController = TextEditingController();
  final nameController = TextEditingController();
  final studentCodeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final customDepartmentController = TextEditingController();

  late final AnimationController _lottieController;
  late final AnimationController _animationController;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  String? selectedCourse;
  String? selectedDepartment;

  final List<String> courseOptions = [
    '1-р курс',
    '2-р курс',
    '3-р курс',
    '4-р курс',
  ];

  final List<String> departmentOptions = [
    'Програм хангамж',
    'Мэдээллийн систем',
    'Санхүү, банк',
    'Маркетинг',
    'НББ',
    'Логистик',
    'Бусад',
  ];

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(vsync: this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _animationController.dispose();

    surnameController.dispose();
    nameController.dispose();
    studentCodeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    customDepartmentController.dispose();

    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    final department = selectedDepartment == 'Бусад'
        ? customDepartmentController.text.trim()
        : selectedDepartment;

    // Backend / Firebase холболтыг энд хийнэ.
    _showMessage('Мэдээлэл амжилттай шалгагдлаа!');

    debugPrint('Овог: ${surnameController.text}');
    debugPrint('Нэр: ${nameController.text}');
    debugPrint('Оюутны код: ${studentCodeController.text}');
    debugPrint('Имэйл: ${emailController.text}');
    debugPrint('Курс: $selectedCourse');
    debugPrint('Тэнхим: $department');
  }

  void _validateOnChange() {
    if (_formKey.currentState == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _formKey.currentState?.validate();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: wine3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wine4,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [wine1, wine2, wine4],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _animationController,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
                ),
                child: Column(
                  children: [
                    _buildHeader(),

                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(34),
                          topRight: Radius.circular(34),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAuthToggle(),

                            const SizedBox(height: 22),

                            _buildSectionTitle(
                              'Хувийн мэдээлэл',
                              'Өөрийн үндсэн мэдээллээ оруулна уу',
                              Icons.person_outline_rounded,
                            ),

                            const SizedBox(height: 14),

                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Овог',
                                    hint: 'Овог',
                                    icon: Icons.person_outline,
                                    controller: surnameController,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Нэр',
                                    hint: 'Нэр',
                                    icon: Icons.person_outline,
                                    controller: nameController,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // ОЮУТНЫ КОД
                            _buildTextField(
                              label: 'Оюутны код',
                              hint: 'Жишээ: sw24d000',
                              icon: Icons.badge_outlined,
                              controller: studentCodeController,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9]'),
                                ),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Оюутны кодоо оруулна уу';
                                }

                                if (!RegExp(r'^[a-zA-Z0-9]{1,10}$')
                                    .hasMatch(value.trim())) {
                                  return '10 хүртэл англи үсэг, тоо оруулна уу';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // И-МЭЙЛ
                            _buildTextField(
                              label: 'И-мэйл хаяг',
                              hint: 'name@example.com',
                              icon: Icons.alternate_email_rounded,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'И-мэйл хаягаа оруулна уу';
                                }

                                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                    .hasMatch(value.trim())) {
                                  return 'И-мэйл хаяг буруу байна';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 22),

                            _buildSectionTitle(
                              'Сургалтын мэдээлэл',
                              'Курс болон тэнхимээ сонгоно уу',
                              Icons.school_outlined,
                            ),

                            const SizedBox(height: 14),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: _buildDropdown(
                                    label: 'Курс',
                                    hint: 'Сонгох',
                                    value: selectedCourse,
                                    items: courseOptions,
                                    icon: Icons.layers_outlined,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCourse = value;
                                      });
                                      _validateOnChange();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 6,
                                  child: _buildDropdown(
                                    label: 'Тэнхим',
                                    hint: 'Сонгох',
                                    value: selectedDepartment,
                                    items: departmentOptions,
                                    icon: Icons.account_tree_outlined,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDepartment = value;

                                        if (value != 'Бусад') {
                                          customDepartmentController.clear();
                                        }
                                      });
                                      _validateOnChange();
                                    },
                                  ),
                                ),
                              ],
                            ),

                            if (selectedDepartment == 'Бусад') ...[
                              const SizedBox(height: 14),
                              _buildTextField(
                                label: 'Бусад тэнхимийн нэр',
                                hint: 'Тэнхимийн нэрээ бичнэ үү',
                                icon: Icons.edit_outlined,
                                controller: customDepartmentController,
                              ),
                            ],

                            const SizedBox(height: 22),

                            _buildSectionTitle(
                              'Нууцлалын мэдээлэл',
                              'Өөрийн нэвтрэх нууц үгийг үүсгэнэ үү',
                              Icons.lock_outline_rounded,
                            ),

                            const SizedBox(height: 14),

                            // НУУЦ ҮГ
                            _buildTextField(
                              label: 'Нууц үг',
                              hint: 'Нууц үгээ оруулна уу',
                              icon: Icons.lock_outline_rounded,
                              controller: passwordController,
                              isPassword: true,
                              obscureText: obscurePassword,
                              onTogglePassword: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Нууц үгээ оруулна уу';
                                }

                                if (value.length < 8) {
                                  return 'Хамгийн багадаа 8 тэмдэгт байна';
                                }

                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return 'Нэг том англи үсэг оруулна уу';
                                }

                                if (!RegExp(r'[a-z]').hasMatch(value)) {
                                  return 'Нэг жижиг англи үсэг оруулна уу';
                                }

                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return 'Нэг тоо оруулна уу';
                                }

                                if (!RegExp(
                                  r"""[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\];~`]""",
                                ).hasMatch(value)) {
                                  return 'Нэг тусгай тэмдэгт оруулна уу';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // НУУЦ ҮГ ДАВТАХ
                            _buildTextField(
                              label: 'Нууц үг давтах',
                              hint: 'Нууц үгээ дахин оруулна уу',
                              icon: Icons.lock_outline_rounded,
                              controller: confirmPasswordController,
                              isPassword: true,
                              obscureText: obscureConfirmPassword,
                              onTogglePassword: () {
                                setState(() {
                                  obscureConfirmPassword =
                                      !obscureConfirmPassword;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Нууц үгээ дахин оруулна уу';
                                }

                                if (value != passwordController.text) {
                                  return 'Нууц үг таарахгүй байна';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 22),

                            // БҮРТГҮҮЛЭХ ТОВЧ
                            _buildRegisterButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return SizedBox(
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Lottie.network(
              'https://lottie.host/1c5d2fa7-c7d6-4def-847f-3111b218d11a/X2w9Je8Z4W.lottie',
              controller: _lottieController,
              fit: BoxFit.contain,
              onLoaded: (composition) {
                _lottieController.duration = composition.duration;
                _lottieController.repeat();
              },
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 38,
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'БҮРТГЭЛ ҮҮСГЭХ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Оюутны бүртгэлийн систем',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // LOGIN / REGISTER TOGGLE
  Widget _buildAuthToggle() {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDF0),
        borderRadius: BorderRadius.circular(18),
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
              child: Center(
                child: Text(
                  'Нэвтрэх',
                  style: TextStyle(
                    color: wine3.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [wine1, wine3]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: wine2.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'Бүртгүүлэх',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION TITLE
  Widget _buildSectionTitle(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF8EEF1),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: wine2, size: 21),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: darkText,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(color: mutedText, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // TEXT FIELD
  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: darkText,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          onChanged: (_) => _validateOnChange(),
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator:
              validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Энэ талбарыг бөглөнө үү';
                }
                return null;
              },
          style: const TextStyle(
            fontSize: 13,
            color: darkText,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: mutedText, fontSize: 12),
            prefixIcon: Icon(icon, color: wine2, size: 19),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onTogglePassword,
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: wine2,
                      size: 19,
                    ),
                  )
                : null,
            filled: true,
            fillColor: background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: wine2, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  // DROPDOWN
  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: darkText,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null) {
              return 'Сонгоно уу';
            }
            return null;
          },
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: wine2),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: wine2, size: 18),
            filled: true,
            fillColor: background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: wine2, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
          hint: Text(
            hint,
            style: const TextStyle(color: mutedText, fontSize: 12),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: darkText),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // REGISTER BUTTON
  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [wine1, wine2, wine3]),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: wine2.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'БҮРТГҮҮЛЭХ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 19),
          ],
        ),
      ),
    );
  }
}
