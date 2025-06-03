import 'dart:typed_data';
import 'package:book_app/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:book_app/core/constants/colors.dart';

class ProfileBody extends StatelessWidget {
  final User user;
  final Uint8List? newProfileImage;

  const ProfileBody({super.key, required this.user, this.newProfileImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.grey,
                backgroundImage:
                    user.profilePictureBase64 != null &&
                            user.profilePictureBase64!.isNotEmpty
                        ? MemoryImage(user.profilePictureBase64!)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
              ),
              const SizedBox(height: 15),
              Text(
                '${user.username} 📚',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPurple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
