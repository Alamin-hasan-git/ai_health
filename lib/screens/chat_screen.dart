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

  late String userFeelingPrompt;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};

    userFeelingPrompt = args['feelingPrompt'] ??
        'The user wants to talk about their feelings.';
    final openingMessage = args['openingMessage'] ??
        'I’m here with you. What’s on your mind?';

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
      _messages.add(ChatMessage(
        text: userText,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _history.add('User: $userText');

    final reply = await _ai.sendMessage(
      userMessage: userText,
      feelingPrompt: userFeelingPrompt,
      history: _history,
    );

    if (!mounted) return;

    setState(() {
      _messages.add(ChatMessage(
        text: reply,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    _history.add('AI: $reply');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'A safe space to talk',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment:
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              color: isUser
                  ? Colors.deepPurple
                  : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft:
                isUser ? const Radius.circular(18) : Radius.zero,
                bottomRight:
                isUser ? Radius.zero : const Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          Text(
            _formatTime(msg.timestamp),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _input() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
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
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _send,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
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