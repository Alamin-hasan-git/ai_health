import 'package:firebase_ai/firebase_ai.dart';

class AiChatService {

  final GenerativeModel _model =
  FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
  );

  static const String _systemPrompt = '''
You are an AI mental health companion.

Rules:
- Be empathetic, calm, and non-judgmental.
- Do not diagnose mental illness.
- Do not prescribe medication.
- Use simple, human language.
- Ask thoughtful follow-up questions.
- If the user shows signs of self-harm or suicide, encourage seeking real human support.
''';

  Future<String> sendMessage({
    required String userMessage,
    required String feelingPrompt,
    required List<String> history,
  }) async {
    final fullPrompt = '''
$_systemPrompt

USER EMOTIONAL CONTEXT:
$feelingPrompt

CONVERSATION HISTORY:
${history.join('\n')}

USER MESSAGE:
$userMessage
''';

    try {
      final response = await _model.generateContent(
        [Content.text(fullPrompt)],
      );

      return response.text?.trim() ??
          'I’m here with you. Can you tell me more?';
    } catch (_) {
      return 'I’m here with you, even if something went wrong.';
    }
  }
}