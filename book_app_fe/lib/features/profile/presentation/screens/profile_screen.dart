import 'dart:typed_data';
import 'package:book_app/features/profile/presentation/widgets/body.dart';
import 'package:book_app/features/profile/presentation/widgets/book_slide.dart';
import 'package:book_app/features/profile/presentation/widgets/edit_dialog.dart';
import 'package:book_app/features/profile/presentation/widgets/header.dart';
import 'package:book_app/features/profile/presentation/widgets/section_title.dart';
import 'package:book_app/features/profile/presentation/widgets/stats_card.dart';
import 'package:book_app/features/user/presentation/viewmodels/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_app/features/auth/presentation/viewmodels/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _showEditDialog() {
    final user = ref.watch(fetchedUserProvider).asData?.value;
    final usernameCtrl = TextEditingController(text: user?.username ?? '');
    final isLoading = ref.watch(userViewModelProvider) is AsyncLoading;

    Uint8List? newProfileImage;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _pickNewImage() async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (picked != null) {
                final bytes = await picked.readAsBytes();
                setState(() {
                  newProfileImage = bytes;
                });
              }
            }

            return EditProfileDialog(
              newImage: newProfileImage,
              usernameCtrl: usernameCtrl,
              onImagePick: _pickNewImage,
              onCancel: () => Navigator.of(context).pop(),
              onSave: () async {
                await ref
                    .read(userViewModelProvider.notifier)
                    .updateUser(
                      username: usernameCtrl.text.trim(),
                      profilePicture: newProfileImage,
                    );
                ref.invalidate(fetchedUserProvider);
                setState(() {});
                if (context.mounted) Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              },
              isLoading: isLoading,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(fetchedUserProvider);

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
