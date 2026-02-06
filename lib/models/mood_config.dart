class MoodConfig {
  final String feelingPrompt;
  final String openingMessage;

  const MoodConfig({
    required this.feelingPrompt,
    required this.openingMessage,
  });
}

const Map<String, MoodConfig> moodMap = {
  'Sad': MoodConfig(
    feelingPrompt:
    'The user feels sad, emotionally heavy, and possibly lonely.',
    openingMessage:
    'I’m really sorry you’re feeling this way. Do you want to tell me what’s been making you feel sad?',
  ),
  'Anxious': MoodConfig(
    feelingPrompt:
    'The user feels anxious, worried, and stuck in overthinking.',
    openingMessage:
    'It sounds like your mind might be racing. What’s been making you feel anxious?',
  ),
  'Angry': MoodConfig(
    feelingPrompt:
    'The user feels angry and frustrated about a situation or person.',
    openingMessage:
    'Something clearly upset you. What happened?',
  ),
  'Tired': MoodConfig(
    feelingPrompt:
    'The user feels emotionally and physically exhausted.',
    openingMessage:
    'Feeling tired like this can be heavy. What’s been draining your energy lately?',
  ),
};