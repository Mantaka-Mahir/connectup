import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/expert.dart';
import '../utils/app_styles.dart';
import '../utils/auth_utils.dart';
import '../utils/dummy_data.dart';
import '../widgets/pending_reviews_widget.dart';
import 'expert_profile_screen.dart';
import 'session_booking_screen.dart';

class ExpertsScreen extends StatefulWidget {
  const ExpertsScreen({super.key});

  @override
  State<ExpertsScreen> createState() => _ExpertsScreenState();
}

class _ExpertsScreenState extends State<ExpertsScreen> {
  late List<Expert> experts;
  String _selectedCategory = 'All';
  bool isLoggedIn = false;

  // Check if user is an expert
  bool get isExpert => AuthUtils().isExpert;

  final List<String> categories = [
    'All',
    'Software Development',
    'Product Management',
    'UX/UI Design',
    'Business Strategy',
    'Marketing',
    'Data Science',
    'Financial Planning',
  ];

  @override
  void initState() {
    super.initState();
    experts = DummyData.getExperts();
    isLoggedIn = AuthUtils().isLoggedIn;
  }

  List<Expert> get filteredExperts {
    if (_selectedCategory == 'All') {
      return experts;
    } else {
      return experts.where((expert) => expert.category == _selectedCategory).toList();
    }
  }
  
  @override
  Widget build(BuildContext context) {    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Explore Experts',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: isLoggedIn 
            ? Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: AppColors.primary),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [          // My Sessions button for authenticated users          if (isLoggedIn)
            IconButton(
              icon: Icon(Icons.calendar_today, color: AppColors.primary),
              tooltip: 'My Sessions',
              onPressed: () {
                Navigator.pushNamed(context, '/my-sessions');
              },
            ),
          if (isLoggedIn)
            IconButton(
              icon: Icon(Icons.account_balance_wallet, color: AppColors.primary),
              tooltip: 'My Wallet',
              onPressed: () {
                Navigator.pushNamed(context, '/wallet');
              },
            ),
          IconButton(
            icon: Icon(Icons.search, color: AppColors.primary),
            onPressed: () {
              // Search functionality would be implemented here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search functionality (Dummy)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: AppColors.primary),
            onPressed: () {
              // Filter functionality would be implemented here
              ScaffoldMessenger.of(context).showSnackBar(                const SnackBar(
                  content: Text('Filter functionality (Dummy)'),
                  duration: Duration(seconds: 1),
                ),              );
            },
          ),
        ],      ),      drawer: isLoggedIn ? _buildDrawer() : null,
      floatingActionButton: isLoggedIn ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context, 
            '/review',
            arguments: {
              'expertName': 'Recent Mentor',
              'sessionDate': 'Recent session',
            },
          );
        },
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.rate_review),
        label: const Text('Rate a Mentor'),
        elevation: 3,
      ) : null,
      body: Column(
        children: [
          // Welcome message for test account login
          if (!isExpert)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connect Up Demo',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Want to see the Expert Dashboard? Try logging in with expert@gmail.com / expert@gmail.com',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 16, color: Colors.blue.shade700),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          // This would typically store a preference to hide the message
                          // but for demo purposes, we'll just rebuild without handling persistence
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Category filter horizontal list
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredExperts.length} experts found',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  'Sort by: Recommended',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          
          // Expert cards
          Expanded(
            child: filteredExperts.isEmpty
                ? Center(
                    child: Text(
                      'No experts found in this category',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredExperts.length,                    itemBuilder: (context, index) {
                      return _buildExpertCard(filteredExperts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Drawer for navigation
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer header with user info
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: AppGradients.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User avatar
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                // User email
                Text(
                  AuthUtils().currentUserEmail ?? 'User',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  isExpert ? 'Expert' : 'Mentee',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),              ],
            ),
          ),
          
          // Pending Reviews widget for non-experts
          if (!isExpert)
            PendingReviewsWidget(
              pendingReviewsCount: 3,
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushNamed(
                  context, 
                  '/review',
                  arguments: {
                    'expertName': 'Your Recent Mentor',
                    'sessionDate': 'Recent session',
                  },
                );
              },
            ),
          
          // Menu items
          if (isExpert)
            ListTile(
              leading: Icon(Icons.dashboard, color: AppColors.textLight),
              title: Text(
                'Dashboard',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushReplacementNamed(context, '/expert-dashboard');
              },
            ),
          
          if (!isExpert)
            ListTile(
              leading: Icon(Icons.star, color: AppColors.textLight),
              title: Text(
                'Become an Expert',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushNamed(context, '/become-expert');
              },
            ),
            
          ListTile(
            leading: Icon(Icons.explore, color: AppColors.primary),
            title: Text(
              'Explore Experts',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            selected: true,
            selectedColor: AppColors.primary,
            onTap: () {
              Navigator.pop(context); // Close drawer
            },
          ),
            ListTile(
            leading: Icon(Icons.calendar_today, color: AppColors.textLight),
            title: Text(
              'My Sessions',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/my-sessions');
            },
          ),
            ListTile(
            leading: Icon(Icons.chat_bubble_outline, color: AppColors.textLight),
            title: Text(
              'Messages',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/chats');
            },
          ),
          
          ListTile(
            leading: Icon(Icons.account_balance_wallet, color: AppColors.textLight),
            title: Text(
              'My Wallet',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/wallet');
            },
          ),          ListTile(
            leading: Icon(Icons.notifications_outlined, color: AppColors.textLight),
            title: Text(
              'Notifications',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          
          // Review option
          ListTile(
            leading: Icon(Icons.star_rate, color: AppColors.accent),
            title: Text(
              'Review a Mentor',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(
                context, 
                '/review',
                arguments: {
                  'expertName': 'Your Recent Mentor',
                  'sessionDate': 'Recent session',
                },
              );
            },
          ),
          
          ListTile(
            leading: Icon(Icons.card_giftcard, color: AppColors.textLight),
            title: Text(
              'Refer & Earn',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/referral');
            },
          ),
          
          const Divider(),
          
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.textLight),
            title: Text(
              'Settings',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings (Demo)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            onTap: () {
              // Logout and navigate back to welcome screen
              AuthUtils().logout();
              Navigator.pop(context); // Close drawer
              Navigator.pushReplacementNamed(context, '/'); // Navigate to welcome screen
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpertCard(Expert expert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Expert info section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture
                _buildProfilePicture(expert),
                const SizedBox(width: 16),
                // Expert details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and featured badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              expert.name,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (expert.isFeatured)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Featured',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Category
                      Text(
                        expert.category,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Experience level
                      Text(
                        '${expert.experienceLevel} Level',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            expert.rating.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${expert.totalReviews})',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Hourly rate
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${expert.hourlyRate.toInt()}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'per hour',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Short bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              expert.shortBio,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // View Profile button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to expert profile screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpertProfileScreen(expert: expert),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'View Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Book button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Check if user is logged in
                      if (AuthUtils().isLoggedIn) {
                        // If logged in, navigate to booking screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SessionBookingScreen(
                              expert: expert,
                            ),
                          ),                        );
                      } else {
                        // If not logged in, navigate to auth screen
                        final result = await Navigator.pushNamed(context, '/auth');
                        
                        // If login successful
                        if (result == true) {
                          setState(() {
                            isLoggedIn = AuthUtils().isLoggedIn;
                          });
                          
                          // If now logged in, navigate to booking
                          if (isLoggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SessionBookingScreen(
                                  expert: expert,
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Book',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(Expert expert) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Center(
          // Using a placeholder icon since we don't have real images
          child: Icon(
            Icons.person,
            size: 40,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
