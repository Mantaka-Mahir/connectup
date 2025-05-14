import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_styles.dart';

class ReviewSubmissionScreen extends StatefulWidget {
  final String expertName;
  final String sessionDate;

  const ReviewSubmissionScreen({
    super.key, 
    this.expertName = 'Expert',  // Default value if not provided
    this.sessionDate = 'Recent session', // Default value if not provided
  });

  @override
  State<ReviewSubmissionScreen> createState() => _ReviewSubmissionScreenState();
}

class _ReviewSubmissionScreenState extends State<ReviewSubmissionScreen> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a rating before submitting',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isSubmitting = false;
        _showSuccess = true;
      });

      // Automatically close the success message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Submit Review',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.text,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Session info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'How was your session with',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.expertName,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.sessionDate,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Rating stars
                Text(
                  'Rate your experience',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRatingStars(),
                const SizedBox(height: 8),
                Text(
                  _getRatingText(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _rating > 0 ? AppColors.primary : AppColors.textLight,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Comments field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional comments (optional)',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _commentController,
                  maxLines: 5,
                  maxLength: 500,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.text,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Share details about your experience...',
                    hintStyle: GoogleFonts.poppins(
                      color: AppColors.textLight.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Submit Review',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Skip button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Skip for now',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Success overlay
          if (_showSuccess) _buildSuccessOverlay(),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              color: index < _rating ? Colors.amber : Colors.grey,
              size: 40,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSuccessOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Thank You!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your review has been submitted successfully.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Redirecting...',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textLight.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText() {
    switch (_rating) {
      case 0:
        return 'Tap to rate';
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}
