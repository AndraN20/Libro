import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:book_app/core/constants/colors.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.only(left: 35.0),
          child: Text(
            'Welcome back !',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ).copyWith(color: AppColors.darkPurple),
          ),
        ),
        Center(
          child: SvgPicture.asset(
            'assets/welcome_back_card.svg',
            width: MediaQuery.of(context).size.width * 0.90,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
