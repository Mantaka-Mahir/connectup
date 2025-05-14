import '../models/expert.dart';
import '../models/session.dart';
import '../models/chat.dart';

class DummyData {
  static List<Expert> getExperts() {
    return [
      Expert(
        id: '1',
        name: 'Sarah Brito',
        category: 'Software Development',
        experienceLevel: 'Senior',
        hourlyRate: 85.0,
        profilePicture: 'assets/experts/sarah.png', // This will be replaced by a placeholder
        rating: 4.9,
        totalReviews: 123,
        isFeatured: true,
        shortBio: 'Full-stack developer with 10+ years experience in web and mobile app development.',
      ),
      Expert(
        id: '2',
        name: 'Michael Hassan',
        category: 'Product Management',
        experienceLevel: 'Expert',
        hourlyRate: 95.0,
        profilePicture: 'assets/experts/michael.png', // This will be replaced by a placeholder
        rating: 4.8,
        totalReviews: 87,
        isFeatured: true,
        shortBio: 'Former Product Manager at Google with expertise in launching successful products.',
      ),
      Expert(
        id: '3',
        name: 'Priyanka Patel',
        category: 'UX/UI Design',
        experienceLevel: 'Advanced',
        hourlyRate: 75.0,
        profilePicture: 'assets/experts/priyanka.png', // This will be replaced by a placeholder
        rating: 4.7,
        totalReviews: 62,
        shortBio: 'Creative designer specializing in user-centered design for digital products.',
      ),
      Expert(
        id: '4',
        name: 'David Jordan',
        category: 'Business Strategy',
        experienceLevel: 'Expert',
        hourlyRate: 120.0,
        profilePicture: 'assets/experts/david.png', // This will be replaced by a placeholder
        rating: 4.9,
        totalReviews: 145,
        isFeatured: true,
        shortBio: 'Business consultant with experience scaling startups from seed to Series B.',
      ),
      Expert(
        id: '5',
        name: 'Elena Rodriguez',
        category: 'Marketing',
        experienceLevel: 'Intermediate',
        hourlyRate: 65.0,
        profilePicture: 'assets/experts/elena.png', // This will be replaced by a placeholder
        rating: 4.6,
        totalReviews: 48,
        shortBio: 'Digital marketing specialist focused on growth hacking and SEO optimization.',
      ),
      Expert(
        id: '6',
        name: 'Jamal Ahmed',
        category: 'Data Science',
        experienceLevel: 'Senior',
        hourlyRate: 90.0,
        profilePicture: 'assets/experts/jamal.png', // This will be replaced by a placeholder
        rating: 4.8,
        totalReviews: 76,
        shortBio: 'Data scientist with expertise in machine learning and predictive analytics.',
      ),
      Expert(
        id: '7',
        name: 'Lisa Chen',
        category: 'Financial Planning',
        experienceLevel: 'Expert',
        hourlyRate: 110.0,
        profilePicture: 'assets/experts/lisa.png', // This will be replaced by a placeholder
        rating: 4.9,
        totalReviews: 92,
        isFeatured: true,
        shortBio: 'Certified Financial Planner with focus on startup equity and investment strategy.',
      ),    ];
  }

  static List<Session> getSessions() {
    final experts = getExperts();

    // Current time as a reference
    final now = DateTime.now();
    
    // Upcoming sessions (in the future)
    final List<Session> upcomingSessions = [
      Session(
        id: 'u1',
        expert: experts[0], // Sarah Brito
        dateTime: now.add(const Duration(days: 2, hours: 3)),
        durationMinutes: 60,
        cost: 85.0,
        status: SessionStatus.upcoming,
      ),
      Session(
        id: 'u2',
        expert: experts[2], // Priyanka Patel
        dateTime: now.add(const Duration(days: 5, hours: 1)),
        durationMinutes: 45,
        cost: 56.25, // 75 * 0.75 (for 45 minutes)
        status: SessionStatus.upcoming,
      ),
      Session(
        id: 'u3',
        expert: experts[5], // Jamal Ahmed
        dateTime: now.add(const Duration(days: 7, hours: 6)),
        durationMinutes: 30,
        cost: 45.0, // 90 * 0.5 (for 30 minutes)
        status: SessionStatus.upcoming,
      ),
    ];

    // Completed sessions (in the past)
    final List<Session> completedSessions = [
      Session(
        id: 'c1',
        expert: experts[1], // Michael Hassan
        dateTime: now.subtract(const Duration(days: 3, hours: 2)),
        durationMinutes: 60,
        cost: 95.0,
        status: SessionStatus.completed,
      ),
      Session(
        id: 'c2',
        expert: experts[6], // Lisa Chen
        dateTime: now.subtract(const Duration(days: 10, hours: 5)),
        durationMinutes: 45,
        cost: 82.5, // 110 * 0.75 (for 45 minutes)
        status: SessionStatus.completed,
      ),
    ];

    // Cancelled sessions
    final List<Session> cancelledSessions = [
      Session(
        id: 'ca1',
        expert: experts[3], // David Jordan
        dateTime: now.subtract(const Duration(days: 5, hours: 4)),
        durationMinutes: 30,
        cost: 60.0, // 120 * 0.5 (for 30 minutes)
        status: SessionStatus.cancelled,
      ),
    ];

    // Return all sessions combined
    return [...upcomingSessions, ...completedSessions, ...cancelledSessions];
  }

  // Helper methods to get sessions by status
  static List<Session> getUpcomingSessions() {
    return getSessions().where((session) => session.status == SessionStatus.upcoming).toList();
  }
  
  static List<Session> getCompletedSessions() {
    return getSessions().where((session) => session.status == SessionStatus.completed).toList();
  }
    static List<Session> getCancelledSessions() {
    return getSessions().where((session) => session.status == SessionStatus.cancelled).toList();
  }
  
  static List<Chat> getChats() {
    final now = DateTime.now();
    
    return [
      Chat(
        id: 'c1',
        name: 'Sakib Hossain T.',
        lastMessage: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        timestamp: now.subtract(const Duration(minutes: 5)),
        profileImage: 'assets/experts/sakib.png',
        isOnline: true,
        isUnread: true,
      ),
      Chat(
        id: 'c2',
        name: 'Dr. Olivia Chen',
        lastMessage: 'Let me know if you have any questions about the session.',
        timestamp: now.subtract(const Duration(hours: 1)),
        profileImage: 'assets/experts/olivia.png',
        isOnline: true,
        isUnread: false,
      ),
      Chat(
        id: 'c3',
        name: 'Michael Hassan',
        lastMessage: 'Thanks for your time today. I found our discussion very helpful.',
        timestamp: now.subtract(const Duration(hours: 3)),
        profileImage: 'assets/experts/michael.png',
        isOnline: false,
        isUnread: false,
      ),      Chat(
        id: 'c4',
        name: 'Sarah Brito',
        lastMessage: "I'll share those resources with you shortly.",
        timestamp: now.subtract(const Duration(days: 1)),
        profileImage: 'assets/experts/sarah.png',
        isOnline: false,
        isUnread: true,
      ),
      Chat(
        id: 'c5',
        name: 'James Rodriguez',
        lastMessage: 'Looking forward to our next session!',
        timestamp: now.subtract(const Duration(days: 2)),
        profileImage: 'assets/experts/james.png',
        isOnline: false,
        isUnread: false,
      ),
    ];
  }
}
