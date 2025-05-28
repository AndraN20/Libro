import 'package:book_app/config/constants.dart';
import 'package:book_app/providers/is_logged_in_provider.dart';
import 'package:book_app/ui/auth/widgets/login_screen.dart';
import 'package:book_app/ui/books/widgets/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedInAsync = ref.watch(isLoggedInProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteNames.loading,
    routes: [
      GoRoute(path: RouteNames.home, builder: (_, __) => const HomeScreen()),
      GoRoute(path: RouteNames.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: RouteNames.loading,
        builder:
            (_, __) => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
      ),
    ],
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == RouteNames.login;
      final isInitialLoading = state.matchedLocation == RouteNames.loading;

      return isLoggedInAsync.when(
        loading: () => isInitialLoading ? null : RouteNames.loading,
        error: (_, __) => RouteNames.login,
        data: (isLoggedIn) {
          if (isInitialLoading) {
            return isLoggedIn ? RouteNames.home : RouteNames.login;
          }
          if (!isLoggedIn && !isLoggingIn) return RouteNames.login;
          if (isLoggedIn && isLoggingIn) return RouteNames.home;
          return null;
        },
      );
    },
  );
});
