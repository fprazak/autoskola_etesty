import 'package:autoskola_etesty/lib/models/question.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PracticingAllQuestionsScreen extends StatefulWidget {
  final List<Question> questions;
  final String title;

  const PracticingAllQuestionsScreen({super.key, required this.questions, required this.title});

  @override
  PracticingAllQuestionsScreenState createState() => PracticingAllQuestionsScreenState();
}

class PracticingAllQuestionsScreenState extends State<PracticingAllQuestionsScreen> {
  final Map<int, VideoPlayerController> _videoPlayerControllers = {};

  @override
  void dispose() {
    for (var controller in _videoPlayerControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<VideoPlayerController> _initializeVideoPlayer(String videoPath, int index) async {
    if (_videoPlayerControllers.containsKey(index)) {
      return _videoPlayerControllers[index]!;
    }

    debugPrint(videoPath);
    final controller = VideoPlayerController.asset(videoPath);
    await controller.initialize();

    // Check if the video is .swf.mp4
    if (videoPath.toLowerCase().endsWith('.swf.mp4')) {
      controller.addListener(() {
        if (controller.value.position >= controller.value.duration) {
          controller.seekTo(Duration.zero);
          controller.play();
        }
      });
      controller.play(); // Start playing automatically
    } else {
      controller.addListener(() {
        if (controller.value.position >= controller.value.duration) {
          controller.seekTo(Duration.zero);
          controller.pause();
          setState(() {});
        }
      });
    }

    _videoPlayerControllers[index] = controller;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          final question = widget.questions[index];
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
                    FutureBuilder<VideoPlayerController>(
                      future: _initializeVideoPlayer(question.videoPath!, index),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          final controller = snapshot.data!;
                          return GestureDetector(
                            onTap: () {
                              final videoPath = question.videoPath!;
                              if (!videoPath.toLowerCase().endsWith('.swf.mp4')) {
                                setState(() {
                                  if (controller.value.isPlaying) {
                                    controller.pause();
                                  } else {
                                    controller.play();
                                  }
                                });
                              }
                            },
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 300),
                              child: AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    VideoPlayer(controller),
                                    ValueListenableBuilder(
                                      valueListenable: controller,
                                      builder: (context, VideoPlayerValue value, child) {
                                        return AnimatedOpacity(
                                          opacity: value.isPlaying ? 0.0 : 1.0,
                                          duration: const Duration(milliseconds: 200),
                                          child: Container(
                                            color: Colors.black26,
                                            child: const Icon(
                                              Icons.play_arrow,
                                              size: 50.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 10),
                  Text(
                    question.question,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...question.answers.asMap().entries.map(
                    (entry) {
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
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
