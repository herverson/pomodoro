import 'dart:async';
import 'package:audioplayers/audio_cache.dart';

const alarmAudioPath = "alarme.mp3";

class EggTimer {
  final AudioCache player = new AudioCache();
  final Duration maxTime;
  final Function onTimerUpdate;
  final Stopwatch stopwatch = new Stopwatch();
  Duration _currentTime = const Duration(seconds: 0);
  Duration lastStartTime = const Duration(seconds: 0);
  EggTimerState state = EggTimerState.ready;
  bool concluido = true;

  EggTimer({
    this.maxTime,
    this.onTimerUpdate,
  });

  get currentTime {
    return _currentTime;
  }

  set currentTime(newTime) {
    if (state == EggTimerState.ready) {
      _currentTime = newTime;
      lastStartTime = currentTime;
    }
  }

  resume() {
    if (state != EggTimerState.running) {
      if (state == EggTimerState.ready) {
        _currentTime = _roundToTheNearestMinute(_currentTime);
        lastStartTime = _currentTime;
      }

      state = EggTimerState.running;
      stopwatch.start();

      _tick();
    }
  }

  _roundToTheNearestMinute(duration) {
    return new Duration(
      minutes: (duration.inSeconds / 60).round()
    );
  }

  pause() {
    if (state == EggTimerState.running) {
      state = EggTimerState.paused;
      stopwatch.stop();

      if (null != onTimerUpdate) {
        onTimerUpdate();
      }
    }
  }

  restart() {
    if (state == EggTimerState.paused) {
      state = EggTimerState.running;
      _currentTime = lastStartTime;
      stopwatch.reset();
      stopwatch.start();

      _tick();
    }
  }

  reset() {
    if (state == EggTimerState.paused) {
      state = EggTimerState.ready;
      _currentTime = const Duration(seconds: 0);
      lastStartTime = _currentTime;
      stopwatch.reset();
      concluido = false;
      if (null != onTimerUpdate) {
        onTimerUpdate();
      }
    }
  }

  _tick() async {
    print('Tempo atual: ${_currentTime.inSeconds}');
    _currentTime = lastStartTime - stopwatch.elapsed;
    if (_currentTime.inSeconds == 0) {
      await player.play(alarmAudioPath);
      state = EggTimerState.ready;
        _currentTime = const Duration(seconds: 0);
        lastStartTime = _currentTime;
        stopwatch.reset();
        concluido = false;
        if (null != onTimerUpdate) {
          onTimerUpdate();
        }
    }
    if (_currentTime.inSeconds > 0) {
      new Timer(const Duration(seconds: 1), _tick);
    } else {
      if (concluido)
      {
        print('deu certo');
        await player.play(alarmAudioPath);
        state = EggTimerState.ready;
        _currentTime = const Duration(seconds: 0);
        lastStartTime = _currentTime;
        stopwatch.reset();
        concluido = false;
        if (null != onTimerUpdate) {
          onTimerUpdate();
        }
      }
      state = EggTimerState.ready;
    }

    if (null != onTimerUpdate) {
      onTimerUpdate();
    }
  }
}

enum EggTimerState {
  ready,
  running,
  paused,
}