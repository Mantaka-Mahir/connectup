class Expert {
  final String id;
  final String name;
  final String category;
  final String experienceLevel;
  final double hourlyRate;
  final String profilePicture;
  final double rating;
  final int totalReviews;
  final bool isFeatured;
  final String shortBio;

  Expert({
    required this.id,
    required this.name,
    required this.category,
    required this.experienceLevel,
    required this.hourlyRate,
    required this.profilePicture,
    required this.rating,
    required this.totalReviews,
    this.isFeatured = false,
    required this.shortBio,
  });
  
  // Create an Expert from a Map (e.g., from Firestore)
  factory Expert.fromMap(Map<String, dynamic> map) {
    return Expert(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Unknown Expert',
      category: map['category'] ?? 'General',
      experienceLevel: map['experienceLevel'] ?? 'Intermediate',
      hourlyRate: (map['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      profilePicture: map['profilePicture'] ?? 'assets/placeholder.png',
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      totalReviews: map['totalReviews'] as int? ?? 0,
      isFeatured: map['isFeatured'] as bool? ?? false,
      shortBio: map['shortBio'] ?? '',
    );
  }
  
  // Convert Expert to a Map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'experienceLevel': experienceLevel,
      'hourlyRate': hourlyRate,
      'profilePicture': profilePicture,
      'rating': rating,
      'totalReviews': totalReviews,
      'isFeatured': isFeatured,
      'shortBio': shortBio,
    };
  }
}
