import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_styles.dart';

class ReviewQuickAccessButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool extended;
  final bool usePrimaryColor;
  
  const ReviewQuickAccessButton({
    super.key, 
    required this.onPressed, 
    this.extended = true,
    this.usePrimaryColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return extended 
      ? FloatingActionButton.extended(
          onPressed: onPressed,
          backgroundColor: usePrimaryColor ? AppColors.primary : AppColors.accent,
          icon: const Icon(Icons.rate_review),
          label: Text(
            'Leave a Review',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 3,
        )
      : FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: usePrimaryColor ? AppColors.primary : AppColors.accent,
          child: const Icon(Icons.rate_review),
          tooltip: 'Leave a Review',
          elevation: 3,
        );
  }
}
