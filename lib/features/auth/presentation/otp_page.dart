import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/otp_manager.dart';
import '../data/auth_local_storage.dart';
import '../data/fake_auth_api.dart';
import '../data/smtp_service.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  Timer? _timer;
  int _remainingSeconds = 56;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String get _otpCode => _controllers.map((e) => e.text).join();

  void _verifyOtp() {
    if (_otpCode.length != 4) {
      _showError('Please enter complete OTP');
      return;
    }

    final email = widget.email;

    if (OtpManager.verifyOtp(email, _otpCode)) {
      OtpManager.clearOtp(email);
      AuthLocalStorage.saveLogin(
        email: email,
        sessionToken: FakeAuthApi.createSession(email),
      );
      if (!mounted) return;
      context.go('/');
    } else {
      _showError('Invalid OTP, please try again');
    }
  }

  void _resendOtp() {
    final email = widget.email;

    final otp = OtpManager.generateOtp();
    OtpManager.saveOtp(email, otp);
    SmtpService.sendOtpEmail(toEmail: email, otp: otp);
    setState(() => _remainingSeconds = 56);
    _startTimer();
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 425),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BACK BUTTON
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),

                  const SizedBox(height: 24),

                  // TITLE
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'OTP Verification',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Enter the OTP sent to your email',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // OTP INPUT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (index) => _OtpBox(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // RESEND
                  Center(
                    child: _canResend
                        ? TextButton(
                            onPressed: _resendOtp,
                            child: const Text(
                              'Resend code',
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        : Text(
                            'Resend code in ${_remainingSeconds}s',
                            style: const TextStyle(color: Colors.red),
                          ),
                  ),

                  const Spacer(),

                  // VERIFY BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _otpCode.length == 4 ? _verifyOtp : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
