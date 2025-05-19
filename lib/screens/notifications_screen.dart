import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedFilter = 'All';

  final List<Map<String, String>> notifications = [
    {
      'icon': '🔔',
      'title': 'Session Reminder',
      'timestamp': '2h ago',
      'description': 'Your session with John is scheduled for tomorrow at 10 AM.'
    },
    {
      'icon': '🎉',
      'title': 'Special Offer',
      'timestamp': '1d ago',
      'description': 'Get 20% off on your next session. Limited time offer!'
    },
    {
      'icon': '📅',
      'title': 'New Session Available',
      'timestamp': '3d ago',
      'description': 'A new session slot is available with Dr. Smith.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('All'),
                _buildFilterButton('Sessions'),
                _buildFilterButton('Offers'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Text(
                      notification['icon']!,
                      style: TextStyle(fontSize: 24),
                    ),
                    title: Text(notification['title']!),
                    subtitle: Text(notification['description']!),
                    trailing: Text(notification['timestamp']!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedFilter == filter ? Colors.blue : Colors.grey,
      ),
      child: Text(filter),
    );
  }
}