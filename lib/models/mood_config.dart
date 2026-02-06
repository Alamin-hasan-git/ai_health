class MoodConfig {
  final String systemDirective;
  final String openingMessage;

  const MoodConfig({
    required this.systemDirective,
    required this.openingMessage,
  });
}

const Map<String, MoodConfig> moodMap = {
  'Sad': MoodConfig(
    systemDirective: '''
Respond slowly and gently.
Focus on emotional validation.
Avoid advice unless the user asks.
Use comforting, warm language.
''',
    openingMessage:
    'I’m really sorry you’re feeling this way. Do you want to tell me what’s been weighing on you?',
  ),

  'Anxious': MoodConfig(
    systemDirective: '''
Help the user slow their thoughts.
Break concerns into small pieces.
Ask grounding, present-focused questions.
Avoid overwhelming explanations.
''',
    openingMessage:
    'It sounds like your mind might be racing. What’s the biggest worry right now?',
  ),

  'Angry': MoodConfig(
    systemDirective: '''
Acknowledge frustration without judgment.
Do not mirror anger.
Encourage expression without blame.
Guide toward clarity and understanding.
''',
    openingMessage:
    'Something clearly upset you. What happened?',
  ),

  'Tired': MoodConfig(
    systemDirective: '''
Keep responses short and low-effort.
Avoid pushing motivation or action.
Focus on rest and relief.
Use calm, grounding language.
''',
    openingMessage:
    'Feeling this drained can be heavy. What’s been taking most of your energy lately?',
  ),
};