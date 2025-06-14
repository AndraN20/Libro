import 'package:book_app/core/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  int _calculateIndex(String location) {
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/search')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; // default to home
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    final hideNavBar = location.startsWith('/epub-reader');

    return Scaffold(
      body: child,
      bottomNavigationBar:
          hideNavBar
              ? null
              : CustomNavBar(
                selectedIndex: _calculateIndex(location),
                onTap: (index) {
                  switch (index) {
                    case 0:
                      context.go('/home');
                      break;
                    case 1:
                      context.go('/library');
                      break;
                    case 2:
                      context.go('/search');
                      break;
                    case 3:
                      context.go('/profile');
                      break;
                  }
                },
              ),
    );
  }
}
