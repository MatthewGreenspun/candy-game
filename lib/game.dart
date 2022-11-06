import "package:flutter/material.dart";
import "dart:math";
import "dart:async";

const gridSize = 6;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final List<List<bool>> _grid = [];
  int _score = 0;
  double _secondsRemaining = 6.0;
  Timer? timer;

  get _gameOver => _secondsRemaining < 1.0;

  void _fillGrid() {
    _grid.clear();
    setState(() {
      for (int i = 0; i < gridSize; i++) {
        List<bool> row = [];
        for (int j = 0; j < gridSize; j++) {
          row.add(Random().nextDouble() > 0.7);
        }
        _grid.add(row);
      }
    });
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _secondsRemaining = 6.0;
    });
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_secondsRemaining <= 1.0) {
        timer.cancel();
      }
      _fillGrid();
      setState(() {
        _secondsRemaining -= 0.5;
      });
    });
    if (_secondsRemaining == 0) timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  Widget build(BuildContext context) {
    const squareWidth = 30.0;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Get 10 points to win!",
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: Container(
            color: const Color.fromARGB(255, 58, 58, 58),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                      child: Text(
                    "Score: $_score",
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  )),
                ),
                Center(
                    child: Column(
                  children: _grid
                      .map(
                        (row) => Row(
                          children: row
                              .map((isCandy) => TextButton(
                                  onPressed: () {
                                    if (isCandy) {
                                      setState(() {
                                        if (!_gameOver) _score++;
                                      });
                                    }
                                  },
                                  child: Visibility(
                                      visible: isCandy,
                                      child: Image.asset("assets/candy.png",
                                          width: squareWidth))))
                              .toList(),
                        ),
                      )
                      .toList(),
                )),
                Visibility(
                    visible: !_gameOver,
                    child: Center(
                        child: Text(
                      "${_secondsRemaining.round()}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 200),
                    ))),
                Visibility(
                    visible: _gameOver,
                    child: Text(
                      _score > 9 ? "You Win!" : "You Lose",
                      style: TextStyle(
                          fontSize: 80,
                          color: _score > 9 ? Colors.green : Colors.red),
                    )),
                Visibility(
                    visible: _gameOver,
                    child: ElevatedButton(
                        onPressed: _startGame, child: const Text("Restart"))),
              ],
            )));
  }
}
