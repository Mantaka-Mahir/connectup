import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_styles.dart';
import 'dart:math' as math;

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> with SingleTickerProviderStateMixin {
  final String _referralCode = 'CONNECT${math.Random().nextInt(10000)}';
  final String _referralLink = 'https://connectup.app/ref/';
  bool _isLinkCopied = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _copyReferralLink() {
    final referralLink = '$_referralLink$_referralCode';
    Clipboard.setData(ClipboardData(text: referralLink));
    setState(() {
      _isLinkCopied = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Referral link copied to clipboard!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // Reset the copied state after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLinkCopied = false;
        });
      }
    });
  }

  void _shareViaApp(String app) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sharing via $app... (Demo)',
          style: GoogleFonts.poppins(),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Refer & Earn',
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hero illustration
                _buildHeroIllustration(),
                const SizedBox(height: 24),
                
                // Main heading
                Text(
                  'Invite Friends & Earn Rewards',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Subheading
                Text(
                  'Share your referral link with friends and earn rewards when they join!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Earn banner
                _buildEarnBanner(),
                const SizedBox(height: 32),
                
                // Referral code section
                _buildReferralCodeSection(),
                const SizedBox(height: 32),
                
                // Share via section
                _buildShareViaSection(),
                const SizedBox(height: 24),
                
                // How it works section
                _buildHowItWorksSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroIllustration() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circles
                ...List.generate(3, (index) {
                  return Positioned(
                    left: 110 - (index * 15),
                    top: 110 - (index * 15),
                    child: Container(
                      width: (index + 1) * 30,
                      height: (index + 1) * 30,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05 * (3 - index)),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
                
                // Gift box icon
                Icon(
                  Icons.card_giftcard,
                  size: 80,
                  color: AppColors.primary,
                ),
                
                // Flying coins
                ...List.generate(5, (index) {
                  final angle = (index * (math.pi / 2.5));
                  final radius = 90.0;
                  final x = radius * math.cos(angle);
                  final y = radius * math.sin(angle);
                  
                  return Positioned(
                    left: 110 + x,
                    top: 110 + y,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '৳',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEarnBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade500, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Coin stack
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                const Positioned(
                  bottom: 10,
                  left: 15,
                  child: Text(
                    '৳',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: const Text(
                      '50',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earn 50 BDT',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'for each friend who signs up!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCodeSection() {
    return Column(
      children: [
        Text(
          'Your Referral Link',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_referralLink$_referralCode',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _copyReferralLink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isLinkCopied ? Colors.green : AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isLinkCopied ? Icons.check : Icons.copy,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isLinkCopied ? 'Copied' : 'Copy',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Or share your code: $_referralCode',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShareViaSection() {
    final shareOptions = [      {
        'name': 'WhatsApp',
        'icon': Icons.chat_bubble,
        'color': const Color(0xFF25D366),
      },
      {
        'name': 'Facebook',
        'icon': Icons.facebook,
        'color': const Color(0xFF1877F2),
      },
      {
        'name': 'Messenger',
        'icon': Icons.messenger_outlined,
        'color': const Color(0xFF0084FF),
      },
      {
        'name': 'Email',
        'icon': Icons.email,
        'color': const Color(0xFFEA4335),
      },
    ];

    return Column(
      children: [
        Text(
          'Share Via',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: shareOptions.map((option) {
            return Column(
              children: [
                InkWell(
                  onTap: () => _shareViaApp(option['name'] as String),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: (option['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      option['icon'] as IconData,
                      color: option['color'] as Color,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  option['name'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection() {
    final steps = [
      {
        'title': 'Share Your Link',
        'description': 'Share your unique referral link with friends',
        'icon': Icons.share,
      },
      {
        'title': 'Friends Sign Up',
        'description': 'When they register using your link',
        'icon': Icons.person_add,
      },
      {
        'title': 'Get Rewarded',
        'description': 'Earn 50 BDT for each successful signup',
        'icon': Icons.wallet_giftcard,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'How It Works',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          step['icon'] as IconData,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${step['title']}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            step['description'] as String,
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
                if (index < steps.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      height: 30,
                      child: VerticalDivider(
                        color: AppColors.primary.withOpacity(0.3),
                        thickness: 2,
                        width: 20,
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
