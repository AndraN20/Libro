import 'package:book_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _navItems = [
    {
      'label': 'Home',
      'active': 'assets/icons/home_color.svg',
      'inactive': 'assets/icons/home_grey.svg',
    },
    {
      'label': 'Library',
      'active': 'assets/icons/library_color.svg',
      'inactive': 'assets/icons/library_grey.svg',
    },
    {
      'label': 'Search',
      'active': 'assets/icons/search_color.svg',
      'inactive': 'assets/icons/search_grey.svg',
    },
    {
      'label': 'Profile',
      'active': 'assets/icons/profile_color.svg',
      'inactive': 'assets/icons/profile_grey.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.white,
      currentIndex: selectedIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items:
          _navItems.map((item) {
            final isActive = _navItems.indexOf(item) == selectedIndex;
            final iconPath = isActive ? item['active']! : item['inactive']!;
            return BottomNavigationBarItem(
              icon: SvgPicture.asset(iconPath, width: 24, height: 24),
              label: '',
            );
          }).toList(),
    );
  }
}
