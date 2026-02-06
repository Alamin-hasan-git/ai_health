import 'package:firebase_ai/firebase_ai.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/assesment_controller.dart';

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
    'can’t go on',
    'cant go on',
    'give up on life',
    'self harm',
    'hurt myself',
    'everything is pointless',
    'i am done',
    'i want to disappear',
  ];

  bool _isCrisisMessage(String message) {
    final lower = message.toLowerCase();
    return _crisisKeywords.any((k) => lower.contains(k));
  }

  String _buildSystemPrompt() {
    final category = assessmentController.category.value;
    final score = assessmentController.totalScore.value;

    return '''
You are an AI mental health companion.

User context:
- Mental health category: $category
- Assessment score: $score

Rules:
- Be empathetic, calm, and non-judgmental
- Do NOT diagnose mental illness
- Do NOT prescribe medication
- Use simple, human language
- Ask gentle follow-up questions
- Never encourage dependency on AI
- If self-harm or suicide appears, escalate immediately
''';
  }

  Future<void> _forceOpenDialer() async {
    final uri = Uri.parse('tel:999');

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<String> sendMessage({
    required String userMessage,
    required String feelingPrompt,
    required List<String> history,
  }) async {
    // 🚨 CRISIS PATH
    if (_isCrisisMessage(userMessage)) {
      // 🔥 FORCE DIALER IMMEDIATELY
      _forceOpenDialer();

      return '''
I’m really glad you reached out.

What you’re feeling is serious, and you deserve immediate help.
I’ve opened your phone dialer now.

📞 Please call **999** or go to the nearest emergency service.
You matter, and help is available right now.
''';
    }

    final systemPrompt = _buildSystemPrompt();

    final fullPrompt = '''
$systemPrompt

USER EMOTIONAL CONTEXT:
$feelingPrompt

CONVERSATION HISTORY:
${history.join('\n')}

USER MESSAGE:
$userMessage
''';

    try {
      final response =
      await _model.generateContent([Content.text(fullPrompt)]);

      return response.text?.trim() ??
          'I’m here with you. Can you tell me more?';
    } catch (_) {
      return 'I’m here with you. Let’s take this one step at a time.';
    }
  }
}