import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat.dart';
import '../utils/app_styles.dart';
import '../utils/dummy_data.dart';
import 'message_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late List<Chat> chats;
  
  @override
  void initState() {
    super.initState();
    // Get dummy chat data
    chats = DummyData.getChats();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: AppColors.primary,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search functionality (Demo)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: chats.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: chats.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) => _buildChatCard(chats[index]),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_comment, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New message functionality (Demo)'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with an expert',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildChatCard(Chat chat) {
    // Format timestamp as "hh:mm" if today, or "MMM dd" if older
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      chat.timestamp.year, 
      chat.timestamp.month, 
      chat.timestamp.day
    );
    
    String formattedTime;
    if (messageDate == today) {
      // Format as time for today's messages
      final hour = chat.timestamp.hour > 12 
          ? chat.timestamp.hour - 12 
          : chat.timestamp.hour == 0 ? 12 : chat.timestamp.hour;
      final minute = chat.timestamp.minute.toString().padLeft(2, '0');
      final period = chat.timestamp.hour >= 12 ? 'PM' : 'AM';
      formattedTime = '$hour:$minute $period';
    } else {
      // Format as date for older messages
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      formattedTime = '${months[chat.timestamp.month - 1]} ${chat.timestamp.day}';
    }
      return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              receiverName: chat.name,
              profileImage: chat.profileImage,
              isOnline: chat.isOnline,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile image with online indicator
            Stack(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: AssetImage(chat.profileImage),
                  child: chat.profileImage.contains('assets/')
                      ? null
                      : Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 24,
                        ),
                ),
                // Online indicator
                if (chat.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: chat.isUnread
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: chat.isUnread
                              ? AppColors.primary
                              : AppColors.textLight,
                          fontWeight: chat.isUnread
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Last message with unread indicator
                  Row(
                    children: [
                      if (chat.isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: chat.isUnread
                                ? AppColors.text
                                : AppColors.textLight,
                            fontWeight: chat.isUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
