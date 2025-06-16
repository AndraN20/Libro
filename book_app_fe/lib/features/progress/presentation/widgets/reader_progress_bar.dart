import 'dart:ui';

import 'package:book_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

class BookProgressBar extends StatelessWidget {
  final String chapter;
  final int page;
  final int totalPages;
  final double percentage;
  final VoidCallback onBookRecap;
  final VoidCallback onChapters;
  // ... restul

  const BookProgressBar({
    super.key,
    required this.chapter,
    required this.page,
    required this.totalPages,
    required this.percentage,
    required this.onBookRecap,
    required this.onChapters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chapter.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                chapter,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          Row(
            children: [
              Text(
                "Page $page of $totalPages",
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              const Spacer(),
              Text(
                "${(percentage * 100).toStringAsFixed(0)}%",
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[200],
            color: AppColors.primary,
            minHeight: 5,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: onBookRecap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  "Book recap",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.list_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
                onPressed: onChapters,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
