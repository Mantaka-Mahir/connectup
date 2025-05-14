import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/session.dart';
import '../models/expert.dart';
import '../utils/app_styles.dart';
import '../utils/auth_utils.dart';
import '../utils/dummy_data.dart';

class ExpertDashboardScreen extends StatefulWidget {
  const ExpertDashboardScreen({super.key});

  @override
  State<ExpertDashboardScreen> createState() => _ExpertDashboardScreenState();
}

class _ExpertDashboardScreenState extends State<ExpertDashboardScreen> {
  late List<Session> todaySessions;
  final double monthlyEarnings = 1875.50; // Dummy monthly earnings
  final int profileCompleteness = 75; // Dummy profile completeness percentage
  final int totalSessionsThisMonth = 23; // Dummy total sessions
  
  @override
  void initState() {
    super.initState();
    
    // Get dummy data
    _loadDummyData();
  }

  void _loadDummyData() {
    try {
      final allSessions = DummyData.getSessions();
      final now = DateTime.now();
      
      todaySessions = allSessions.where((session) {
        return session.dateTime.year == now.year &&
              session.dateTime.month == now.month &&
              session.dateTime.day == now.day;
      }).toList();
      
      // If no sessions today, add a dummy session for demo purposes
      if (todaySessions.isEmpty) {
        final experts = DummyData.getExperts();
        // Add dummy sessions for today
        todaySessions = [
          Session(
            id: 't1',
            expert: experts[0],
            dateTime: DateTime(now.year, now.month, now.day, now.hour + 1),
            durationMinutes: 45,
            cost: 65.0,
            status: SessionStatus.upcoming,
          ),
          Session(
            id: 't2',
            expert: experts[2],
            dateTime: DateTime(now.year, now.month, now.day, now.hour + 3),
            durationMinutes: 60,
            cost: 75.0,
            status: SessionStatus.upcoming,
          ),
        ];
      }
    } catch (e) {
      // Handle any errors loading dummy data
      debugPrint('Error loading dummy data: $e');
      todaySessions = [];
    }
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Expert Dashboard',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,        actions: [
          IconButton(
            icon: const Icon(Icons.rate_review_outlined),
            color: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(
                context, 
                '/review',
                arguments: {
                  'expertName': 'Your Mentor',
                  'sessionDate': 'Recent session',
                },
              );
            },
            tooltip: 'Leave a Review',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.primary,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Reload data
          setState(() {
            _loadDummyData();
          });
          return Future<void>.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Information message
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                        child: Text(
                          'Pull down to refresh if content is not displaying',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            
                // Welcome section
                _buildWelcomeSection(),
                
                const SizedBox(height: 24),
                
                // Stats overview
                _buildStatsOverview(),
                
                const SizedBox(height: 24),
                
                // Today's sessions section
                _buildTodaySessionsSection(),
                
                const SizedBox(height: 24),
                
                // Profile completeness
                _buildProfileCompletenessCard(),
              ],
            ),
          ),
        ),
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
                  AuthUtils().currentUserEmail ?? 'Expert',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Expert',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu items
          ListTile(
            leading: Icon(Icons.dashboard, color: AppColors.primary),
            title: Text(
              'Dashboard',
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
            leading: Icon(Icons.person_outline, color: AppColors.textLight),
            title: Text(
              'Edit Profile',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit Profile (Demo)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },          ),
          
          const Divider(),
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
          
          ListTile(
            leading: Icon(Icons.rate_review, color: AppColors.textLight),
            title: Text(
              'Write a Review',
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
                  'expertName': 'Your Mentor',
                  'sessionDate': 'Recent session',
                },
              );
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
          ),
          
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
            onTap: () {              // Sign out and navigate back to welcome screen
              AuthUtils().signOut().then((_) {
                Navigator.pop(context); // Close drawer
                Navigator.pushReplacementNamed(context, '/'); // Navigate to welcome screen
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
  
  // Welcome section with date and username
  Widget _buildWelcomeSection() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June', 
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${months[now.month - 1]} ${now.day}, ${now.year}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textLight,
          ),
        ),        const SizedBox(height: 4),
        Text(
          'Welcome, ${AuthUtils().currentUserEmail?.split('@')[0] ?? 'Expert'}!',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
          // Special message for test accounts
        if (AuthUtils().isTestAccount)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You are logged in with the expert test account',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.green.shade800,
                    ),
                  ),                ),              ],
            ),
          ),
          
        // Quick Actions Buttons
        Container(
          margin: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionButton(
                icon: Icons.calendar_today,
                label: 'Sessions',
                onTap: () => Navigator.pushNamed(context, '/my-sessions'),
                color: AppColors.primary,
              ),
              _buildQuickActionButton(
                icon: Icons.message,
                label: 'Messages',
                onTap: () => Navigator.pushNamed(context, '/chats'),
                color: Colors.blue,
              ),
              _buildQuickActionButton(
                icon: Icons.rate_review,
                label: 'Review',
                onTap: () => Navigator.pushNamed(context, '/review', 
                  arguments: {
                    'expertName': 'Your Mentor',
                    'sessionDate': 'Recent session',
                  },
                ),
                color: Colors.deepPurple,
              ),
              _buildQuickActionButton(
                icon: Icons.card_giftcard,
                label: 'Refer',
                onTap: () => Navigator.pushNamed(context, '/referral'),
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // Quick action button widget
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Function() onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
  
  // Stats overview cards
  Widget _buildStatsOverview() {
    return Row(
      children: [
        // Earnings card
        Expanded(
          flex: 1,
          child: _buildStatCard(
            title: 'Monthly Earnings',
            value: '\$${monthlyEarnings.toStringAsFixed(2)}',
            icon: Icons.account_balance_wallet,
            iconColor: Colors.green[700]!,
            bgColor: Colors.green[50]!,
          ),
        ),
        const SizedBox(width: 16),
        // Sessions card
        Expanded(
          flex: 1,
          child: _buildStatCard(
            title: 'Sessions This Month',
            value: totalSessionsThisMonth.toString(),
            icon: Icons.calendar_month,
            iconColor: AppColors.primary,
            bgColor: AppColors.primary.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
  
  // Single stat card
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          // Value
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          // Title
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
  
  // Today's sessions section
  Widget _buildTodaySessionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Sessions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/my-sessions');
              },
              child: Text(
                'View All',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Sessions list
        todaySessions.isEmpty
            ? _buildEmptySessionsState()
            : Column(
                children: todaySessions
                    .map((session) => _buildSessionCard(session))
                    .toList(),
              ),
      ],
    );
  }
  
  // Empty state for no sessions
  Widget _buildEmptySessionsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Icon(
            Icons.event_available,
            size: 48,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No sessions scheduled for today',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enjoy your free time!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  // Session card
  Widget _buildSessionCard(Session session) {
    final mentee = session.expert; // Using expert model as a placeholder for mentee
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Session header with status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(session.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getStatusText(session.status),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(session.status),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '\$${session.cost.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Session info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mentee avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Session details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentee.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getFormattedTime(session.dateTime) + 
                              ' (${session.durationMinutes} min)',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),              ),
              // Action button
              SizedBox(
                height: 36,
                width: 90, // Add fixed width to avoid infinite width
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Starting session... (Demo)'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Start',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Helper method to format time
  String _getFormattedTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final hour12 = hour == 0 ? 12 : hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour12:$minute $period';
  }
  
  // Helper method to get status color
  Color _getStatusColor(SessionStatus status) {
    switch (status) {
      case SessionStatus.upcoming:
        return Colors.blue;
      case SessionStatus.completed:
        return Colors.green;
      case SessionStatus.cancelled:
        return Colors.red;
    }
  }
  
  // Helper method to get status text
  String _getStatusText(SessionStatus status) {
    switch (status) {
      case SessionStatus.upcoming:
        return 'Upcoming';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.cancelled:
        return 'Cancelled';
    }
  }
  
  // Profile completeness card
  Widget _buildProfileCompletenessCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Profile Completeness',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: profileCompleteness / 100,
              backgroundColor: Colors.grey[200],
              color: _getProfileCompletenessColor(),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          // Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$profileCompleteness%',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getProfileCompletenessColor(),
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Complete your profile (Demo)'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Complete Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          // Missing items
          if (profileCompleteness < 100)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMissingProfileItem(
                    'Add your educational background',
                    isDone: false,
                  ),
                  _buildMissingProfileItem(
                    'Upload certifications',
                    isDone: false,
                  ),
                  _buildMissingProfileItem(
                    'Set your availability schedule',
                    isDone: true,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  // Missing profile item
  Widget _buildMissingProfileItem(String text, {required bool isDone}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isDone ? Colors.green : AppColors.textLight,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDone ? Colors.green : AppColors.textLight,
              decoration: isDone ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
  
  // Get profile completeness color based on percentage
  Color _getProfileCompletenessColor() {
    if (profileCompleteness < 50) {
      return Colors.orange;
    } else if (profileCompleteness < 80) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }
}
