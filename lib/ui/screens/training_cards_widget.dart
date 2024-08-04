import 'dart:convert';

import 'package:autoskola_etesty/lib/models/question.dart';
import 'package:autoskola_etesty/ui/screens/practicing/practicing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrainingCardsWidget extends StatelessWidget {
  final List<CardItem> items = [
    CardItem(
        title: 'Znalost pravidel provozu na pozemních komunikacích',
        progress: 0.8,
        maxProgress: 433,
        jsonFile: 'assets/questions/znalosti_pravidel_provozu.json'),
    CardItem(
        title: 'Znalost zásad bezpečné jízdy a ovládání vozidla',
        progress: 0.6,
        maxProgress: 200,
        jsonFile: 'assets/questions/first_aid_questions.json'),
    CardItem(
        title: 'Znalost dopravních značek, světelných a akustických signálů, ...',
        progress: 0.5,
        maxProgress: 100,
        jsonFile: 'assets/questions/first_aid_questions.json'),
    CardItem(
        title: 'Schopnost řešení dopravních situací',
        progress: 0.7,
        maxProgress: 50,
        jsonFile: 'assets/questions/first_aid_questions.json'),
    CardItem(
        title: 'Znalost předpisů o podmínkách provozu vozidel na pozemních komunikacích',
        progress: 0.9,
        maxProgress: 150,
        jsonFile: 'assets/questions/first_aid_questions.json'),
    CardItem(
        title: 'Znalost předpisů souvisejících s provozen na pozemních komunikacích',
        progress: 0.4,
        maxProgress: 70,
        jsonFile: 'assets/questions/first_aid_questions.json'),
    CardItem(
        title: 'Znalost zdravotnické přípravy',
        progress: 0.3,
        maxProgress: 30,
        jsonFile: 'assets/questions/first_aid_questions.json'),
    CardItem(title: 'Ostatní', progress: 0.2, maxProgress: 120, jsonFile: 'assets/questions/first_aid_questions.json'),
  ];

  TrainingCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) => CardWidget(item: item)).toList(),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final CardItem item;

  const CardWidget({super.key, required this.item});

  Future<List<Question>> loadQuestions() async {
    final String response = await rootBundle.loadString(item.jsonFile);
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Question.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      child: InkWell(
        onTap: () async {
          final questions = await loadQuestions();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PracticingAllQuestionsScreen(questions: questions, title: item.title),
            ),
          );
        },
        child: Container(
          height: 150,
          width: 150,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: item.progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 8),
              Text('${(item.progress * item.maxProgress).toInt()}/${item.maxProgress.toInt()}'),
            ],
          ),
        ),
      ),
    );
  }
}

class CardItem {
  final String title;
  final double progress;
  final int maxProgress;
  final String jsonFile;

  CardItem({required this.title, required this.progress, required this.maxProgress, required this.jsonFile});
}
