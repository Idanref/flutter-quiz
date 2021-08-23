//import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:quizzler/quizbrain.dart';
import 'quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:audioplayers/audioplayers.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

final player = AudioCache();

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [];

  bool correctAnswer;

  void checkAnswer(bool userAnswer) {
    correctAnswer = quizBrain.getQuestionAnswer();

    if (correctAnswer == userAnswer) {
      player.play('correct.wav');
      scoreKeeper.add(Icon(Icons.check, color: Colors.green));
    } else {
      player.play('correct.wav');
      scoreKeeper.add(
        Icon(Icons.close, color: Colors.red),
      );
    }
  }

  bool quizNotFinished() {
    return quizBrain.getQuestionNumber() < quizBrain.getListLength() - 1;
  }

  void finishQuiz() {
    quizBrain.resetQuestionNumber();
    scoreKeeper.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Quizzler",
        desc: "Quiz fiinished, by Idan Refaeli.",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                setState(() {
                  // Pressed on true
                  checkAnswer(true);

                  if (quizNotFinished())
                    quizBrain.nextQuestion();
                  else
                    finishQuiz();
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                setState(() {
                  // Pressed on false

                  checkAnswer(false);

                  if (quizNotFinished())
                    quizBrain.nextQuestion();
                  else
                    finishQuiz();
                });
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
