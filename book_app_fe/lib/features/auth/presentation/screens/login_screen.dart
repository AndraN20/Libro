import 'package:book_app/core/constants/colors.dart';
import 'package:book_app/features/auth/presentation/viewmodels/auth_provider.dart';
import 'package:book_app/features/auth/presentation/widgets/login_form.dart';
import 'package:book_app/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:book_app/features/auth/presentation/widgets/start_buttons.dart';
import 'package:book_app/features/user/presentation/viewmodels/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

enum AuthMode { start, login, signup }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  AuthMode _mode = AuthMode.start;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(
                      context,
                    ).viewInsets.bottom, // se adaptează la tastatură
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, AppColors.darkPurple],
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          child: SvgPicture.asset(
                            'assets/login_register_drawing.svg',
                            width: double.infinity,
                            height: 500,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 30.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Libro',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkPurple,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Flexible(child: _buildForm()),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    switch (_mode) {
      case AuthMode.login:
        return LoginForm(
          emailCtrl: emailCtrl,
          passwordCtrl: passwordCtrl,
          onLogin: _onLoginPressed,
        );
      case AuthMode.signup:
        return SignupForm(
          usernameCtrl: usernameCtrl,
          emailCtrl: emailCtrl,
          passwordCtrl: passwordCtrl,
          onSignup: _onSignupPressed,
        );
      case AuthMode.start:
        return StartButtons(
          onGetStarted: () => setState(() => _mode = AuthMode.signup),
          onSignIn: () => setState(() => _mode = AuthMode.login),
        );
    }
  }

  Future<void> _onLoginPressed() async {
    final auth = ref.read(authViewModelProvider.notifier);
    final success = await auth.login(emailCtrl.text, passwordCtrl.text);
    if (!mounted) return;

    if (success) {
      ref.invalidate(fetchedUserProvider);

      context.go('/home');
    } else {
      _showSnackBar('Login failed');
    }
  }

  Future<void> _onSignupPressed() async {
    final auth = ref.read(authViewModelProvider.notifier);
    final didSignup = await auth.signup(
      usernameCtrl.text,
      emailCtrl.text,
      passwordCtrl.text,
    );
    if (!mounted) return;

    if (didSignup) {
      final didLogin = await auth.login(emailCtrl.text, passwordCtrl.text);
      if (!mounted) return;

      if (didLogin) {
        ref.invalidate(fetchedUserProvider);
        context.go('/home');
      } else {
        _showSnackBar('Account created, but login failed');
      }
    } else {
      _showSnackBar('Sign up failed');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
