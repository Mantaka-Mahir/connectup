import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/expert.dart';
import '../utils/app_styles.dart';
import '../utils/animation_utils.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Expert expert;
  final String selectedDate;
  final String selectedTime;
  final int duration;
  final double totalCost;

  const BookingConfirmationScreen({
    super.key,
    required this.expert,
    required this.selectedDate,
    required this.selectedTime,
    required this.duration,
    required this.totalCost,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  int _currentStep = 0;
  String _selectedPaymentMethod = 'card';
  bool _isPaymentSuccessful = false;
  bool _isProcessing = false;
  
  // Card details
  final TextEditingController _cardNumberController = TextEditingController(text: "4111 1111 1111 1111");
  final TextEditingController _cardHolderController = TextEditingController(text: "John Doe");
  final TextEditingController _expiryDateController = TextEditingController(text: "05/25");
  final TextEditingController _cvvController = TextEditingController(text: "123");

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isPaymentSuccessful ? 'Payment Complete' : 'Payment',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        leading: _isPaymentSuccessful 
          ? null 
          : IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
              onPressed: () => Navigator.pop(context),
            ),
      ),
      body: _isPaymentSuccessful
          ? _buildPaymentSuccessful()
          : Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 1) {
                  setState(() {
                    _currentStep += 1;
                  });
                } else {
                  _processPayment();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      if (_currentStep < 1) ...[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Continue',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isProcessing 
                              ? null 
                              : details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isProcessing
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Pay Now \$${widget.totalCost.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: details.onStepCancel,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                        child: Text(
                          _currentStep == 0 ? 'Cancel' : 'Back',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              steps: [
                Step(
                  title: Text(
                    'Payment Method',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  content: _buildPaymentMethodSelection(),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: Text(
                    'Review',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  content: _buildReviewSummary(),
                  isActive: _currentStep >= 1,
                ),
              ],
            ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Credit & Debit Card',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        _buildPaymentMethodCard(
          icon: Icons.credit_card,
          title: 'Add New Card',
          isSelected: _selectedPaymentMethod == 'card',
          onTap: () => setState(() => _selectedPaymentMethod = 'card'),
        ),
        
        const SizedBox(height: 20),
        
        Text(
          'More Payment Options',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        
        _buildPaymentMethodCard(
          icon: Icons.apple,
          title: 'Apple Pay',
          isSelected: _selectedPaymentMethod == 'apple',
          onTap: () => setState(() => _selectedPaymentMethod = 'apple'),
        ),
        const SizedBox(height: 10),
        _buildPaymentMethodCard(
          icon: Icons.payment,
          title: 'Paypal',
          isSelected: _selectedPaymentMethod == 'paypal',
          onTap: () => setState(() => _selectedPaymentMethod = 'paypal'),
        ),
        const SizedBox(height: 10),
        _buildPaymentMethodCard(
          icon: Icons.phone_android,
          title: 'Mobile Banking',
          isSelected: _selectedPaymentMethod == 'mobile',
          onTap: () => setState(() => _selectedPaymentMethod = 'mobile'),
        ),
        
        if (_selectedPaymentMethod == 'card') ...[
          const SizedBox(height: 24),
          _buildCardDetailsForm(),
        ]
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey.shade700,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Details',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        
        // Card preview
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Credit Card',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.credit_card,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                _cardNumberController.text,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARD HOLDER',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        _cardHolderController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXPIRES',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        _expiryDateController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Card Holder Name
        Text(
          'Card Holder Name',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _cardHolderController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Name on card',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: GoogleFonts.poppins(),
          onChanged: (value) => setState(() {}),
        ),
        
        const SizedBox(height: 16),
        
        // Card Number
        Text(
          'Card Number',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _cardNumberController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '0000 0000 0000 0000',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: Icon(
              Icons.credit_card,
              color: Colors.grey.shade600,
            ),
          ),
          style: GoogleFonts.jetBrainsMono(),
          keyboardType: TextInputType.number,
          onChanged: (value) => setState(() {}),
        ),
        
        const SizedBox(height: 16),
        
        // Expiry Date and CVV
        Row(
          children: [
            // Expiry Date
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expiry Date',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _expiryDateController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    style: GoogleFonts.jetBrainsMono(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {}),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // CVV
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CVV',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '000',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: Icon(
                        Icons.info_outline,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    style: GoogleFonts.jetBrainsMono(),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    onChanged: (value) => setState(() {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Session Cost Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TK ${widget.totalCost.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              
              // Expert info
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    radius: 20,
                    child: Icon(
                      Icons.person,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.expert.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        'Session Expert',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.expert.rating.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const Divider(height: 32),
              
              // Date and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date / Hour',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${widget.selectedDate}, ${widget.selectedTime}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Duration
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Duration',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${widget.duration} Minutes',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Booking for
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking for',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    'Myself',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 32),
              
              // Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    'TK ${widget.totalCost.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Duration calculation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Duration',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${widget.duration} Minutes',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 32),
              
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    'TK ${widget.totalCost.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Payment method display
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Method',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep = 0;
                });
              },
              child: Text(
                'Change',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Selected payment method indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                _getPaymentMethodIcon(),
                color: Colors.grey.shade700,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                _getPaymentMethodName(),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              if (_selectedPaymentMethod == 'card') ...[
                const Spacer(),
                Text(
                  '**** ${_cardNumberController.text.split(' ').last}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSuccessful() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [          // Success animation
          AnimationUtils.paymentSuccessAnimation(),
          const SizedBox(height: 24),
          
          Text(
            'Congratulations',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Payment is Successful',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 40),
          
          // Booking details
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(
              children: [
                Text(
                  'You have successfully booked an appointment with',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.expert.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.selectedDate,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.selectedTime,
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
          const SizedBox(height: 40),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to bookings screen (would be implemented in a real app)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('View Bookings (Dummy)'),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'View Bookings',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Pop back to home screen
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Home',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentMethodIcon() {
    switch (_selectedPaymentMethod) {
      case 'card':
        return Icons.credit_card;
      case 'apple':
        return Icons.apple;
      case 'paypal':
        return Icons.payment;
      case 'mobile':
        return Icons.phone_android;
      default:
        return Icons.credit_card;
    }
  }

  String _getPaymentMethodName() {
    switch (_selectedPaymentMethod) {
      case 'card':
        return 'Credit Card';
      case 'apple':
        return 'Apple Pay';
      case 'paypal':
        return 'PayPal';
      case 'mobile':
        return 'Mobile Banking';
      default:
        return 'Credit Card';
    }
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });
    
    // Simulate payment processing delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
        _isPaymentSuccessful = true;
      });
    });
  }
}
