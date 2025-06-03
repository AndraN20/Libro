import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInput(emailCtrl, 'Email'),
        _buildInput(passwordCtrl, 'Password', obscure: true),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: onLogin, child: const Text('Sign In')),
      ],
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label, {
    bool obscure = false,
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
            ),
          ),
        ),
      ),
    );
  }
}
