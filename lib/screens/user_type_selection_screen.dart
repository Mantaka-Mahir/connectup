import 'package:flutter/material.dart';
import '../utils/app_styles.dart';
import '../utils/auth_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'experts_screen.dart';
import 'expert_dashboard_screen_new.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  State<UserTypeSelectionScreen> createState() => _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  // Local state to track selected user type
  String? _selectedUserType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Join Connect Up',
          style: GoogleFonts.poppins(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'How would you like to join?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Select the option that best describes your goals',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // User Type Cards
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [                      // Expert Card
                      _buildUserTypeCard(
                        type: 'expert',
                        title: 'Join as Expert',
                        description: 'Share your knowledge and experience, mentor others, and build your professional network.',
                        icon: Icons.psychology,
                      ),
                      const SizedBox(height: 20),
                      // Mentee Card
                      _buildUserTypeCard(
                        type: 'mentee',
                        title: 'Join as Mentee',
                        description: 'Connect with experts in your field, receive guidance, and accelerate your growth.',
                        icon: Icons.school,
                      ),
                      const SizedBox(height: 20),
                      // Apply to become an expert
                      _buildUserTypeCard(
                        type: 'apply_expert',
                        title: 'Apply to be an Expert',
                        description: 'Submit your profile for review to join our expert community. Share your expertise with others.',
                        icon: Icons.verified_user,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),              // Continue Button
              ElevatedButton(
                onPressed: _selectedUserType != null
                    ? () {
                        // Show feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Continuing as $_selectedUserType'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                          // Set user type in AuthUtils
                        AuthUtils().login(
                          AuthUtils().currentUserEmail ?? 'user@example.com', 
                          'password',
                          userType: _selectedUserType!
                        );
                          // Navigate based on user type
                        if (_selectedUserType == 'expert') {
                          // Navigate to Expert Dashboard
                          Navigator.pushReplacementNamed(context, '/expert-dashboard');
                        } else if (_selectedUserType == 'apply_expert') {
                          // Navigate to Become Expert form
                          Navigator.pushReplacementNamed(context, '/become-expert');
                        } else {
                          // Navigate to Experts screen for mentees
                          Navigator.pushReplacementNamed(context, '/experts');
                        }
                      }
                    : null, // Disabled if no selection
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),                ),
              ),
              
              // Test account information
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Test Account Available',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You can use expert@gmail.com with the same password to test the expert dashboard features.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard({
    required String type,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedUserType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                ? AppColors.primary.withOpacity(0.2) 
                : Colors.black.withOpacity(0.05),
              spreadRadius: isSelected ? 2 : 0,
              blurRadius: isSelected ? 8 : 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Card Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: isSelected ? AppColors.primary : Colors.grey.shade600,
                      size: 32,
                    ),
                  ),
                ),
                // Selection indicator
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // Features
            _buildFeatureItem(
              isSelected: isSelected, 
              text: type == 'expert' ? 'Create personalized mentorship plans' : 'Access to expert mentors'
            ),
            const SizedBox(height: 8),
            _buildFeatureItem(
              isSelected: isSelected, 
              text: type == 'expert' ? 'Earn income through paid sessions' : 'Get customized learning paths'
            ),
            const SizedBox(height: 8),
            _buildFeatureItem(
              isSelected: isSelected, 
              text: type == 'expert' ? 'Showcase your expertise and credentials' : 'Track your progress and growth'
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem({required bool isSelected, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          color: isSelected ? AppColors.primary : Colors.grey.shade400,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isSelected ? AppColors.text : AppColors.textLight,
            ),
          ),
        ),
      ],
    );
  }
}
