import 'package:book_app/core/constants/navigation_keys.dart';
import 'package:book_app/core/constants/route_names.dart';
import 'package:book_app/core/providers/is_logged_in_provider.dart';
import 'package:book_app/core/providers/route_observer_provider.dart';
import 'package:book_app/core/screens/main_screen.dart';
import 'package:book_app/features/auth/presentation/screens/login_screen.dart';
import 'package:book_app/features/books/domain/models/book.dart';
import 'package:book_app/features/books/presentation/screens/book_details_screen.dart';
import 'package:book_app/features/home/presentation/screens/home_screen.dart';
import 'package:book_app/features/library/presentation/screens/library_screen.dart';
import 'package:book_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:book_app/features/reader/presentation/screens/epub_reader_web_view.dart';
import 'package:book_app/features/search/presentation/screens/search_page.dart';
import 'package:book_app/features/summary/presentation/screens/summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedInAsync = ref.watch(isLoggedInProvider);
  final routeObserver = ref.watch(routeObserverProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    observers: [routeObserver],
    initialLocation: RouteNames.loading,
    routes: [
      GoRoute(path: RouteNames.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: RouteNames.loading,
        builder:
            (_, __) => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
      ),
      GoRoute(
        path: '/epub-reader',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EpubReaderWebView(
            epubFilePath: extra['filePath'] as String,
            initialCfi: extra['initialCfi'] as String? ?? "",
            bookId: extra['bookId'] as int,
            hasProgress: extra['hasProgress'] as bool? ?? false,
          );
        },
      ),
      GoRoute(
        path: '/recap',
        name: 'recap',
        builder: (context, state) {
          final String bookText = state.extra as String;
          return SummaryScreen(bookText: bookText);
        },
      ),

      ShellRoute(
        builder: (_, __, child) => MainScreen(child: child),
        routes: [
          GoRoute(path: '/', redirect: (_, __) => '/home'),
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/library', builder: (_, __) => const LibraryScreen()),
          GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(
            path: '/book-details',
            builder: (context, state) {
              final book = state.extra as Book;
              return BookDetailsScreen(book: book);
            },
          ),
        ],
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
