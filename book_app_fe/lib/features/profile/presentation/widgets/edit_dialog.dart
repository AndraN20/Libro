import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:book_app/core/constants/colors.dart';

class EditProfileDialog extends StatelessWidget {
  final Uint8List? newImage;
  final TextEditingController usernameCtrl;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onImagePick;

  const EditProfileDialog({
    super.key,
    required this.newImage,
    required this.usernameCtrl,
    required this.onSave,
    required this.onCancel,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primary,
      title: const Text(
        'Edit Profile',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onImagePick,
            child: CircleAvatar(
              radius: 40,
              backgroundImage:
                  newImage != null
                      ? MemoryImage(newImage!)
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: usernameCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.darkPurple,
          ),
          onPressed: onSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
