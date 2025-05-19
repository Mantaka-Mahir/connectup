import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session.dart';
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
  final double monthlyEarnings = 1875.50;
  double profileCompleteness = 0;
  final int totalSessionsThisMonth = 23;
  
  @override
  void initState() {
    super.initState();
    _loadDummyData();
    _calculateProfileCompleteness();
  }

  void _calculateProfileCompleteness() async {
    try {
      // Get current user's expert profile from Firestore
      final userEmail = AuthUtils().currentUserEmail;
      if (userEmail == null) return;

      final expertDoc = await FirebaseFirestore.instance
          .collection('experts')
          .where('email', isEqualTo: userEmail)
          .get();

      if (expertDoc.docs.isEmpty) return;

      final expertData = expertDoc.docs.first.data();
      
      // Calculate completeness based on filled fields
      double completeness = 0;
      
      void checkField(dynamic value, double weight) {
        if (value != null && value.toString().isNotEmpty) {
          completeness += weight;
        }
      }

      // Check required fields with weights
      checkField(expertData['name'], 20);
      checkField(expertData['bio'], 20);
      checkField(expertData['experienceLevel'], 15);
      checkField(expertData['hourlyRate'], 15);
      checkField(expertData['category'], 15);
      checkField(expertData['expertise'], 15);

      if (mounted) {
        setState(() {
          profileCompleteness = completeness;
        });
      }
    } catch (e) {
      print('Error calculating profile completeness: $e');
    }
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
    } catch (e) {
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
        elevation: 0.5,
        actions: [
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
          _calculateProfileCompleteness();
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
                // Welcome text
                Text(
                  'Welcome back,',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AuthUtils().currentUserEmail?.split('@')[0] ?? 'Expert',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                
                // Profile completion section
                if (profileCompleteness < 100)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Complete Your Profile',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Add more information to increase visibility',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
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
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${profileCompleteness.round()}% Complete',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit-profile');
                              },
                              icon: const Icon(Icons.edit, size: 18),
                              label: Text(
                                'Complete Now',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Stats section  
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Earnings',
                          value: '\$${monthlyEarnings.toStringAsFixed(2)}',
                          icon: Icons.payments,
                          iconColor: Colors.green,
                          bgColor: Colors.green.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Sessions',
                          value: totalSessionsThisMonth.toString(),
                          icon: Icons.calendar_today,
                          iconColor: Colors.blue,
                          bgColor: Colors.blue.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Today's sessions section
                _buildTodaySessionsSection(),
              ],
            ),
          ),
        ),
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
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
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
              Navigator.pop(context);
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
              Navigator.pop(context);
              Navigator.pushNamed(context, '/edit-profile');
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
              Navigator.pop(context);
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
              Navigator.pop(context);
              Navigator.pushNamed(context, '/chats');
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
              Navigator.pop(context);
              Navigator.pushNamed(context, '/referral');
            },
          ),
          
          const Divider(),
          
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
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
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

  Widget _buildTodaySessionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  Widget _buildEmptySessionsState() {
    return Container(
      width: double.infinity,
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
  
  Widget _buildSessionCard(Session session) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  session.expert.name[0].toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.expert.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getFormattedTime(session.dateTime),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.videocam_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Video Call',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
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
                  minimumSize: const Size(90, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Join',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFormattedTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

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

  String _getStatusText(SessionStatus status) {
    return status.toString().split('.').last[0].toUpperCase() + 
           status.toString().split('.').last.substring(1).toLowerCase();
  }
}
