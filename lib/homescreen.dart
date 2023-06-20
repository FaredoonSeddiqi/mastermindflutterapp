import 'package:flutter/material.dart';
import 'dart:math';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  List<Color> selectedColors = [];
  List<Color> answer = [];
  int maxGuesses = 10;
  int currentGuess = 0;
  bool showHint = false;
  String text = "Show Rules";
  int t = 10;
  final List<bool> checkboxValues = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    generateAnswer();
  }

  void generateAnswer() {
    final random = Random();
    for (int i = 0; i < 4; i++) {
      answer.add(colors[random.nextInt(colors.length)]);
    }
  }

  void checkGuess() {
    int correctColorAndPosition = 0;
    int correctColorOnly = 0;
    List<Color> guess = selectedColors.toList();

    for (int i = 0; i < 4; i++) {
      if (guess[i] == answer[i]) {
        correctColorAndPosition++;
        guess[i] = Colors.transparent;
        answer[i] = Colors.black;
      }
    }

    for (int i = 0; i < 4; i++) {
      if (guess.contains(answer[i])) {
        correctColorOnly++;
        guess[guess.indexOf(answer[i])] = Colors.transparent;
        answer[i] = Colors.black;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Correct color and position: $correctColorAndPosition'),
              Text('Correct color only: $correctColorOnly'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (correctColorAndPosition == 4) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Congratulations!'),
                        content: Text('You won the game!'),
                        actions: [
                          ElevatedButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              resetGame();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (currentGuess >= maxGuesses) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Game Over'),
                        content: Text(
                            'You lost! The correct answer was: ${answer.map((color) => colors.indexOf(color)).toList()}'),
                        actions: [
                          ElevatedButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              resetGame();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  currentGuess++;
                  selectedColors = List<Color>.filled(4, Colors.transparent);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      answer.clear();
      generateAnswer();
      selectedColors.clear();
      currentGuess = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
              ),
            ),
            child: Center(
                child: Container(
              child: Image(image: AssetImage('lib/image/top.PNG')),
            )),
          ),
        ),
        body: ListView.builder(
          itemCount: checkboxValues.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                checkboxValues[index] = !checkboxValues[index];
              },
              child: Container(
                child: Column(children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 140),
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (showHint) {
                                        text = "Show Rules";
                                      } else {
                                        text = "Hide Rules";
                                      }
                                      setState(() {
                                        showHint = !showHint;
                                      });
                                    },
                                    child: Text(text)),
                              ),
                              if (showHint)
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        """Select four colors and tap OK to make a guess.The result will show the number of correct colors and positions,and the number of correct colors only.
                          """,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              for (int i = 0; i < 10; i++)
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              225, 246, 236, 236))),
                                  child: Row(
                                    children: [
                                      for (int j = 0; j < 4; j++)
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.all(2),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              //color: colors[j],
                                              border: Border.all(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      for (int i = 0; i < 2; i++)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            for (int j = i * 2;
                                                j < (i * 2) + 2;
                                                j++)
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    checkboxValues[j] =
                                                        !checkboxValues[j];
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      color: checkboxValues[j]
                                                          ? Colors.blue
                                                          : Colors.transparent,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(16.0),
                        //     child: Column(
                        //       children: [
                        //         SizedBox(height: 20),
                        //         Text(
                        //           'Your Guess:',
                        //           style: TextStyle(fontSize: 20),
                        //         ),
                        //         SizedBox(height: 10),
                        //         // Row(
                        //         //   mainAxisAlignment: MainAxisAlignment.center,
                        //         //   children: [
                        //         //     for (Color color in selectedColors)
                        //         //       Container(
                        //         //         width: 50,
                        //         //         height: 50,
                        //         //         margin: EdgeInsets.symmetric(horizontal: 10),
                        //         //         decoration: BoxDecoration(
                        //         //           shape: BoxShape.circle,
                        //         //           color: color,
                        //         //           border: Border.all(color: Colors.black),
                        //         //         ),
                        //         //       ),
                        //         //   ],
                        //         // ),
                        //         SizedBox(height: 20),
                        //         GridView.builder(
                        //           shrinkWrap: true,
                        //           itemCount: colors.length,
                        //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //             crossAxisCount: 1,
                        //             mainAxisSpacing: 10.0,
                        //             crossAxisSpacing: 10.0,
                        //             childAspectRatio: 6.0,
                        //           ),
                        //           itemBuilder: (BuildContext context, int index) {
                        //             return GestureDetector(
                        //               onTap: () {
                        //                 setState(() {
                        //                   if (selectedColors.length < 4) {
                        //                     selectedColors.add(colors[index]);
                        //                   }
                        //                 });
                        //                 if (selectedColors.length == 4) {
                        //                   checkGuess();
                        //                 }
                        //               },
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   shape: BoxShape.circle,
                        //                   color: colors[index],
                        //                   border: Border.all(color: Colors.black),
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 230),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (Color color in colors)
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: color,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            );
          },
        ));
  }
}
