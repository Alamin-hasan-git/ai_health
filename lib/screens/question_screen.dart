import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controller/assesment_controller.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentQuestion = 0;
  int _totalScore = 0;
  bool _isAnswering = false;
  final List<int> _selectedAnswers = []; // Track answer for each question

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'After a stressful day, how do you usually feel?',
      'axis': 'Recovery (Emotional Strength)',
      'options': [
        {'text': 'I recover and feel balanced again', 'score': 2},
        {'text': 'I\'m still stressed but manageable', 'score': 1},
        {'text': 'I stay mentally exhausted', 'score': -1},
        {'text': 'I shut it down and just push through', 'score': -2},
      ],
    },
    {
      'question': 'How does your mental energy feel most days?',
      'axis': 'Energy (Mental Capacity)',
      'options': [
        {'text': 'Stable and usable', 'score': 2},
        {'text': 'Up and down', 'score': 1},
        {'text': 'Low and exhausted', 'score': -1},
        {'text': 'Heavy and foggy', 'score': -2},
      ],
    },
    {
      'question': 'When a difficult problem appears, what happens first?',
      'axis': 'Agency (Will & Control)',
      'options': [
        {'text': 'I focus and deal with it', 'score': 2},
        {'text': 'I feel anxious but act', 'score': 1},
        {'text': 'I freeze or avoid it', 'score': -1},
        {'text': 'I feel stuck and helpless', 'score': -2},
      ],
    },
    {
      'question': 'When you\'re tired of everything, what keeps you moving?',
      'axis': 'Meaning & Endurance',
      'options': [
        {'text': 'Purpose or values', 'score': 2},
        {'text': 'Responsibility', 'score': 1},
        {'text': 'Habit or routine', 'score': -1},
        {'text': 'Nothing really', 'score': -2},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectAnswer(int score, int optionIndex) async {
    setState(() {
      _isAnswering = true;
      _totalScore += score;
      _selectedAnswers.add(optionIndex);
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _isAnswering = false;
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      _showResultsAndNavigate();
    }
  }

  String _getResultCategory(int score) {
    if (score >= 5) {
      return 'Emotionally Strong';
    } else if (score >= 1) {
      return 'Overwhelmed But Resilient';
    } else if (score >= -2) {
      return 'Mentally Drained';
    } else {
      return 'Low Agency / High Support Needed';
    }
  }

  Color _getResultColor(int score) {
    if (score >= 5) {
      return const Color(0xFF10B981);
    } else if (score >= 1) {
      return const Color(0xFFF59E0B);
    } else if (score >= -2) {
      return const Color(0xFFEF4444);
    } else {
      return const Color(0xFF8B5CF6);
    }
  }

  Future<void> _showResultsAndNavigate() async {
    final assessmentController = Get.find<AssessmentController>();
    final category = _getResultCategory(_totalScore);
    final color = _getResultColor(_totalScore);
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      Get.snackbar('Error', 'User not authenticated', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    assessmentController.setResult(_totalScore, category);


    final answers = <Map<String, dynamic>>[];
    for (int i = 0; i < _questions.length; i++) {
      final selectedOptionIndex = _selectedAnswers.length > i ? _selectedAnswers[i] : -1;
      final selectedOption = selectedOptionIndex >= 0
          ? _questions[i]['options'][selectedOptionIndex]
          : null;

      answers.add({
        'question_index': i,
        'question': _questions[i]['question'],
        'axis': _questions[i]['axis'],
        'selected_option_index': selectedOptionIndex,
        'selected_option_text': selectedOption?['text'] ?? 'N/A',
        'selected_score': selectedOption?['score'] ?? 0,
      });
    }

    // Try to save assessment to Firestore (but don't fail if it can't)
    try {
      final timestamp = DateTime.now();
      await _firestore.collection('users').doc(userId).collection('assessments').add({
        'timestamp': timestamp,
        'total_score': _totalScore,
        'category': category,
        'answers': answers,
        'is_initial': true,
      });

      // Update user profile to mark first assessment as complete
      await _firestore.collection('users').doc(userId).update({
        'assessment_completed': true,
        'last_assessment': timestamp,
        'current_score': _totalScore,
        'current_category': category,
      }).catchError((e) {
        // If doc doesn't exist, create it
        return _firestore.collection('users').doc(userId).set({
          'assessment_completed': true,
          'last_assessment': timestamp,
          'current_score': _totalScore,
          'current_category': category,
          'created_at': timestamp,
        });
      });
    } catch (e) {
      // Silently fail - Firestore might be disabled, but we still show results and navigate
      print('Failed to save to Firestore: $e');
    }

    // Show results
    Get.snackbar(
      'Assessment Complete',
      'Category: $category\nScore: $_totalScore',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // Navigate to home after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      Get.offNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667EEA).withOpacity(0.1),
              const Color(0xFF764BA2).withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      // Progress indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_currentQuestion + 1}/${_questions.length}',
                            style: const TextStyle(
                              color: Color(0xFF667EEA),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF667EEA).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Score: $_totalScore',
                              style: const TextStyle(
                                color: Color(0xFF667EEA),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (_currentQuestion + 1) / _questions.length,
                          minHeight: 8,
                          backgroundColor: const Color(0xFF667EEA).withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF667EEA),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Axis label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF667EEA).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _questions[_currentQuestion]['axis'],
                          style: const TextStyle(
                            color: Color(0xFF667EEA),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Question text
                      Text(
                        _questions[_currentQuestion]['question'],
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF2D3748),
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Options
                      ..._questions[_currentQuestion]['options'].asMap().entries.map(
                        (entry) {
                          final index = entry.key;
                          final option = entry.value;
                          final optionLabels = ['A', 'B', 'C', 'D'];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildOptionButton(
                              label: optionLabels[index],
                              text: option['text'],
                              score: option['score'],
                              isEnabled: !_isAnswering,
                              onTap: () => _selectAnswer(option['score'], index),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required String text,
    required int score,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    final isPositive = score > 0;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPositive
                ? const Color(0xFF10B981).withOpacity(0.3)
                : const Color(0xFFEF4444).withOpacity(0.3),
            width: 2,
          ),
          color: (isPositive
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444))
              .withOpacity(0.08),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: (isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444))
                        .withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Label circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPositive
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Text and score
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Score: ${score > 0 ? '+' : ''}$score',
                        style: TextStyle(
                          color: isPositive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: const Color(0xFF667EEA).withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
