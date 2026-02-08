import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/journal_controller.dart';
import '../models/journal_model.dart';

class JournalScreen extends StatelessWidget {
  JournalScreen({super.key});

  final JournalController controller = Get.find();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        title: const Text(
          'Journal',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          _writeSection(),
          Expanded(child: _journalList()),
        ],
      ),
    );
  }

  // ───────────────── WRITE SECTION ─────────────────

  Widget _writeSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How are you feeling?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 4,
              style: const TextStyle(fontSize: 15, height: 1.4),
              decoration: const InputDecoration(
                hintText: 'Write freely. This space is yours.',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              return Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: controller.isSaving.value
                      ? null
                      : () async {
                    await controller.addJournal(
                      _textController.text,
                    );
                    _textController.clear();
                  },
                  child: controller.isSaving.value
                      ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Save entry',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }


  Widget _journalList() {
    return Obx(() {
      if (controller.journals.isEmpty) {
        return const Center(
          child: Text(
            'No entries yet.\nStart by writing one above.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black45,
              height: 1.4,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: controller.journals.length,
        itemBuilder: (_, i) {
          final entry = controller.journals[i];
          return _journalCard(entry);
        },
      );
    });
  }


  Widget _journalCard(JournalEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _formatDate(entry.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
              const Spacer(),
              IconButton(
                splashRadius: 18,
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: () => _openEditSheet(entry),
              ),
              IconButton(
                splashRadius: 18,
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: () => _confirmDelete(entry),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            entry.text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }


  void _openEditSheet(JournalEntry entry) {
    final editController = TextEditingController(text: entry.text);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Edit entry',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: editController,
              maxLines: 6,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF4F5F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  await controller.updateJournal(
                    entry.id,
                    editController.text,
                  );
                  Get.back();
                },
                child: const Text('Update entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(JournalEntry entry) {
    Get.defaultDialog(
      title: 'Delete entry?',
      middleText: 'This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await controller.deleteJournal(entry.id);
        Get.back();
      },
    );
  }


  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} • '
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}