import 'dart:math';

class OtpManager {
  static String? _otp;
  static DateTime? _expiredAt;

  static String generateOtp() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();

    _otp = List.generate(8, (_) => chars[rand.nextInt(chars.length)]).join();

    _expiredAt = DateTime.now().add(const Duration(minutes: 3));
    return _otp!;
  }

  static bool verify(String input) {
    if (_otp == null || _expiredAt == null) return false;

    if (DateTime.now().isAfter(_expiredAt!)) {
      throw Exception('OTP expired');
    }

    return _otp == input;
  }
}
