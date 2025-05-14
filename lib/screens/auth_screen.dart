import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_styles.dart';
import '../utils/auth_utils.dart';
import 'experts_screen.dart';
import 'user_type_selection_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Form keys for validation
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  // Password visibility toggle
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Clear focus when switching tabs
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Connect Up',
          style: GoogleFonts.poppins(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tab Bar
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textLight,
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                splashBorderRadius: BorderRadius.circular(12),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Login'),
                  Tab(text: 'Sign Up'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Login Tab
                  _buildLoginForm(),
                  
                  // Sign Up Tab
                  _buildSignUpForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome message
            Text(
              'Welcome back!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to continue your mentorship journey',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),            const SizedBox(height: 30),
            
            // Email Field
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Try expert@gmail.com for expert access',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            
            // Password Field
            _buildPasswordField(controller: _passwordController),
            
            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Forgot password functionality (Dummy)')),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Login Button
            _buildActionButton(
              label: 'Log In',
              onPressed: () => _handleLogin(),
            ),
            
            const SizedBox(height: 20),
            
            // Or divider
            _buildOrDivider(),
            
            const SizedBox(height: 20),
              // Google Sign In Button
            _buildSocialLoginButton(
              label: 'Continue with Google',
              icon: 'google',
              onPressed: () => _handleGoogleSignIn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return SingleChildScrollView(
      child: Form(
        key: _signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome message
            Text(
              'Create Account',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Join our community of mentors and mentees',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 30),
            
            // Name Field
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'John Doe',
              icon: Icons.person_outline,
            ),            const SizedBox(height: 20),
            
            // Email Field
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Try expert@gmail.com for expert access',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            
            // Password Field
            _buildPasswordField(controller: _passwordController),
            
            const SizedBox(height: 10),
            
            // Terms and Privacy Policy
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'By signing up, you agree to our Terms and Privacy Policy',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Sign Up Button
            _buildActionButton(
              label: 'Sign Up',
              onPressed: () => _handleSignUp(),
            ),
            
            const SizedBox(height: 20),
            
            // Or divider
            _buildOrDivider(),
            
            const SizedBox(height: 20),
              // Google Sign In Button
            _buildSocialLoginButton(
              label: 'Sign up with Google',
              icon: 'google',
              onPressed: () => _handleGoogleSignIn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: AppColors.text,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey,
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: _obscurePassword,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: AppColors.text,
            ),            decoration: InputDecoration(
              hintText: 'Same as email (expert@gmail.com)',
              hintStyle: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppColors.primary,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
      ],
    );
  }
  Widget _buildSocialLoginButton({
    required String label,
    required String icon, // We're not using this parameter, but keeping it for consistency
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      icon: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Center(
          child: Text(
            "G",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }  // Handlers
  void _handleLogin() {
    if (_loginFormKey.currentState!.validate()) {
      // Check for dummy test account
      final email = _emailController.text.trim();
      final password = _passwordController.text;
        // Use AuthUtils to handle login
      final authUtils = AuthUtils();
      final success = authUtils.login(email, password, userType: 'mentee'); // Default to mentee for login screen
        if (success) {
        // Check if it's one of the test accounts
        final isTestAccount = authUtils.isTestAccount;
        final isExpertAccount = email == AuthUtils.expertTestEmail;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isExpertAccount 
                ? 'Expert test account login successful' 
                : isTestAccount 
                  ? 'Test account login successful' 
                  : 'Login successful (Dummy)'),
            backgroundColor: isTestAccount ? Colors.green : null,
            duration: const Duration(seconds: 2),
          ),);          // Navigate based on user type after successful login
        Future.delayed(const Duration(seconds: 1), () {
          // Check if user is an expert
          if (authUtils.isExpert) {
            Navigator.pushReplacementNamed(context, '/expert-dashboard');
          } else {
            // Default to experts screen for mentees
            Navigator.pushReplacementNamed(context, '/experts');
          }
        });
      } else {
        // This won't happen in our dummy implementation, but good to have
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }  void _handleSignUp() {
    if (_signupFormKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      
      if (email == AuthUtils.testEmail) {
        // Inform user that this is a test account
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This is a predefined test account. You can log in directly.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
        
        // Switch to login tab
        Future.delayed(const Duration(milliseconds: 500), () {
          _tabController.animateTo(0);
        });
      } else {
        // Regular signup flow with AuthUtils
        final authUtils = AuthUtils();
        authUtils.login(email, _passwordController.text); // Automatically log them in after signup
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! (Dummy)'),
            duration: Duration(seconds: 2),
          ),
        );
        
        // Navigate to the user type selection screen
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserTypeSelectionScreen()),
          );
        });
      }
    }
  }

  void _handleGoogleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign-In (Dummy)'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // If this was from sign up tab, navigate to user type selection
    if (_tabController.index == 1) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserTypeSelectionScreen()),
        );
      });
    } else {
      // Just show success for login
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }
}
