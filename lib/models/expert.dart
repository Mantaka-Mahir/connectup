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
}
