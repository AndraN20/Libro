import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // value between 0.0 and 1.0

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Grey full background bar
          Container(
            height: 6,
            margin: const EdgeInsets.only(right: 40),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Purple progress bar
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: 6,
              margin: const EdgeInsets.only(right: 40),
              decoration: BoxDecoration(
                color: const Color(0xFF5F5BD1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // Percentage text
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
