import 'package:book_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double percentage;

  const ProgressBar({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      // padding pe stânga/dreapta, ca fill-ul și track-ul să aibă spațiu
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Bară + fill într-un Expanded
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // TRACK: full width
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.lightPurple,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // FILL: procentual
                FractionallySizedBox(
                  widthFactor: percentage.clamp(0.0, 1.0),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.darkPurple,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8), // spațiu între bară și text
          // Text procent
          Text(
            '${(percentage * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
