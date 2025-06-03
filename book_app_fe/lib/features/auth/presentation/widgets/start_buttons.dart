import 'package:flutter/material.dart';

class StartButtons extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  const StartButtons({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        _buildActionButton('Get Started', onTap: onGetStarted),
        const SizedBox(height: 10),
        _buildActionButton('Sign In', onTap: onSignIn, filled: false),
      ],
    );
  }

  Widget _buildActionButton(
    String text, {
    required VoidCallback onTap,
    bool filled = true,
  }) {
    return SizedBox(
      width: 250,
      height: 48,
      child:
          filled
              ? ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFED766),
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(text),
              )
              : OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(text),
              ),
    );
  }
}
