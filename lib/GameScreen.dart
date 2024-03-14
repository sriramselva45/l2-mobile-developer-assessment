import 'dart:async';
import 'dart:math';

import 'package:balloonburst/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Poppers',// Name of the webpage
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,// This is to avoid the DEBUG banner that will be appeared in the screen
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0; // Initializing the score as 0
  int balloonsPopped = 0; // Initializing the balloon popped as 0
  int balloonsMissed = 0;  // Initializing the balloon missed as 0
  int gameTimeInSeconds = 120; //Fixing the timer to 2 minutes

  List<Balloon> balloons = []; // Initializing the number of balloons in List generic class

  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  // Starting the game 

  void startGame() {
    gameTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (gameTimeInSeconds > 0) {
        setState(() {
          gameTimeInSeconds--; // Reducing the timer by 1 second when the time is greater than 0 seconds
        });
        generateBalloon(); // calling the function to generate new balloons randomly
      } else {
        endGame(); // calling the function to end the game
      }
    });
  } 

  //Generating the balloons randomly

  void generateBalloon() {
    Random random = Random();
    for (int i = 0; i < 1; i++) { // for loop is used for deciding the number of balloons that should be appeared simultaneously 
      double randomX =
          random.nextDouble() * (MediaQuery.of(context).size.width - 50);
      balloons.add(Balloon(
        key: UniqueKey(),
        xPosition: randomX,
        onTap: () {
          setState(() {
            score += 2; // increasing the score by 2 when a balloon is popped
            balloonsPopped++; // increasing the balloonpopped by 1 when a balloon is popped
          });
        },
        onMissed: () {
          setState(() {
            score -= 1;  // decreasing the score by 1 when a balloon is not popped
            balloonsMissed++;  // increasing the balloonmissed by 1 when a balloon is not popped
          });
        },
      ));
    }
  }

  void endGame() {
    gameTimer?.cancel();
    // Display final score on the screen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'), // displayed when the timer is ended
          content: Column(
            children: [
              Text('Balloons Popped: $balloonsPopped'), // displaying the number of balloons popped after the timer is ended
              Text('Balloons Missed: $balloonsMissed'),  // displaying the number of balloons missed after the timer is ended
              Text('Your Final Score: $score'),  // displaying the Total score after the timer is ended
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(), // redirected to the home page when the home page button is clicked
                    ),
                  );
                },
                child: Text('Home Page'), // button used to redirect to home page
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  restartGame(); // redirected to the game page when the home page button is clicked
                },
                child: Text('Play Again'),  // button used to redirect to game page
              ),
            ],
          ),
        );
      },
    );
  }

  //restarting the game when the play again button is clicked

  void restartGame() {
    setState(() {  
      score = 0;  // Reset the score 
      balloonsPopped = 0;  // Reset the ballons popped
      balloonsMissed = 0;  // Reset the ballons missed 
      gameTimeInSeconds = 120; // Reset to the initial time 
      balloons.clear();
    });
    startGame(); // calling the fucntion to restart the game from the beginning
  }


// used to fix the UI designs
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BALLOON POPPERS',  // Name of the game 
          style: TextStyle(fontWeight: FontWeight.bold),  //making the name bold 
        ),
        centerTitle: true, // making the name to appear in center of the scrren
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // setting the background image that is stored in the asset folder
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            ...balloons,

            // UI Elements
            //Balloon popped
            Positioned(
              top: 20,
              left: 10,
              child: Text(
                'Balloons Popped: $balloonsPopped',
                style: TextStyle(
                    fontSize: 18, color: const Color.fromARGB(255, 1, 18, 1)),
              ),
            ),
            
            //balloons missed
            Positioned(
              top: 20,
              right: 10,
              child: Text(
                'Balloons Missed: $balloonsMissed',
                style: TextStyle(
                    fontSize: 18, color: const Color.fromARGB(255, 54, 4, 1)),
              ),
            ),

            //Timer 
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: Text(
                '${gameTimeInSeconds ~/ 60}:${(gameTimeInSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 50),
              ),
            ),

            //Displaying the score of the player
            Positioned(
              top: 110,
              left: MediaQuery.of(context).size.width / 2 - 60,
              child: Text(
                'Score: $score',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Balloon extends StatefulWidget {
  final double xPosition;
  final VoidCallback onTap;
  final VoidCallback onMissed;

  const Balloon({
    Key? key,
    required this.xPosition, // random positions of the ballons
    required this.onTap, // calling onTap function when a ballon is popped 
    required this.onMissed, // calling onmissed function when a ballon is not popped
  }) : super(key: key);

  @override
  _BalloonState createState() => _BalloonState();
}

class _BalloonState extends State<Balloon> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool isPopped = false;

//balloon images that are stored in asset folder
  List<String> balloonImages = [
    'assets/balloon1.png',
    'assets/balloon2.png',
    'assets/balloon3.png',
    'assets/balloon4.png',
    'assets/balloon5.png'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 9), // Increase the duration for rducing speed or increasing spped
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, -1),
    ).animate(_controller);
    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !isPopped) {
        // Increase missed count when the balloon reaches the top without getting popped
        widget.onMissed();
        _controller.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return isPopped
            ? Container() 
            : Positioned(
                top: MediaQuery.of(context).size.height * _animation.value.dy,
                left: widget.xPosition,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPopped = true;
                    });
                    // Increase popped count when the balloon is popped
                    widget.onTap();
                  },
                  child: Image.asset(
                    balloonImages[
                        widget.xPosition.toInt() % balloonImages.length], // selecting the ballonns in the list class in random manner
                    width: 80,
                    height: 100,
                  ),
                ),
              );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
