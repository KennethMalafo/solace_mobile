import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100], // Setting the background color
      body: ListView(
        children: const [
          NotificationCard(
            level: 'critical',
            message: 'Emergency alert: critical',
            time: '11:30',
            date: 'Nov 10 2024',
          ),
          NotificationCard(
            level: 'warning',
            message: 'Emergency alert: warning',
            time: '10:09',
            date: 'Nov 19 2024',
          ),
          NotificationCard(
            level: 'warning',
            message: 'Emergency alert: warning',
            time: '09:09',
            date: 'Nov 1 2023',
          ),
          NotificationCard(
            level: 'warning',
            message: 'Emergency alert: warning',
            time: '08:09',
            date: 'Nov 20 2020',
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String level;
  final String message;
  final String time;
  final String date;

  const NotificationCard({
    super.key,
    required this.level,
    required this.message,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.blue[100]!,
            Colors.blue[300]!,
            Colors.blue[500]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Ensuring the border radius matches
        ),
        color: Colors.transparent, // Transparent to show gradient background
        elevation: 0, // Removing elevation shadow
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('images/mdrrmo.png'), // Example image
          ),
          title: Text(message),
          subtitle: Text('$time, $date'),
        ),
      ),
    );
  }
}