import 'package:pomodoro/pomodoro_timer.dart';
import 'package:pomodoro/pomodoro_timer_button.dart';
import 'package:pomodoro/pomodoro_timer_controls.dart';
import 'package:pomodoro/pomodoro_timer_dial.dart';
import 'package:pomodoro/pomodoro_timer_time_display.dart';
import 'package:flutter/material.dart';

final Color GRADIENT_TOP = const Color(0xFF303030);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);


void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  EggTimer eggTimer;

  _MyAppState() {
    
    eggTimer = new EggTimer(
      maxTime: const Duration(minutes: 25),
      onTimerUpdate: _onTimerUpdate,
    );
  }

  _onTimeSelected(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
    });
  }

  _onDialStopTurning(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
      eggTimer.resume();
    });
  }

  _onTimerUpdate() {
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro Herver',
      theme: new ThemeData(
        fontFamily: 'BebasNeue',
      ),
      home: new Scaffold(
        body: new Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
            ),
          ),
          child: new Center(
            child: new Column(
              children: [
                new EggTimerTimeDisplay(
                  eggTimerState: eggTimer.state,
                  selectionTime: eggTimer.lastStartTime,
                  countdownTime: eggTimer.currentTime,
                ),

                new PomodoroTimerDial(
                  eggTimerState: eggTimer.state,
                  currentTime: eggTimer.currentTime,
                  maxTime: eggTimer.maxTime,
                  ticksPerSection: 5,
                  onTimeSelected: _onTimeSelected,
                  onDialStopTurning: _onDialStopTurning,
                ),

                new Expanded(child: new Container()),

                new PomodoroTimerControls(
                  eggTimerState: eggTimer.state,
                  onPause: () {
                    setState(() => eggTimer.pause());
                  },
                  onResume: () {
                    setState(() => eggTimer.resume());
                  },
                  onRestart: () {
                    setState(() => eggTimer.restart());
                  },
                  onReset: () {
                    setState(() => eggTimer.reset());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
