class Expert {
  final String id;
  final String name;
  final String email;
  final String category;
  final String experienceLevel;
  final double hourlyRate;
  final String profilePicture;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final String shortBio;
  final bool isProfileComplete;
  final List<String> expertise;
  final int completedSessions;

  Expert({
    required this.id,
    required this.name,
    this.email = '',
    required this.category,
    required this.experienceLevel,
    required this.hourlyRate,
    required this.profilePicture,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    required this.shortBio,
    this.isProfileComplete = false,
    this.expertise = const [],
    this.completedSessions = 0,
  });
  
  // Create an Expert from a Map (e.g., from Firestore)
  factory Expert.fromMap(Map<String, dynamic> map) {
    return Expert(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Unknown Expert',
      email: map['email'] ?? '',
      category: map['category'] ?? 'General',
      experienceLevel: map['experienceLevel'] ?? 'Intermediate',
      hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      profilePicture: map['profilePicture'] ?? 'assets/placeholder.png',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] as int? ?? 0,
      isFeatured: map['isFeatured'] as bool? ?? false,
      shortBio: map['bio'] ?? map['shortBio'] ?? '',
      isProfileComplete: map['isProfileComplete'] as bool? ?? false,
      expertise: List<String>.from(map['expertise'] ?? []),
      completedSessions: map['completedSessions'] as int? ?? 0,
    );
  }
  
  // Convert Expert to a Map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'category': category,
      'experienceLevel': experienceLevel,
      'hourlyRate': hourlyRate,
      'profilePicture': profilePicture,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'bio': shortBio,
      'isProfileComplete': isProfileComplete,
      'expertise': expertise,
      'completedSessions': completedSessions,
    };
  }

  // Helper getter for image URL
  String get imageUrl => profilePicture;
}
