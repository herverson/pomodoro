import 'package:mobx/mobx.dart';
part 'pomodoro_store.g.dart';

class PomodoroStore = _PomodoroStoreBase with _$PomodoroStore;

abstract class _PomodoroStoreBase with Store {
  @observable
  bool breakTime = false;

  @action
  void setBreakTime(bool value) => breakTime = value;

  @computed
  bool get getBreakTime {
    return breakTime;
  }

  @observable
  bool isBreakTime = false;

  @action
  void setisBreakTime(bool value) => isBreakTime = value;

  @computed
  bool get getisBreakTime {
    return isBreakTime;
  }

}