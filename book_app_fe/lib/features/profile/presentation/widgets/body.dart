import 'dart:typed_data';
import 'package:book_app/features/user/domain/entities/user.dart';
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
                    newProfileImage != null
                        ? MemoryImage(newProfileImage!)
                        : (user.profilePictureBase64 != null
                            ? MemoryImage(user.profilePictureBase64!)
                            : const AssetImage('assets/default_profile.png')),
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
