import 'package:flutter/material.dart';
import 'expert.dart';

enum SessionStatus {
  upcoming,
  completed,
  cancelled,
}

class Session {
  final String id;
  final Expert expert;
  final DateTime dateTime;
  final int durationMinutes;
  final double cost;
  final SessionStatus status;

  Session({
    required this.id,
    required this.expert,
    required this.dateTime,
    required this.durationMinutes,
    required this.cost,
    required this.status,
  });

  // Format date as "May 12, 2025"
  String get formattedDate {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June', 
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  // Format time as "10:30 AM"
  String get formattedTime {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final hour12 = hour == 0 ? 12 : hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour12:$minute $period';
  }

  // Get color based on status
  Color get statusColor {
    switch (status) {
      case SessionStatus.upcoming:
        return Colors.blue;
      case SessionStatus.completed:
        return Colors.green;
      case SessionStatus.cancelled:
        return Colors.red;
    }
  }

  // Get text based on status
  String get statusText {
    switch (status) {
      case SessionStatus.upcoming:
        return 'Upcoming';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
