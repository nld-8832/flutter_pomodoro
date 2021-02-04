import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: Pomodoro(),
    );
  }
}

class Pomodoro extends StatefulWidget {
  //Pomodoro({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final String title;

  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> with TickerProviderStateMixin {
  int _timeLeft = 25;
  int _timeLeftInSec = 25 * 60;
  bool _isRunning = false;
  bool _isAtStart = true;

  int _breaktimeLeft = 2;
  int _breaktimeLeftInSec = 2*1;
  String _sessionStatus = "Done!";
  int sessionCounter = 0;

  // Animation processing
  AnimationController _controller;
  Animation _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _timeLeftInSec),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        sessionCounter++;
      };
    });
    super.initState();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Current Session",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: "Roboto",
          ),
        ),
      ),
      body: Center(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Countdown(
              animation: StepTween(
                begin: _timeLeftInSec, // THIS IS AN USER ENTERED NUMBER
                end: 0,
              ).animate(_controller),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _isAtStart ? null : () {
                _controller.reset();
                _isAtStart = true;
                setState(() => _isRunning = false);
              },
            ),
            IconButton(
              icon: (_isRunning) ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () {
                _isAtStart = false;
                if (_isRunning) _controller.stop();
                else _controller.forward();
                setState(() => _isRunning = !_isRunning);
              },
            ),
            Text("$sessionCounter $_sessionStatus",
              style: TextStyle(
                color: Color(0xff929da5),
                fontSize: 20,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.*/
    );
  }
}

// Custom class for animation
class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration duration = Duration(seconds: animation.value);

    String timeLeft =
        '${duration.inMinutes.remainder(60).toString()}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    //print('animation.value  ${animation.value} ');

    return Text(
      "$timeLeft",
      style: TextStyle(
        fontSize: 70,
        color: Color(0xff929da5),
        fontFamily: "Roboto",
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

