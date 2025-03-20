import 'package:go_router/go_router.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/register_page.dart';
import '../screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
    ],
    redirect: (context, state) async {
      final loggedIn = await isLoggedIn();
      final goingToLogin = state.matchedLocation == '/login';
      final goingToRegister = state.matchedLocation == '/register';

      if (!loggedIn && !goingToLogin && !goingToRegister) {
        return '/login';
      }
      if (loggedIn && (goingToLogin || goingToRegister)) {
        return '/home';
      }
      return null;
    },
  );
}
