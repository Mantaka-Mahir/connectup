import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationUtils {
  // Payment success animation
  static Widget paymentSuccessAnimation({
    double size = 200,
    bool repeat = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: Lottie.asset(
        'assets/success_animation.json',
        repeat: repeat,
        fit: BoxFit.contain,
      ),
    );
  }

  // Payment processing animation (pending)
  static Widget paymentProcessingAnimation({
    double size = 200,
    bool repeat = true,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
          strokeWidth: size / 20,
        ),
      ),
    );
  }

  // Mobile payment animation (for mobile banking)
  static Widget mobilePaymentAnimation({
    double size = 200,
    bool repeat = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.shade50,
      ),
      child: Icon(
        Icons.phone_android,
        size: size * 0.6,
        color: Colors.blue,
      ),
    );
  }

  // Card payment animation (for credit cards)
  static Widget cardPaymentAnimation({
    double size = 200,
    bool repeat = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.shade50,
      ),
      child: Icon(
        Icons.credit_card,
        size: size * 0.6,
        color: Colors.blue,
      ),
    );
  }
}
