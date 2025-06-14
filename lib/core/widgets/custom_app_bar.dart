import 'package:flutter/material.dart';

import '../constants/app_string.dart';
import '../constants/colors.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    this.title = "Scheme Management"
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.newPrimaryColor,
      automaticallyImplyLeading: false,
      centerTitle: true, // Center the title

      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // White background
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primaryColor,
              size: 24,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            splashRadius: 20,
          ),
        ),
      ),


      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontFamily: AppStrings.fontFamilyKent,
          color: AppColors.primary,
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                color: AppColors.primary,
                size: 32,
              ),
              onPressed: () {},
              splashRadius: 20,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}
