import 'dart:html' as html;

class AuthLocalStorage {
  static const _keyEmail = 'user_email';
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyFirstLoginDone = 'first_login_done';
  static const _keySessionToken = 'session_token';

  static void saveLogin({required String email, required String sessionToken}) {
    html.window.localStorage[_keyEmail] = email;
    html.window.localStorage[_keyLoggedIn] = 'true';
    html.window.localStorage[_keyFirstLoginDone] = 'true';
    html.window.localStorage[_keySessionToken] = sessionToken;
  }

  static bool get isLoggedIn =>
      html.window.localStorage[_keyLoggedIn] == 'true';

  static bool get isFirstLoginDone =>
      html.window.localStorage[_keyFirstLoginDone] == 'true';

  static String? get email => html.window.localStorage[_keyEmail];

  static String? get sessionToken => html.window.localStorage[_keySessionToken];

  static void logout() {
    html.window.localStorage.clear();
  }
}
