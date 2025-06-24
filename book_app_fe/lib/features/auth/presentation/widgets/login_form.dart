import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.onLogin,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool get isEmailValid => RegExp(
    r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$",
  ).hasMatch(widget.emailCtrl.text);

  bool get isFormValid =>
      widget.emailCtrl.text.isNotEmpty &&
      widget.passwordCtrl.text.isNotEmpty &&
      isEmailValid;

  @override
  void initState() {
    super.initState();
    widget.emailCtrl.addListener(_onChange);
    widget.passwordCtrl.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.emailCtrl.removeListener(_onChange);
    widget.passwordCtrl.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInput(
          widget.emailCtrl,
          'Email',
          error:
              isEmailValid || widget.emailCtrl.text.isEmpty
                  ? null
                  : 'Invalid email',
        ),
        _buildInput(widget.passwordCtrl, 'Password', obscure: true),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: isFormValid ? widget.onLogin : null,
          child: const Text('Sign In'),
        ),
      ],
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    String? error,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: SizedBox(
          width: 300,
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: label,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              errorText: error,
            ),
          ),
        ),
      ),
    );
  }
}
