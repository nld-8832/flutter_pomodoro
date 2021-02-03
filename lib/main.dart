import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Pomodoro(),
    );
  }
}

class Pomodoro extends StatefulWidget {
  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  static int timeSession = 25;
  int timeSessionInSec = timeSession * 60;
  double percent = 0;

  Timer timer;

  _StartTimer() {
    timeSession = 25;
    int time = timeSession * 60;
    double timePercent = time/100;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (time > 0) {
          time--;
          if (time % 60 == 0) {
            timeSession--;
          }
          if (time % timePercent == 0) { // Progress bar percent calculation
            if (percent < 1) {
              percent += 0.01;
            } else {
              percent = 1;
            }
          }
        } else {
          percent = 0;
          timeSession = 25;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1542bf), Color(0xff51a8ff)],
              begin: FractionalOffset(0.5, 1),
            ),
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text("Pomodoro?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
              ),
              Expanded(child: CircularPercentIndicator(
                  percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  radius: 250.0,
                  lineWidth: 10.0,
                  progressColor: Colors.white,
                  center: Text("$timeSession",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80.0,
                    ),
                  ),
              )),
              SizedBox(height: 30.0),
              Expanded(child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 30.0,
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(child: Row(
                        children: <Widget>[
                          Expanded(child: Column(
                            children: <Widget>[
                              Text("Pomodoro Timer",
                                style: TextStyle(fontSize: 25.0)
                              ),
                              SizedBox(height: 10.0),
                              Text("25",
                                style: TextStyle(fontSize: 70.0),
                              ),
                            ],
                          )),
                        ],
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 28.0),
                        child: RaisedButton(
                          onPressed: _StartTimer,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("Start",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                              ),
                            )
                          ),
                        )
                      )
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}


