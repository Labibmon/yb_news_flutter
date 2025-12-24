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
      headers: {
        'Authorization': 'Bearer ${SmtpConfig.apiToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "from": {
          "email": SmtpConfig.senderEmail,
          "name": SmtpConfig.senderName,
        },
        "to": [
          {"email": toEmail},
        ],
        "subject": "Your OTP Code - YB News",
        "text": "Your OTP code is: $otp\nThis code is valid for 3 minutes.",
        "html":
            """
          <h2>YB News OTP Verification</h2>
          <p>Your OTP code is:</p>
          <h1>$otp</h1>
          <p>This code is valid for <b>3 minutes</b>.</p>
        """,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP email');
    }
  }
}
