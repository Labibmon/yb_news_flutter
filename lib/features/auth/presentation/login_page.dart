import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/fake_auth_api.dart';
import '../data/auth_local_storage.dart';
import '../data/otp_manager.dart';
import '../data/smtp_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text;

    // 🚫 Cegah multi device
    if (FakeAuthApi.hasActiveSession(email)) {
      _showError('User already logged in on another device');
      return;
    }

    final isFirstLoginDone = AuthLocalStorage.isFirstLoginDone;

    if (!isFirstLoginDone) {
      // FIRST LOGIN → OTP
      // final otp = OtpManager.generateOtp();
      context.go('/otp', extra: email);
      // try {
      //   await SmtpService.sendOtpEmail(toEmail: email, otp: otp);

      // } catch (e) {
      //   _showError('Failed to send OTP email');
      // }
    } else {
      // ALREADY LOGIN → HOME
      final token = FakeAuthApi.createSession(email);

      AuthLocalStorage.saveLogin(email: email, sessionToken: token);

      context.go('/news');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 425),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Right Dot
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Hello',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        // decoration: TextDecoration.underline,
                        decorationThickness: 3,
                        decorationColor: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Again!',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        // decoration: TextDecoration.underline,
                        decorationThickness: 3,
                        decorationColor: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Welcome back you’ve been missed",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),

                    const SizedBox(height: 32),

                    // FORM
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email*',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!value.contains('@')) {
                                return 'Invalid email format';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            'Password*',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: _inputDecoration().copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Remember + Forgot
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                              const Text('Remember me'),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  // TODO: Forgot Password
                                },
                                child: const Text('Forgot the password ?'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // LOGIN BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Divider
                          const Center(
                            child: Text(
                              'or continue with',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // GOOGLE BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Google Login
                              },
                              icon: Image.network(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2GfSXVwTL3Ojtaw7QXdg_A-sTAu4QoCp59A&s',
                                width: 20,
                              ),
                              label: const Text('Google'),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // SIGN UP
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("don’t have an account ? "),
                              GestureDetector(
                                onTap: () {
                                  context.go('/register');
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }
}
