import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewReminderOverlay extends StatefulWidget {
  final VoidCallback onDismiss;
  final VoidCallback onReviewPressed;

  const ReviewReminderOverlay({
    super.key,
    required this.onDismiss,
    required this.onReviewPressed,
  });

  @override
  State<ReviewReminderOverlay> createState() => _ReviewReminderOverlayState();
}

class _ReviewReminderOverlayState extends State<ReviewReminderOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _animationController.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          bottom: 20 + _slideAnimation.value,
          left: 16,
          right: 16,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.rate_review,
                      color: Colors.purple.shade600,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You have sessions to review',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Help improve the community with your feedback',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onReviewPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.purple.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Review'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: _dismiss,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
