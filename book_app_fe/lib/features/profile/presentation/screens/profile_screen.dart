import 'package:book_app/features/profile/presentation/widgets/body.dart';
import 'package:book_app/features/profile/presentation/widgets/book_slide.dart';
import 'package:book_app/features/profile/presentation/widgets/header.dart';
import 'package:book_app/features/profile/presentation/widgets/section_title.dart';
import 'package:book_app/features/profile/presentation/widgets/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:book_app/features/auth/presentation/viewmodels/auth_provider.dart';
import 'package:book_app/core/constants/colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Uint8List? newProfileImage;

  Future<void> _pickNewImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        newProfileImage = bytes;
      });
    }
  }

  void _showEditDialog() {
    final user = ref.read(currentUserProvider).value;
    final usernameCtrl = TextEditingController(text: user?.username ?? '');

    showDialog(
      context: context,
      builder: (context) {
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
                onTap: _pickNewImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      newProfileImage != null
                          ? MemoryImage(newProfileImage!)
                          : (user?.profilePictureBase64 != null
                              ? MemoryImage(user!.profilePictureBase64!)
                              : const AssetImage('assets/default_profile.png')
                                  as ImageProvider),
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.darkPurple,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (user) {
            if (user == null)
              return const Center(child: Text("User not found"));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                ProfileHeader(
                  onEdit: _showEditDialog,
                  onLogout: () async {
                    await ref.read(authViewModelProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
                const SizedBox(height: 15),
                ProfileBody(user: user),
                const SizedBox(height: 20),
                const StatsCard(),
                const SizedBox(height: 30),
                const SectionTitle(title: "Favourite Books"),
                const SizedBox(height: 10),
                const BookSlide(),
                const SizedBox(height: 30),
                const SectionTitle(title: "My List"),
                const SizedBox(height: 10),
                const BookSlide(),
              ],
            );
          },
        ),
      ),
    );
  }
}
