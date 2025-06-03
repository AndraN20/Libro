import 'package:flutter/material.dart';

class SignupForm extends StatelessWidget {
  final TextEditingController usernameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final VoidCallback onSignup;

  const SignupForm({
    super.key,
    required this.usernameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.onSignup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInput(usernameCtrl, 'Username'),
        _buildInput(emailCtrl, 'Email'),
        _buildInput(passwordCtrl, 'Password', obscure: true),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: onSignup, child: const Text('Sign Up')),
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
