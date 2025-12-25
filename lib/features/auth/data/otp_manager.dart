import 'dart:math';

class OtpManager {
  static final Map<String, String> _otpStorage = {}; // email -> OTP
  
  static void saveOtp(String email, String otp) {
    _otpStorage[email] = otp;
  }

  static bool verifyOtp(String email, String otp) {
    return _otpStorage[email] == otp;
  }

  static void clearOtp(String email) {
    _otpStorage.remove(email);
  }
  
  static String generateOtp({int length = 4}) {
    final random = Random();
    String otp = '';

    for (int i = 0; i < length; i++) {
      otp += random.nextInt(10).toString(); // random digit 0-9
    }

    return otp;
  }
}
