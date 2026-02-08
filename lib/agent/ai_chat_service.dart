import 'package:firebase_ai/firebase_ai.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/assesment_controller.dart';
import '../models/mood_config.dart';

class AiChatService {
  final AssessmentController assessmentController =
  Get.find<AssessmentController>();

  final GenerativeModel _model =
  FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash-lite',

  );

  final List<String> _crisisKeywords = [
    'suicide',
    'kill myself',
    'end my life',
    'want to die',
    'no reason to live',
    'hurt myself',
    'self harm',
    'can’t go on',
    'cant go on',
    'everything is pointless',
    'i want to disappear',
  ];

  bool _isCrisisMessage(String message) {
    final lower = message.toLowerCase();
    return _crisisKeywords.any((k) => lower.contains(k));
  }

  String _buildSystemPrompt(String moodKey) {
    final category = assessmentController.category.value;
    final score = assessmentController.totalScore.value;

    final moodDirective =
        moodMap[moodKey]?.systemDirective ?? '';

    return '''
You are an AI mental health companion.

User context:
- Narrative category: $category
- Assessment score: $score

Behavior rules:
$moodDirective

Global rules:
- Be empathetic, calm, and human
- Do NOT diagnose mental illness
- Do NOT prescribe medication
- Do NOT present yourself as the only support
- Ask only ONE gentle follow-up question
- Use simple, everyday language
- If self-harm appears, follow crisis protocol
''';
  }

  Future<void> _openDialer() async {
    final uri = Uri.parse('tel:999');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<String> sendMessage({
    required String userMessage,
    required String moodKey,
    required List<String> history,
  }) async {
    if (_isCrisisMessage(userMessage)) {
      _openDialer();
      return '''
I’m really glad you told me this.

When someone says things like that, it can mean they’re feeling overwhelmed or unsafe.
Before we go further, I need to ask something important:3

👉 Are you feeling at risk of hurting yourself right now?

If yes, please contact **999** or go to the nearest emergency service.
If you can, tell me whether someone nearby can help support you.
''';
    }

    final systemPrompt = _buildSystemPrompt(moodKey);

    final fullPrompt = '''
$systemPrompt

Conversation so far:
${history.join('\n')}

User message:
$userMessage
''';

    try {
      final response =
      await _model.generateContent(
        [Content.text(fullPrompt)],
      );

      return response.text?.trim() ??
          'I’m here with you. Can you tell me a little more?';
    } catch (_) {
      return 'I’m here with you. Let’s take this one step at a time.';
    }
  }
}