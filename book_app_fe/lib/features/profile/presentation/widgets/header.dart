import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/core/constants/colors.dart';

class ProfileHeader extends ConsumerWidget {
  final VoidCallback onEdit;
  final VoidCallback onLogout; // adăugat

  const ProfileHeader({
    super.key,
    required this.onEdit,
    required this.onLogout, // adăugat
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My account',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.darkPurple,
            ),
          ),
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.darkPurple,
              size: 27,
            ),
            onSelected: (value) async {
              if (value == 0) {
                onEdit();
              } else if (value == 1) {
                onLogout();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.darkPurple,
                          ),
                        ),
                        Icon(Icons.edit, size: 22, color: AppColors.darkPurple),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(height: 1),
                  const PopupMenuItem(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.darkPurple,
                          ),
                        ),
                        Icon(
                          Icons.logout,
                          size: 22,
                          color: AppColors.darkPurple,
                        ),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }
}
