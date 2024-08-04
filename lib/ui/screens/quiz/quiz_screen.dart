import 'dart:async';
import 'dart:convert';

import 'package:autoskola_etesty/lib/models/question.dart';
import 'package:autoskola_etesty/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  late List<Question> _questions = [];
  late List<int?> _selectedAnswers = [];
  late List<int> _questionPoints = [];
  int _currentQuestionIndex = 0;
  int _remainingTime = 30 * 60; // 30 minutes in seconds
  Timer? _timer;
  int _score = 0;
  bool _isPassed = false;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _loadQuestions().then((questions) {
      setState(() {
        _questions = questions;
        _selectedAnswers = List<int?>.filled(_questions.length, null);
        _questionPoints = _generateQuestionPoints(_questions.length);
        _startTimer();
      });
    });
  }

  Future<List<Question>> _loadQuestions() async {
    List<String> fields = [
      'assets/questions/first_aid_questions.json',
      'assets/questions/first_aid_questions.json',
      'assets/questions/first_aid_questions.json',
      'assets/questions/first_aid_questions.json',
      'assets/questions/first_aid_questions.json',
      'assets/questions/first_aid_questions.json',
      'assets/questions/first_aid_questions.json',
    ];

    List<int> numQuestions = [10, 4, 3, 3, 2, 2, 1];
    List<Question> allQuestions = [];

    for (int i = 0; i < fields.length; i++) {
      String jsonString = await rootBundle.loadString(fields[i]);
      List<dynamic> jsonData = json.decode(jsonString);
      List<Question> questions = jsonData.map((data) => Question.fromJson(data)).toList();
      questions.shuffle();
      allQuestions.addAll(questions.take(numQuestions[i]));
    }

    return allQuestions;
  }

  List<int> _generateQuestionPoints(int totalQuestions) {
    List<int> points = [];
    List<int> basePoints = [2, 2, 1, 4, 1, 2, 1];

    for (int i = 0; i < totalQuestions; i++) {
      points.add(basePoints[i % basePoints.length]);
    }

    return points;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _evaluateQuiz();
        }
      });
    });
  }

  void _evaluateQuiz() {
    int score = 0;
    for (int i = 0; i < _selectedAnswers.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctAnswerIndex) {
        score += _questionPoints[i];
      }
    }

    setState(() {
      _score = score;
      _isPassed = _score >= 43;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Quiz Completed"),
          content: Text(
            "Your score is $_score out of 50.\nYou ${_isPassed ? "passed" : "did not pass"} the exam.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _onAnswerSelected(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _goToPreviousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      }
    });
  }

  void _goToNextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _evaluateQuiz();
      }
    });
  }

  Future<void> _initializeVideoPlayer(String videoPath) async {
    _videoPlayerController = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        _videoPlayerController!.setLooping(true);
      });
  }

  Widget _buildQuestionList() {
    final question = _questions[_currentQuestionIndex];
    return Flexible(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (ctx, index) {
          return QuestionCard(
            question: question,
            selectedAnswer: _selectedAnswers[_currentQuestionIndex],
            onAnswerSelected: _onAnswerSelected,
            videoPlayerController: _videoPlayerController,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
      ),
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _currentQuestionIndex / _questions.length,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Time Remaining: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  _buildQuestionList(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentQuestionIndex > 0)
                          ElevatedButton(
                            onPressed: _goToPreviousQuestion,
                            child: const Text("Předchozí"),
                          ),
                        if (_currentQuestionIndex < _questions.length - 1)
                          ElevatedButton(
                            onPressed: _goToNextQuestion,
                            child: const Text("Další"),
                          ),
                        if (_currentQuestionIndex == _questions.length - 1)
                          ElevatedButton(
                            onPressed: _evaluateQuiz,
                            child: const Text("End Quiz"),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoPlayerController?.dispose();
    super.dispose();
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final int? selectedAnswer;
  final Function(int) onAnswerSelected;
  final VideoPlayerController? videoPlayerController;

  const QuestionCard({
    super.key,
    required this.question,
    this.selectedAnswer,
    required this.onAnswerSelected,
    this.videoPlayerController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(child: Image.asset(question.imagePath!)),
              ),
            if (question.videoPath != null)
              FutureBuilder(
                future: videoPlayerController?.initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(videoPlayerController!),
                        ),
                        ValueListenableBuilder(
                          valueListenable: videoPlayerController!,
                          builder: (context, VideoPlayerValue value, child) {
                            return Stack(
                              children: [
                                if (!value.isPlaying)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      size: 50.0,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      videoPlayerController!.play();
                                    },
                                  ),
                                if (value.isPlaying)
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () {
                                        videoPlayerController!.pause();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            Text(
              question.question,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ...question.answers.asMap().entries.map(
              (entry) {
                final idx = entry.key;
                final answer = entry.value;
                final isSelected = selectedAnswer == idx;
                final prefix = String.fromCharCode(65 + idx); // 'A', 'B', 'C', etc.
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWell(
                    onTap: () => onAnswerSelected(idx),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$prefix. $answer',
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
