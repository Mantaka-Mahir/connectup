import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/expert.dart';
import '../utils/app_styles.dart';
import '../utils/auth_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/pending_reviews_widget.dart';
import 'expert_profile_screen.dart';
import 'session_booking_screen.dart';

class ExpertsScreen extends StatefulWidget {
  const ExpertsScreen({Key? key}) : super(key: key);

  @override
  State<ExpertsScreen> createState() => _ExpertsScreenState();
}

class _ExpertsScreenState extends State<ExpertsScreen> {
  List<Expert> experts = [];
  String _selectedCategory = 'All';
  bool isLoggedIn = false;
  bool _isExpert = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get experts from Firestore
      final QuerySnapshot expertSnapshot = await FirebaseFirestore.instance
          .collection('experts')
          .get();

      final loadedExperts = expertSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Expert(
          id: doc.id,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          expertise: List<String>.from(data['expertise'] ?? [data['category'] ?? 'Software Development']),
          experienceLevel: data['experienceLevel'] ?? 'Entry Level (1-2 years)',
          category: data['category'] ?? 'Software Development',
          shortBio: data['bio'] ?? 'This is our demo app built with flutter',
          hourlyRate: (data['hourlyRate'] is num) ? (data['hourlyRate'] as num).toDouble() : 12.0,
          rating: (data['rating'] is num) ? (data['rating'] as num).toDouble() : 0.0,
          reviewCount: (data['reviewCount'] is num) ? (data['reviewCount'] as num).toInt() : 0,
          profilePicture: data['profilePicture'] ?? 'assets/placeholder.png',
          isFeatured: data['isFeatured'] ?? false,
          completedSessions: (data['completedSessions'] is num) ? (data['completedSessions'] as num).toInt() : 0,
          isProfileComplete: data['isProfileComplete'] ?? true,
        );
      }).toList();

      if (mounted) {
        setState(() {
          // If no experts found, add dummy expert
          if (loadedExperts.isEmpty) {
            experts = [
              Expert(
                id: 'dummy1',
                name: 'Akhlak Ud Jaman',
                email: 'kamrul@gmail.com',
                category: 'Software Development',
                experienceLevel: 'Entry Level (1-2 years)',
                hourlyRate: 12.0,
                profilePicture: 'assets/placeholder.png',
                rating: 0.0,
                reviewCount: 0,
                shortBio: 'This is our demo app built with flutter',
                expertise: ['Software Development'],
                isProfileComplete: true,
                completedSessions: 0,
              )
            ];
          } else {
            experts = loadedExperts;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // On error, load dummy data
          experts = [
            Expert(
              id: 'dummy1',
              name: 'Akhlak Ud Jaman',
              email: 'kamrul@gmail.com',
              category: 'Software Development',
              experienceLevel: 'Entry Level (1-2 years)',
              hourlyRate: 12.0,
              profilePicture: 'assets/placeholder.png',
              rating: 0.0,
              reviewCount: 0,
              shortBio: 'This is our demo app built with flutter',
              expertise: ['Software Development'],
              isProfileComplete: true,
              completedSessions: 0,
            )
          ];
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Loading sample data'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
    await _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final auth = AuthUtils();
    isLoggedIn = auth.isLoggedIn;
    if (isLoggedIn) {
      _isExpert = await auth.isExpert;
    }
    if (mounted) {
      setState(() {});
    }
  }

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

  List<Expert> get filteredExperts {
    if (_selectedCategory == 'All') {
      return experts;
    } else {
      return experts.where((expert) => expert.category == _selectedCategory).toList();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
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
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filters coming soon')),
              );
            },
          ),
        ],
      ),
      drawer: isLoggedIn ? _buildDrawer() : null,
      floatingActionButton: !_isExpert && isLoggedIn ? FloatingActionButton.extended(
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
                    itemCount: filteredExperts.length,
                    itemBuilder: (context, index) {
                      return _buildExpertCard(filteredExperts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: AppGradients.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: AppColors.primary, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  AuthUtils().currentUserEmail ?? 'User',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _isExpert ? 'Expert' : 'Mentee',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withAlpha(204),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (!_isExpert)
            PendingReviewsWidget(
              pendingReviewsCount: 3,
              onTap: () {
                Navigator.pop(context);
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
          if (_isExpert)
            ListTile(
              leading: Icon(Icons.dashboard, color: AppColors.textLight),
              title: Text(
                'Dashboard',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/expert-dashboard');
              },
            ),
          if (!_isExpert)
            ListTile(
              leading: Icon(Icons.star, color: AppColors.textLight),
              title: Text(
                'Become an Expert',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/become-expert');
              },
            ),
          ListTile(
            leading: Icon(Icons.explore, color: AppColors.primary),
            title: Text(
              'Explore Experts',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            selected: true,
            selectedColor: AppColors.primary,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline, color: AppColors.textLight),
            title: Text(
              'Messages',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/chats');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: AppColors.textLight),
            title: Text(
              'My Sessions',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/my-sessions');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet, color: AppColors.textLight),
            title: Text(
              'My Wallet',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/wallet');
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
            onTap: () async {
              await AuthUtils().signOut();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/');
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
            color: Colors.black.withAlpha(13),
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
                _buildProfilePicture(expert),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        expert.category,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${expert.experienceLevel} Level',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            expert.rating.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
          if (expert.shortBio.isNotEmpty)
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
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
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
                Expanded(
                  child: ElevatedButton(                    onPressed: () async {
                      if (isLoggedIn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SessionBookingScreen(expert: expert),
                          ),
                        );
                      } else {
                        // Navigate to auth screen if not logged in
                        final result = await Navigator.pushNamed(context, '/auth');
                        if (result == true) {
                          // After successful login, check login state and then navigate to booking
                          setState(() {
                            isLoggedIn = AuthUtils().isLoggedIn;
                          });
                          if (isLoggedIn && mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SessionBookingScreen(expert: expert),
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
        color: AppColors.primary.withAlpha(26),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: expert.imageUrl.isNotEmpty
            ? Image.network(
                expert.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.primary,
                ),
              )
            : Icon(
                Icons.person,
                size: 40,
                color: AppColors.primary,
              ),
      ),
    );
  }
}
