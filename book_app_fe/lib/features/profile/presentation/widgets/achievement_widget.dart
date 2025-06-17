import 'package:book_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

const achievementLevels = [
  {
    'count': 0,
    'label': '👶 Newbie',
    'desc': 'Finish your first book to earn your first badge.',
  },
  {
    'count': 1,
    'label': '📗 Fresh Reader',
    'desc': 'Congrats for your first finished book!',
  },
  {
    'count': 3,
    'label': '📚 Bookworm',
    'desc': 'You\'ve finished 3 books! Keep it up!',
  },
  {'count': 5, 'label': '🏅 Pro Reader', 'desc': '5 books down, impressive!'},
  {
    'count': 10,
    'label': '🌟 Star Reader',
    'desc': '10 finished books. You\'re a star!',
  },
  {
    'count': 20,
    'label': '🚀 Legend',
    'desc': '20+ books! You\'re a reading legend!',
  },
];

class AchievementWidget extends StatelessWidget {
  final int completedCount;
  const AchievementWidget({super.key, required this.completedCount});

  @override
  Widget build(BuildContext context) {
    var achievement = achievementLevels.first;
    for (final a in achievementLevels) {
      if (completedCount >= (a['count'] as int)) achievement = a;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(45),
        ),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              achievement['label'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              achievement['desc'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              completedCount == 0
                  ? "You haven't finished any books yet."
                  : 'Books finished: $completedCount',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.darkPurple,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
