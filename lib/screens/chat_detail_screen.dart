import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat.dart';
import '../utils/app_styles.dart';

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;
  
  const ChatDetailScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isRecording = false;
  
  @override
  void initState() {
    super.initState();
    // Add dummy messages
    _loadDummyMessages();
  }
  
  void _loadDummyMessages() {
    final now = DateTime.now();
    
    // Add some dummy messages
    _messages.addAll([
      ChatMessage(
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        timestamp: now.subtract(const Duration(minutes: 55)),
        isMe: false,
      ),
      ChatMessage(
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isMe: true,
      ),
      ChatMessage(
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        timestamp: now.subtract(const Duration(minutes: 25)),
        isMe: false,
      ),
      ChatMessage(
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isMe: true,
      ),
      ChatMessage(
        isVoiceMessage: true,
        voiceDuration: '00:50',
        timestamp: now.subtract(const Duration(minutes: 2)),
        isMe: false,
      ),
    ]);
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            // Profile image with online indicator
            Stack(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: AssetImage(widget.chat.profileImage),
                  child: widget.chat.profileImage.contains('assets/')
                      ? null
                      : Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 16,
                        ),
                ),
                // Online indicator
                if (widget.chat.isOnline)
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
              widget.chat.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: AppColors.text,
                fontSize: 16,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.text,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            color: AppColors.primary,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video call functionality (Demo)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined),
            color: AppColors.primary,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice call functionality (Demo)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[_messages.length - 1 - index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          
          // Is typing indicator
          if (widget.chat.name == 'Dr. Olivia Chen')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                'Dr. Olivia is typing...',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          
          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Attachment button
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  color: AppColors.textLight,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Attachment functionality (Demo)'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                // Text input
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
                        hintText: 'Write here...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // Could implement typing indicator logic here
                        setState(() {});
                      },
                    ),
                  ),
                ),
                // Mic/Send button
                IconButton(
                  icon: Icon(
                    _messageController.text.isNotEmpty
                        ? Icons.send
                        : _isRecording ? Icons.stop : Icons.mic,
                  ),
                  color: AppColors.primary,
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      // Send text message
                      setState(() {
                        _messages.insert(
                          0,
                          ChatMessage(
                            text: _messageController.text,
                            timestamp: DateTime.now(),
                            isMe: true,
                          ),
                        );
                        _messageController.clear();
                      });
                    } else {
                      // Handle voice message recording
                      setState(() {
                        _isRecording = !_isRecording;
                      });
                      
                      if (!_isRecording) {
                        // If stopping recording, add a voice message
                        setState(() {
                          _messages.insert(
                            0,
                            ChatMessage(
                              isVoiceMessage: true,
                              voiceDuration: '00:15',
                              timestamp: DateTime.now(),
                              isMe: true,
                            ),
                          );
                        });
                      }
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isRecording ? 'Recording started...' : 'Voice message sent (Demo)',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
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
            'Start the conversation',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageBubble(ChatMessage message) {
    // Format timestamp
    final hour = message.timestamp.hour > 12 
        ? message.timestamp.hour - 12 
        : message.timestamp.hour == 0 ? 12 : message.timestamp.hour;
    final minute = message.timestamp.minute.toString().padLeft(2, '0');
    final period = message.timestamp.hour >= 12 ? 'PM' : 'AM';
    final timeString = '$hour:$minute $period';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: AssetImage(widget.chat.profileImage),
              child: widget.chat.profileImage.contains('assets/')
                  ? null
                  : Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 16,
                    ),
            ),
          const SizedBox(width: 8),
          // Message content
          Flexible(
            child: Container(
              padding: message.isVoiceMessage
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isMe
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: !message.isMe
                    ? Border.all(color: Colors.grey.shade200)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (message.isVoiceMessage)
                    // Voice message
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_circle_fill,
                          color: message.isMe
                              ? AppColors.primary
                              : AppColors.textLight,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 120,
                          height: 2,
                          decoration: BoxDecoration(
                            color: message.isMe
                                ? AppColors.primary
                                : AppColors.textLight,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          message.voiceDuration!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: message.isMe
                                ? AppColors.primary
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    )
                  else
                    // Text message
                    Text(
                      message.text!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: message.isMe
                            ? AppColors.text
                            : AppColors.text,
                      ),
                    ),
                  const SizedBox(height: 4),
                  // Timestamp
                  Text(
                    timeString,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),          const SizedBox(width: 8),
          if (message.isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: AppColors.primary,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String? text;
  final DateTime timestamp;
  final bool isMe;
  final bool isVoiceMessage;
  final String? voiceDuration;

  ChatMessage({
    this.text,
    required this.timestamp,
    required this.isMe,
    this.isVoiceMessage = false,
    this.voiceDuration,
  });
}
