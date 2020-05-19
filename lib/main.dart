import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pomodoro/stores/pomodoro_store.dart';

import 'circle_progress.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CountDownTimer(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.red,
      ),
    );
  }
}

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
      duration: Duration(seconds: 10),
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
                      },
                    ),
                    // pause break
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        if (pomodoroStore.getBreakTime) {
                          if (controller.isCompleted)
                            player.play(alarmAudioPath);

                          return Positioned(
                            right: 10.0,
                            bottom: 20.0,
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                controller.duration = Duration(seconds: 5);
                                controller.forward();
                              },
                              icon: Icon(controller.isAnimating
                                  ? Icons.pause
                                  : Icons.play_arrow),
                              label: Text(controller.isAnimating
                                  ? "PAUSAR"
                                  : "INICIAR PAUSE BREAK"),
                            ),
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
