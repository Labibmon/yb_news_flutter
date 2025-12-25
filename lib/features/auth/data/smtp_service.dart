import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/smtp_config.dart';

class SmtpService {
  static Future<void> sendOtpEmail({
    required String toEmail,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse(SmtpConfig.apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'toEmail': toEmail,
        'subject': 'Your OTP Code',
        'text': 'Your OTP code is: $otp',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP email: ${response.body}');
    }
  }
}
