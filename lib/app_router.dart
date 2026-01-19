import 'package:go_router/go_router.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/module/dashboard/dashboard_page.dart';
import 'package:mobile_info/module/menu_page/menu_page.dart';
import 'package:mobile_info/module/splash_screen_page.dart';
import 'services/auth_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) async {
    final loggedIn = await AuthService.isLoggedIn();
    final loggingIn = state.matchedLocation == '/login';

    if (!loggedIn && !loggingIn) return '/login';
    // if (loggedIn && loggingIn) return '/dashboard';

    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreenPage()),
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    // GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
    GoRoute(path: '/menu', builder: (_, __) => const MenuPage()),
  ],
);
