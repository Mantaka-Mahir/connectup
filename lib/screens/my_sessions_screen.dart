import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/session.dart';
import '../utils/app_styles.dart';
import '../utils/dummy_data.dart';
import '../widgets/review_prompt_banner.dart';

class MySessionsScreen extends StatefulWidget {
  const MySessionsScreen({super.key});

  @override
  State<MySessionsScreen> createState() => _MySessionsScreenState();
}

class _MySessionsScreenState extends State<MySessionsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Session lists
  late List<Session> upcomingSessions;
  late List<Session> completedSessions;
  late List<Session> cancelledSessions;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Initialize session lists
    upcomingSessions = DummyData.getUpcomingSessions();
    completedSessions = DummyData.getCompletedSessions();
    cancelledSessions = DummyData.getCancelledSessions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Sessions',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,          ),
          tabs: [
            const Tab(text: 'Upcoming'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Completed'),
                  const SizedBox(width: 4),
                  // Show a badge for sessions that need review
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '3',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSessionList(upcomingSessions, SessionStatus.upcoming),
          _buildSessionList(completedSessions, SessionStatus.completed),
          _buildSessionList(cancelledSessions, SessionStatus.cancelled),
        ],
      ),
    );
  }
  Widget _buildSessionList(List<Session> sessions, SessionStatus status) {
    if (sessions.isEmpty) {
      return _buildEmptyState(status);
    }

    // For completed sessions, add review prompt banner at the top
    if (status == SessionStatus.completed) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        // Add 1 to the item count to include the banner
        itemCount: sessions.length + 1,
        itemBuilder: (context, index) {
          // First item is the banner
          if (index == 0) {
            return ReviewPromptBanner(
              onReviewPressed: () {
                Navigator.pushNamed(
                  context, 
                  '/review',
                  arguments: {
                    'expertName': 'Your Recent Mentor',
                    'sessionDate': 'Recent session',
                  },
                );
              },
            );
          }
          // Other items are the session cards (adjust index to account for banner)
          final session = sessions[index - 1];
          return _buildSessionCard(session);
        },
      );
    }

    // For other status types, just show the sessions
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildSessionCard(session);
      },
    );
  }

  Widget _buildEmptyState(SessionStatus status) {
    String message;
    IconData icon;

    switch (status) {
      case SessionStatus.upcoming:
        message = 'No upcoming sessions';
        icon = Icons.event_available;
        break;
      case SessionStatus.completed:
        message = 'No completed sessions yet';
        icon = Icons.check_circle_outline;
        break;
      case SessionStatus.cancelled:
        message = 'No cancelled sessions';
        icon = Icons.cancel_outlined;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),          TextButton(
            onPressed: () {              // Navigate to ExpertsScreen to browse experts
              Navigator.pushReplacementNamed(context, '/experts');
            },
            child: Text(
              'Browse Experts',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Session session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Container(
            decoration: BoxDecoration(
              color: session.statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(session.status),
                  color: session.statusColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  session.statusText,
                  style: GoogleFonts.poppins(
                    color: session.statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${session.cost.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          
          // Expert info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [                // Expert avatar
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.expert.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.expert.category,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSessionDetails(session),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Action buttons
          _buildActionButtons(session),
        ],
      ),
    );
  }

  Widget _buildSessionDetails(Session session) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              session.formattedDate,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              '${session.formattedTime} (${session.durationMinutes} min)',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(Session session) {
    switch (session.status) {
      case SessionStatus.upcoming:
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to join the session
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Joining session... (Demo)'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Join Session'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  _showCancelConfirmation(context, session);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error),
                  foregroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      case SessionStatus.completed:
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the review submission screen
                    Navigator.pushNamed(
                      context, 
                      '/review',
                      arguments: {
                        'expertName': session.expert.name,
                        'sessionDate': session.formattedDate,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Leave a Review'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  // Logic to book again
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking again... (Demo)'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Book Again'),
              ),
            ],
          ),
        );
      case SessionStatus.cancelled:
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Logic to rebook
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rebooking... (Demo)'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Book Again'),
            ),
          ),
        );
    }
  }

  void _showCancelConfirmation(BuildContext context, Session session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Session',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel your session with ${session.expert.name}?',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 12),
            Text(
              'Cancellation Policy:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '• Full refund if cancelled 24 hours before the session\n'
              '• 50% refund if cancelled between 24 and 12 hours before\n'
              '• No refund if cancelled within 12 hours',
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep Session',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Logic to cancel the session
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Session cancelled! (Demo)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Cancel Session',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(SessionStatus status) {
    switch (status) {
      case SessionStatus.upcoming:
        return Icons.event_available;
      case SessionStatus.completed:
        return Icons.check_circle;
      case SessionStatus.cancelled:
        return Icons.cancel;
    }
  }
}
