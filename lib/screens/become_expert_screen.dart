import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_styles.dart';

class BecomeExpertScreen extends StatefulWidget {
  const BecomeExpertScreen({super.key});

  @override
  State<BecomeExpertScreen> createState() => _BecomeExpertScreenState();
}

class _BecomeExpertScreenState extends State<BecomeExpertScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  
  // Experience level options
  final List<String> _experienceLevels = [
    'Entry Level (1-2 years)',
    'Intermediate (3-5 years)',
    'Advanced (5-10 years)',
    'Expert (10+ years)'
  ];
  String _selectedExperienceLevel = 'Intermediate (3-5 years)';
  
  // Expertise areas
  final List<String> _availableExpertiseAreas = [
    'Software Development',
    'Product Management',
    'UX/UI Design',
    'Business Strategy',
    'Marketing',
    'Data Science',
    'Financial Planning',
    'Career Coaching',
    'Leadership',
    'Public Speaking',
  ];
  final List<String> _selectedExpertiseAreas = [];
  
  // Certification file (would be implemented with actual file picker)
  String? _certificateFileName;
  
  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Become an Expert',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.text,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // Introduction text
            Text(
              'Share your expertise and help others grow',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Name field
            Text(
              'Personal Information',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
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
                labelText: 'Professional Bio',
                hintText: 'Tell us about your background and expertise',
                prefixIcon: const Icon(Icons.description_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your bio';
                }
                if (value.length < 50) {
                  return 'Bio should be at least 50 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Expertise areas
            Text(
              'Areas of Expertise',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select all that apply',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableExpertiseAreas.map((area) {
                final isSelected = _selectedExpertiseAreas.contains(area);
                return FilterChip(
                  label: Text(area),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedExpertiseAreas.add(area);
                      } else {
                        _selectedExpertiseAreas.remove(area);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            if (_formKey.currentState != null && 
                _formKey.currentState!.validate() && 
                _selectedExpertiseAreas.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Please select at least one area of expertise',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            
            // Experience level
            Text(
              'Experience Level',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            ..._experienceLevels.map((level) => RadioListTile<String>(
              title: Text(
                level,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                ),
              ),
              value: level,
              groupValue: _selectedExperienceLevel,
              activeColor: AppColors.primary,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedExperienceLevel = value;
                  });
                }
              },
            )).toList(),
            const SizedBox(height: 24),
            
            // Certificate upload
            Text(
              'Upload Certification',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please upload any relevant certifications (PDF or images)',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                // Demo file picker action
                setState(() {
                  _certificateFileName = 'certification-${DateTime.now().millisecondsSinceEpoch}.pdf';
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File picker would open here (Demo)'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _certificateFileName != null 
                          ? Icons.description 
                          : Icons.upload_file,
                      size: 40,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _certificateFileName ?? 'Tap to upload certification',
                      style: GoogleFonts.poppins(
                        color: _certificateFileName != null 
                            ? AppColors.text 
                            : AppColors.textLight,
                      ),
                    ),
                    if (_certificateFileName != null) 
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _certificateFileName = null;
                          });
                        },
                        child: Text(
                          'Remove',
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Submit button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _selectedExpertiseAreas.isNotEmpty) {
                  // Demo submission
                  final snackBar = SnackBar(
                    content: const Text('Form submitted successfully!'),
                    backgroundColor: Colors.green,
                    action: SnackBarAction(
                      label: 'OK',
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                    duration: const Duration(seconds: 3),
                  );
                  
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  
                  // Print form data for demo purposes
                  print('Form submitted:');
                  print('Name: ${_nameController.text}');
                  print('Bio: ${_bioController.text}');
                  print('Expertise Areas: $_selectedExpertiseAreas');
                  print('Experience Level: $_selectedExperienceLevel');
                  print('Certificate: $_certificateFileName');
                } else if (_selectedExpertiseAreas.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select at least one area of expertise'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Submit Application',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
