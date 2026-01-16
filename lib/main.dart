import 'dart:io';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_logic.dart';

void main() {
  //GameLogic().gameLogic();
  runApp(MyApp());
  GameLogic().gameLogic();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  String winCondition = "";
  String dealerSum = Dealer().calculateSum().toString();
  String playerSum = Player().calculateSum().toString();

  void play() {
    winCondition = Play().play();
    notifyListeners();
  }

  void restart() {
    Restart().restart();
    winCondition = "";
    dealerSum = Dealer().calculateSum().toString();
    playerSum = Player().calculateSum().toString();
    notifyListeners();
  }

  void hit() {
    HitFunction().hitFunction();
    dealerSum = Dealer().calculateSum().toString();
    playerSum = Player().calculateSum().toString();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var m = context.watch<MyAppState>();

    /* void caller2() {
      winCondition = Play().play();
    }*/

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            minHeight: 0,
            maxHeight: 600,
            minWidth: 80,
            maxWidth: 300,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 130,
                left: 0,
                child: Row(children: [Text("Dealersum: "), Text(m.dealerSum)]),
              ),
              Positioned(
                top: 150,
                left: 0,
                child: Row(children: [Text("Playersum: "), Text(m.playerSum)]),
              ),
              Positioned(
                top: 200,
                left: 0,
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dealerImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.asset(
                          dealerImages[index],
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(child: Text('Image not found'));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 300,
                left: 0,
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: playerImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.asset(
                          playerImages[index],
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: OverflowBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    overflowAlignment: OverflowBarAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text("Hit"),
                        onPressed: () => m.hit(),
                      ),
                      ElevatedButton(
                        child: const Text("Stay"),
                        onPressed: () => m.play(),
                      ),
                      ElevatedButton(
                        child: const Text("Restart"),
                        onPressed: () => m.restart(),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(top: 0, left: 0, child: Text(m.winCondition)),
            ],
          ),
        ),
      ),
    );
  }
}
