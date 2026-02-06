import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../agent/ai_chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _ai = AiChatService();

  final List<ChatMessage> _messages = [];
  final List<String> _history = [];

  late String moodKey;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};
    moodKey = args['moodKey'] ?? 'Sad';

    final openingMessage =
        args['openingMessage'] ?? 'I’m here with you. What’s on your mind?';

    _messages.add(
      ChatMessage(
        text: openingMessage,
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> _send() async {
    if (_controller.text.trim().isEmpty) return;

    final userText = _controller.text.trim();
    _controller.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          text: userText,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    _history.add('User: $userText');

    final reply = await _ai.sendMessage(
      userMessage: userText,
      moodKey: moodKey,
      history: _history,
    );

    if (!mounted) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: reply,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });

    _history.add('AI: $reply');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(26),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'A safe space to talk',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[_messages.length - 1 - i];
                return _chatBubble(msg);
              },
            ),
          ),
          _input(),
        ],
      ),
    );
  }

  Widget _chatBubble(ChatMessage msg) {
    final isUser = msg.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              constraints: const BoxConstraints(maxWidth: 330),
              decoration: BoxDecoration(
                color: isUser ? Colors.deepPurple : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft:
                  isUser ? const Radius.circular(20) : const Radius.circular(6),
                  bottomRight:
                  isUser ? const Radius.circular(6) : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15.5,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(msg.timestamp),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Type your message…',
                    hintStyle: TextStyle(color: Colors.black38),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _send,
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}