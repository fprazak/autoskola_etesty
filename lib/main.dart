import 'package:autoskola_etesty/ui/screens/quiz/quiz_screen.dart';
import 'package:autoskola_etesty/ui/screens/training_cards_widget.dart';
import 'package:autoskola_etesty/ui/widgets/app_drawer_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Autoškola 2025'),
        ),
        drawer: AppDrawer(
          isDarkMode: _isDarkMode,
          onThemeChanged: _toggleTheme,
        ),
        body: const HomeScreen(),
      ),
      routes: {
        '/quiz': (context) => const QuizScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //todo change with payment
    const isPremiumUser = false;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/quiz'),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF1470df),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        height: 150,
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(
                                "Cvičná zkouška",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Text(
                              ""
                              "30 minut, 25 otázek",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              ""
                              "50 bodů",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                      height: 40,
                                      width: 40,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.play_arrow),
                                      iconSize: 40.0,
                                      color: const Color(0xFF1470df),
                                      onPressed: () {
                                        // Add your onPressed code here!
                                      },
                                    ),
                                  ],
                                ),
                                const Text(
                                  "Spustit zkoušku",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 42,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          widthFactor: 0.74,
                          child: Image.asset(
                            "assets/images/exam.png",
                            fit: BoxFit.cover,
                            width: 220,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 6,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(left: 10),
                height: 80,
                width: size.width,
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFF1470df),
                          ),
                          height: 40,
                          width: 40,
                        ),
                        const Icon(
                          Icons.table_rows_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Průměr ze zkoušek",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Udržuj nad 43 body!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Center(
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: CircularProgressWithPercentage(
                          percentage: 30, //todo set right percentage
                        ),
                      ),
                    ),
                    const SizedBox(width: 15)
                  ],
                ),
              ),
            ),
            TrainingCardsWidget(),
          ],
        ),
      ),
    );
  }
}

class CircularProgressWithPercentage extends StatelessWidget {
  final int percentage;

  const CircularProgressWithPercentage({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CircularProgressIndicator(
          value: percentage / 100.0,
          strokeWidth: 10.0,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>((percentage < 43) ? Colors.red : Colors.green),
        ),
        Center(
          child: Text(
            '$percentage',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: (percentage < 43) ? Colors.red : Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}

class UserAvatar extends StatelessWidget {
  final bool isPremiumUser;

  const UserAvatar({super.key, required this.isPremiumUser});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isPremiumUser ? Colors.amber : Colors.grey,
      child: Icon(
        isPremiumUser ? Icons.star : Icons.person,
        color: Colors.white,
      ),
    );
  }
}
