import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/expert.dart';
import '../utils/app_styles.dart';
import '../utils/auth_utils.dart';
import 'session_booking_screen.dart';

class ExpertProfileScreen extends StatefulWidget {
  final Expert expert;
  
  const ExpertProfileScreen({
    super.key,
    required this.expert,
  });

  @override
  State<ExpertProfileScreen> createState() => _ExpertProfileScreenState();
}

class _ExpertProfileScreenState extends State<ExpertProfileScreen> {
  late bool isLoggedIn; // Will be determined by AuthUtils
  
  // Dummy time slots
  final List<String> availableTimeSlots = [
    'Mon, Sep 7, 3:00 PM',
    'Tue, Sep 8, 1:00 PM',
    'Wed, Sep 9, 11:00 AM',
    'Thu, Sep 10, 4:30 PM',
    'Fri, Sep 11, 2:00 PM',
  ];
  @override
  void initState() {
    super.initState();
    // Get login status from AuthUtils
    _updateLoginStatus();
  }
  
  // Helper method to update login status
  void _updateLoginStatus() {
    setState(() {
      isLoggedIn = AuthUtils().isLoggedIn;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Expert Info',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.blue),
            onPressed: () {
              // Share functionality would be implemented here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality (Dummy)')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.blue),
            onPressed: () {
              // Bookmark functionality would be implemented here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmark functionality (Dummy)')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExpertHeader(),            _buildAvailableTimeSlots(),
            const Divider(height: 1),
            _buildProfileSection(),
            const Divider(height: 1),
            _buildCareerPathSection(),
            const Divider(height: 1),
            _buildReviewsSection(),
            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildExpertHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expert avatar
              _buildProfileImage(),
              const SizedBox(width: 16),
              
              // Expert info and years of experience badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Years badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_user,
                            size: 14,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.expert.experienceLevel} Level',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Expert bio preview
                    Text(
                      widget.expert.shortBio,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Expert name and title
          Column(
            children: [
              Text(
                widget.expert.name,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '${widget.expert.category}, ${widget.expert.experienceLevel}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Rating and session info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                widget.expert.rating.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time,
                color: Colors.white.withOpacity(0.9),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '60 min session',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.attach_money,
                color: Colors.white.withOpacity(0.9),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '\$${widget.expert.hourlyRate.toInt()}/hr',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Schedule button
          ElevatedButton(
            onPressed: () {
              // This button is just for UI consistency with the image
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Schedule functionality (Dummy)')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
            ),
            child: Text(
              'Schedule',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableTimeSlots() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Times',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: availableTimeSlots.map((slot) {
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(
                      slot,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.blue.shade100),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'As a seasoned ${widget.expert.category} with ${widget.expert.experienceLevel} '
            'experience, I help clients navigate the complex world of their '
            'needs. From ideation to execution, I am dedicated to creating solutions that optimize and accelerate '
            'business outcomes. My approach is collaborative and results-driven.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Expertise tags
          Text(
            'Areas of Expertise',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildExpertiseTag('Strategic Planning'),
              _buildExpertiseTag('${widget.expert.category}'),
              _buildExpertiseTag('Leadership'),
              _buildExpertiseTag('Growth Strategy'),
              _buildExpertiseTag('Innovation'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCareerPathSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Career Path',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'I started from humble origins at CodeSphere, now I\'m the '
            '${widget.expert.category} lead at one of the biggest companies in Silicon Valley. '
            'I guided my career through a commitment to excellence and continuous learning. '
            'After 5 years in a senior management position for a project, '
            'I started my own startup where I helped clients achieve their goals.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'After a successful startup journey, I sold my company for a substantial exit. I now dedicate my time to helping others as a ${widget.expert.category} where I\'m currently working.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
        ],      ),
    );
  }

  Widget _buildReviewsSection() {
    // Sample review data
    final reviews = [
      {
        'name': 'Sarah M.',
        'rating': 5,
        'date': '3 weeks ago',
        'comment': 'Excellent session, very knowledgeable and helpful. Would definitely recommend!'
      },
      {
        'name': 'Michael T.',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Great insights and practical advice. Helped me solve a challenging problem.'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              if (isLoggedIn)
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context, 
                      '/review',
                      arguments: {
                        'expertName': widget.expert.name,
                        'sessionDate': 'Previous session',
                      },
                    );
                  },
                  icon: const Icon(Icons.rate_review, size: 18),
                  label: Text(
                    'Leave a Review',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Reviews list
          ...reviews.map((review) => _buildReviewItem(review)).toList(),
          
          // View all button
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('View all reviews (Demo)')),
                );
              },
              child: Text(
                'View All Reviews',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['name'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.text,
                ),
              ),
              Text(
                review['date'],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < (review['rating'] as int) ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            review['comment'],
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () async {
            if (isLoggedIn) {
              // If logged in, navigate directly to booking screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SessionBookingScreen(
                    expert: widget.expert,
                  ),
                ),
              );
            } else {
              // If not logged in, navigate to auth screen and wait for result
              final result = await Navigator.pushNamed(context, '/auth');
              
              // Check if user is now logged in after returning from auth screen
              if (mounted) {
                setState(() {
                  isLoggedIn = AuthUtils().isLoggedIn;
                });
                
                // If successfully logged in after auth (result == true), navigate to booking
                if (isLoggedIn && result == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SessionBookingScreen(
                        expert: widget.expert,
                      ),
                    ),
                  );
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            isLoggedIn ? 'Book Session' : 'Sign In to Book Session',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: ClipOval(
            child: Center(
              // Using a placeholder icon since we don't have real images
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildExpertiseTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Text(
        tag,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.blue,
        ),
      ),
    );
  }
}
