import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityChat extends StatefulWidget {
  final String roomId;
  const CommunityChat({super.key, required this.roomId});

  @override
  State<CommunityChat> createState() => _CommunityChatState();
}

class _CommunityChatState extends State<CommunityChat> {
  final TextEditingController _controller = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Color _avatarColor(String senderId) {
    final hash = senderId.hashCode;
    final colors = <Color>[
      const Color(0xFF667EEA),
      const Color(0xFF10B981),
      const Color(0xFFEC4899),
      const Color(0xFFF59E0B),
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
    ];
    return colors[hash.abs() % colors.length];
  }

  String _avatarText({required String senderId, required bool isMe}) {
    if (isMe) return 'You';
    final clean = senderId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    if (clean.isEmpty) return 'U';
    return clean.length >= 2 ? clean.substring(0, 2).toUpperCase() : clean.substring(0, 1).toUpperCase();
  }

  Widget _chatHead({
    required String senderId,
    required bool isMe,
  }) {
    final bg = isMe ? Theme.of(context).colorScheme.primary : _avatarColor(senderId);
    final fg = Colors.white;
    final text = _avatarText(senderId: senderId, isMe: isMe);

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('messages')
        .add({
      'text': _controller.text.trim(),
      'senderId': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text(
          'Community',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(widget.roomId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];
                    final senderId = (data['senderId'] ?? '').toString();
                    final isMe = senderId == uid;
                    final messageText = (data['text'] ?? '').toString();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment:
                            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe) ...[
                            _chatHead(senderId: senderId, isMe: false),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 280),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? scheme.primary
                                    : scheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 18),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                messageText,
                                style: TextStyle(
                                  color: isMe ? scheme.onPrimary : scheme.onSurface,
                                  fontSize: 14.5,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                          if (isMe) ...[
                            const SizedBox(width: 8),
                            _chatHead(senderId: senderId, isMe: true),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: scheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Type a message…',
                        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scheme.primary,
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
        ],
      ),
    );
  }
}