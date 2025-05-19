import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat.dart';
import '../utils/app_styles.dart';

class MessageScreen extends StatefulWidget {
  final String receiverName;
  final String profileImage;
  final bool isOnline;

  const MessageScreen({
    Key? key,
    required this.receiverName,
    this.profileImage = 'assets/placeholder.png',
    this.isOnline = false,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add dummy messages
    _addDummyMessages();
  }

  void _addDummyMessages() {
    final now = DateTime.now();
    _messages.addAll([
      Message(
        id: '1',
        text: 'Hello! How are you doing today?',
        timestamp: now.subtract(const Duration(minutes: 45)),
        isSentByMe: false,
      ),
      Message(
        id: '2',
        text: 'I\'m doing well, thank you for asking! How about you?',
        timestamp: now.subtract(const Duration(minutes: 43)),
        isSentByMe: true,
      ),
      Message(
        id: '3',
        text: 'I\'m good as well. Are you available for a session tomorrow?',
        timestamp: now.subtract(const Duration(minutes: 40)),
        isSentByMe: false,
      ),
      Message(
        id: '4',
        text: 'Yes, I should be free in the afternoon. What time works for you?',
        timestamp: now.subtract(const Duration(minutes: 38)),
        isSentByMe: true,
      ),
      Message(
        id: '5',
        text: 'How about 3 PM? Would that work for you?',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isSentByMe: false,
      ),
      Message(
        id: '6',
        text: '3 PM works perfectly for me. I\'ll send you the meeting details shortly.',
        timestamp: now.subtract(const Duration(minutes: 28)),
        isSentByMe: true,
      ),
      Message(
        id: '7',
        text: 'Great! Looking forward to our session.',
        timestamp: now.subtract(const Duration(minutes: 25)),
        isSentByMe: false,
      ),
    ]);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isSentByMe: true,
        ),
      );
    });

    _messageController.clear();
    
    // Scroll to the bottom after sending a message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour == 0 ? 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.text,
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // Profile image
            Stack(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withAlpha(26), // 0.1 * 255 ≈ 26
                  backgroundImage: AssetImage(widget.profileImage),
                ),
                if (widget.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            // Name
            Text(
              widget.receiverName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            color: AppColors.primary,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Call feature coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            color: AppColors.primary,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video call feature coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(message);
              },
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                // Attachment button
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  color: AppColors.textLight,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Attachment feature coming soon!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                
                // Text field
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                
                // Send button
                IconButton(
                  icon: const Icon(Icons.send),
                  color: AppColors.primary,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Message message) {
    return Align(
      alignment: message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: message.isSentByMe ? 64 : 0,
          right: message.isSentByMe ? 0 : 64,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isSentByMe
              ? AppColors.primary.withAlpha(26) // 0.1 * 255 ≈ 26
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isSentByMe ? 16 : 0),
            bottomRight: Radius.circular(message.isSentByMe ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13), // 0.05 * 255 ≈ 13
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
