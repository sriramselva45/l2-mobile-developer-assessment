import 'package:flutter/material.dart';
import 'GameScreen.dart';

//This is the home page of the game which contains a button called start game
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BALLOON POPPERS',// Name of the game
          style: TextStyle(fontWeight: FontWeight.bold),// This is to make the name in bold characters
        ),
        centerTitle: true, //This is to make the name come in center of the screen
      ),
      body: Container(
        decoration: BoxDecoration( 
          image: DecorationImage(
            image: AssetImage('assets/background.png'),// This is the background image of the game which is stored in the asset folder 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GameScreen()),
              );
            },
            child:
                Text('Start Game'), // when clicked, the user can play the game
          ),
        ),
      ),
    );
  }
}
