import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_styles.dart';
import '../utils/auth_utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  String _selectedExpertiseArea = 'Software Development';
  String _selectedExperienceLevel = 'Intermediate (3-5 years)';
  bool _isLoading = false;
  String? _imageUrl;

  // Pre-defined lists
  final List<String> _expertiseAreas = [
    'Software Development',
    'Product Management',
    'UX/UI Design',
    'Business Strategy',
    'Marketing',
    'Data Science',
    'Financial Planning',
  ];

  final List<String> _experienceLevels = [
    'Entry Level (1-2 years)',
    'Intermediate (3-5 years)',
    'Advanced (5-10 years)',
    'Expert (10+ years)',
  ];

  @override
  void initState() {
    super.initState();
    _loadExpertData();
  }

  Future<void> _loadExpertData() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);

    try {
      final userEmail = AuthUtils().currentUserEmail;
      if (userEmail == null) {
        throw Exception('User not logged in');
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('experts')
          .where('email', isEqualTo: userEmail)
          .get();
          
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        if (mounted) {
          setState(() {
            _nameController.text = data['name'] ?? '';
            _bioController.text = data['bio'] ?? '';
            _hourlyRateController.text = (data['hourlyRate'] ?? '').toString();
            _selectedExpertiseArea = data['category'] ?? _selectedExpertiseArea;
            _selectedExperienceLevel = data['experienceLevel'] ?? _selectedExperienceLevel;
            _imageUrl = data['profilePicture'];
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userEmail = AuthUtils().currentUserEmail;
      if (userEmail == null) throw Exception('User not logged in');

      final expertData = {
        'name': _nameController.text,
        'bio': _bioController.text,
        'hourlyRate': double.tryParse(_hourlyRateController.text) ?? 0,
        'category': _selectedExpertiseArea,
        'experienceLevel': _selectedExperienceLevel,
        'email': userEmail,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Find expert document by email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('experts')
          .where('email', isEqualTo: userEmail)
          .get();

      String docId;
      if (querySnapshot.docs.isEmpty) {
        // Create new expert document
        docId = FirebaseFirestore.instance.collection('experts').doc().id;
        await FirebaseFirestore.instance.collection('experts').doc(docId).set(expertData);
      } else {
        // Update existing expert document
        docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance.collection('experts').doc(docId).update(expertData);
      }

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile image
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                      ),
                      child: Center(
                        child: _imageUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  _imageUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.person,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Image upload coming soon'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bio field
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your bio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Expertise area dropdown
              DropdownButtonFormField<String>(
                value: _selectedExpertiseArea,
                decoration: InputDecoration(
                  labelText: 'Area of Expertise',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _expertiseAreas.map((area) {
                  return DropdownMenuItem(
                    value: area,
                    child: Text(area),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExpertiseArea = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Experience level dropdown
              DropdownButtonFormField<String>(
                value: _selectedExperienceLevel,
                decoration: InputDecoration(
                  labelText: 'Experience Level',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _experienceLevels.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExperienceLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Hourly rate field
              TextFormField(
                controller: _hourlyRateController,
                decoration: InputDecoration(
                  labelText: 'Hourly Rate (USD)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your hourly rate';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}