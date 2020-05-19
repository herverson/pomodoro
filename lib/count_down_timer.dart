import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/stores/pomodoro_store.dart';

import 'circle_progress.dart';

const alarmAudioPath = "alarme.mp3";

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;
  final AudioCache player = new AudioCache();
  final PomodoroStore pomodoroStore = PomodoroStore();
  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: 25),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          if (controller.isCompleted) {
            player.play(alarmAudioPath);
            controller.reset();
            pomodoroStore.setBreakTime(true);
            if (pomodoroStore.getisBreakTime) {
              pomodoroStore.setBreakTime(false);
              pomodoroStore.setisBreakTime(false);
              controller.duration = Duration(minutes: 25);
            }
          }
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.amber[200], Colors.amber],
                          stops: [0.0, 0.7],
                          begin: Alignment.topCenter)),
                  height: controller.value * MediaQuery.of(context).size.height,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.center,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: GestureDetector(
                            onTap: () {
                              if (controller.isAnimating)
                                controller.stop();
                              else {
                                controller.reverse(
                                    from: controller.value == 0.0
                                        ? 1.0
                                        : controller.value);
                              }
                            },
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color: themeData.indicatorColor,
                                  )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        timerString,
                                        style: TextStyle(
                                            fontSize: 112.0,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        if (!pomodoroStore.getisBreakTime) {
                          return FloatingActionButton.extended(
                            onPressed: () {
                              if (controller.isAnimating)
                                controller.stop();
                              else {
                                controller.forward();
                              }
                            },
                            icon: Icon(controller.isAnimating
                                ? Icons.pause
                                : Icons.play_arrow),
                            label: Text(
                                controller.isAnimating ? "PAUSAR" : "INICIAR"),
                          );
                        }
                        return SizedBox();
                      },
                    ),
                    // pause break
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        if (pomodoroStore.getBreakTime) {
                          return FloatingActionButton.extended(
                            onPressed: () {
                              controller.duration = Duration(minutes: 5);
                              controller.forward();
                              pomodoroStore.setisBreakTime(true);
                            },
                            icon: Icon(controller.isAnimating
                                ? Icons.pause
                                : Icons.play_arrow),
                            label: Text(controller.isAnimating
                                ? "PAUSAR"
                                : "INICIAR PAUSE BREAK"),
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
