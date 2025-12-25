import 'package:go_router/go_router.dart';
import 'package:yb_news/features/auth/presentation/reset_password_page.dart';

import '../../features/auth/data/auth_local_storage.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/otp_page.dart';
import '../../features/home/presentation/home_list_page.dart';
import '../../features/auth/presentation/forgot_password_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  redirect: (context, state) {
    final path = state.uri.path;
    final isLoggedIn = AuthLocalStorage.isLoggedIn;
    final needOtp = isLoggedIn && !AuthLocalStorage.isFirstLoginDone;
    final isAuthRoute =
        path == '/login' ||
        path == '/register' ||
        path == '/otp' ||
        path == '/forgot-password' ||
        path == '/reset-password';

    // BELUM LOGIN
    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }

    // PERLU OTP
    if (isLoggedIn && needOtp && path != '/otp') {
      return '/otp';
    }

    // SUDAH LOGIN
    if (isLoggedIn && !needOtp && path == '/login') {
      return '/';
    }

    return null;
  },

  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final email = state.extra;
        if (email == null) {
          return const LoginPage();
        }
        return ResetPasswordPage(email: email as String);
      },
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final email = state.extra;
        if (email == null) {
          return const LoginPage();
        }
        return OtpPage(email: email as String);
      },
    ),
    GoRoute(path: '/', builder: (context, state) => const HomeListPage()),
    // GoRoute(
    //   path: '/news/:id',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id']!;
    //     return NewsDetailPage(id: id);
    //   },
    // ),
  ],
);
