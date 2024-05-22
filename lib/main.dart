import 'dart:convert';

import 'package:autoskola_etesty/lib/models/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:video_player/video_player.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QuestionScreen(),
    );
  }
}

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  QuestionScreenState createState() => QuestionScreenState();
}

class QuestionScreenState extends State<QuestionScreen> {
  bool _showQuestions = false;
  List<Question> _questions = [];
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final String response = await rootBundle.loadString('assets/questions/first_aid_questions.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _questions = data.map((json) => Question.fromJson(json)).toList();
    });
  }

  void _toggleQuestions() {
    setState(() {
      _showQuestions = !_showQuestions;
    });
  }

  Widget _buildQuestionList() {
    return ListView.builder(
      itemCount: _questions.length,
      itemBuilder: (ctx, index) {
        final question = _questions[index];
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
                    future: _initializeVideoPlayer(question.videoPath!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController!),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _videoPlayerController!,
                              builder: (context, VideoPlayerValue value, child) {
                                return value.isPlaying
                                    ? const SizedBox.shrink()
                                    : IconButton(
                                        icon: const Icon(
                                          Icons.play_arrow,
                                          size: 50.0,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          _videoPlayerController!.play();
                                        },
                                      );
                              },
                            ),
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                Text(
                  question.question,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ...question.answers.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final answer = entry.value;
                  final isCorrect = idx == question.correctAnswerIndex;
                  final prefix = String.fromCharCode(65 + idx); // 'A', 'B', 'C', etc.
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$prefix. $answer ${isCorrect == true ? "✓" : ""}',
                            style: TextStyle(
                              fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _initializeVideoPlayer(String videoPath) async {
    _videoPlayerController = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        _videoPlayerController!.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: _showQuestions ? _buildQuestionList() : const Center(child: Text('Press the button to show questions')),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleQuestions,
        child: Icon(_showQuestions ? Icons.close : Icons.play_arrow),
      ),
    );
  }
}
