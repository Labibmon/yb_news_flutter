import 'dart:math';

class FakeAuthApi {
  static final Map<String, String> _activeSessions = {};

  static String _generateSessionToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    final rand = Random();
    return List.generate(20, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  static bool hasActiveSession(String email) {
    return _activeSessions.containsKey(email);
  }

  static String createSession(String email) {
    final token = _generateSessionToken();
    _activeSessions[email] = token;
    return token;
  }

  static void removeSession(String email) {
    _activeSessions.remove(email);
  }
}
