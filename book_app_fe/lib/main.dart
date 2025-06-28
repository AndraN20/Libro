import 'package:book_app/core/storage/secure_storage.dart';
import 'package:book_app/core/theme/app_theme.dart';
import 'package:book_app/routing/app_router.dart';
import 'package:book_app/core/utils/token_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final token = await SecureStorage.readToken();
  if (token == null || isTokenExpired(token)) {
    await SecureStorage.deleteToken();
  }

  runApp(ProviderScope(child: BookApp()));
}

class BookApp extends ConsumerWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      title: 'Book App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
