import 'package:flutter/material.dart';
import 'game.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Align(alignment: Alignment.center, child: Text('Birdle'))
        ),
        body: Center(
          child: GamePage(),
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});
  
  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: switch(hitType) {
          HitType.none => Border.all(color: const Color.fromARGB(255, 187, 187, 187), width: 2),
          _ => null,
        },
        color: switch (hitType) {
          HitType.hit => Color.fromARGB(255, 0, 255, 0),
          HitType.partial => Color.fromARGB(255, 255, 255, 0),
          HitType.miss => Color.fromARGB(255, 192, 192, 192),
          _ => Color.fromARGB(255, 255, 255, 255),
        },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class GamePage extends StatelessWidget {
  GamePage({super.key});

  final Game _game = Game();



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
          for(var guess in _game.guesses) 
            Row(
              spacing: 5.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                for(var guessLetter in guess)
                  Tile(guessLetter.char, guessLetter.type)
              ],
            ),
          GuessInput(
            onSubmitGuess: (String guess){
              print(guess);
            }
          )
        ],
      )
    );
  }
}

class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextField(
              maxLength: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              autofocus: true,
              focusNode: _focusNode,
              onSubmitted: (_) {
                onSubmitGuess(_textEditingController.text.trim());
                _textEditingController.clear();
                _focusNode.requestFocus();
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_circle_up_sharp),
          onPressed: 
            () {
              onSubmitGuess(_textEditingController.text.trim());
              _textEditingController.clear();
              _focusNode.requestFocus();
            },
        ),
      ],
    );
  }
}