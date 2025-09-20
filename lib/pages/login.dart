import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    final input = _userController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter email or mobile number",
          ),
        ),
      );
      return;
    }
    debugPrint("Sending OTP to $input");
  }

  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter a valid 6-digit OTP",
          ),
        ),
      );
      return;
    }

    debugPrint("Verifying OTP: $otp");

    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: scheme
                        .outlineVariant
                        .withValues(
                          alpha: 51,
                        ), // 20%
                    child: Icon(
                      Icons.person_outline,
                      size: 48,
                      color: scheme.outline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller:
                              _userController,
                          keyboardType:
                              TextInputType
                                  .emailAddress,
                          decoration: InputDecoration(
                            hintText:
                                'Email or Mobile number',
                            contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 16,
                                ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                            ),
                          ),
                          style:
                              GoogleFonts.inter(
                                fontSize: 16,
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _sendOtp,
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                            ),
                          ),
                          child: const Text(
                            'Get OTP',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _otpController,
                    keyboardType:
                        TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Enter OTP',
                      contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                      ),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                        ),
                      ),
                      child: const Text('LOGIN'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                      ),
                    ),
                    child: const Text(
                      'NEW REGISTRATION',
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                      ),
                    ),
                    child: const Text(
                      'Back to User Selection Screen',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Facing any issue ? Contact Support',
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

// Temporary HomePage placeholder
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Welcome to the Home Page'),
      ),
    );
  }
}
