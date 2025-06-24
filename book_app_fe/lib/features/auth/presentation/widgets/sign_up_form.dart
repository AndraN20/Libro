import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
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
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String? emailError;
  String? passwordError;
  bool get isEmailValid => RegExp(
    r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$",
  ).hasMatch(widget.emailCtrl.text);

  bool get isPasswordValid => widget.passwordCtrl.text.length >= 8;

  bool get isFormValid =>
      widget.usernameCtrl.text.isNotEmpty && isEmailValid && isPasswordValid;

  void _validate() {
    setState(() {
      emailError = isEmailValid ? null : 'Invalid email';
      passwordError =
          isPasswordValid ? null : 'Password must be at least 8 characters';
    });
  }

  @override
  void initState() {
    super.initState();
    widget.emailCtrl.addListener(_validate);
    widget.passwordCtrl.addListener(_validate);
    widget.usernameCtrl.addListener(_validate);
  }

  @override
  void dispose() {
    widget.emailCtrl.removeListener(_validate);
    widget.passwordCtrl.removeListener(_validate);
    widget.usernameCtrl.removeListener(_validate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInput(widget.usernameCtrl, 'Username'),
        _buildInput(widget.emailCtrl, 'Email', error: emailError),
        _buildInput(
          widget.passwordCtrl,
          'Password',
          obscure: true,
          error: passwordError,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: isFormValid ? widget.onSignup : null,
          child: const Text('Sign Up'),
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
