// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PomodoroStore on _PomodoroStoreBase, Store {
  Computed<bool> _$getBreakTimeComputed;

  @override
  bool get getBreakTime =>
      (_$getBreakTimeComputed ??= Computed<bool>(() => super.getBreakTime))
          .value;
  Computed<bool> _$getisBreakTimeComputed;

  @override
  bool get getisBreakTime =>
      (_$getisBreakTimeComputed ??= Computed<bool>(() => super.getisBreakTime))
          .value;

  final _$breakTimeAtom = Atom(name: '_PomodoroStoreBase.breakTime');

  @override
  bool get breakTime {
    _$breakTimeAtom.context.enforceReadPolicy(_$breakTimeAtom);
    _$breakTimeAtom.reportObserved();
    return super.breakTime;
  }

  @override
  set breakTime(bool value) {
    _$breakTimeAtom.context.conditionallyRunInAction(() {
      super.breakTime = value;
      _$breakTimeAtom.reportChanged();
    }, _$breakTimeAtom, name: '${_$breakTimeAtom.name}_set');
  }

  final _$isBreakTimeAtom = Atom(name: '_PomodoroStoreBase.isBreakTime');

  @override
  bool get isBreakTime {
    _$isBreakTimeAtom.context.enforceReadPolicy(_$isBreakTimeAtom);
    _$isBreakTimeAtom.reportObserved();
    return super.isBreakTime;
  }

  @override
  set isBreakTime(bool value) {
    _$isBreakTimeAtom.context.conditionallyRunInAction(() {
      super.isBreakTime = value;
      _$isBreakTimeAtom.reportChanged();
    }, _$isBreakTimeAtom, name: '${_$isBreakTimeAtom.name}_set');
  }

  final _$_PomodoroStoreBaseActionController =
      ActionController(name: '_PomodoroStoreBase');

  @override
  void setBreakTime(bool value) {
    final _$actionInfo = _$_PomodoroStoreBaseActionController.startAction();
    try {
      return super.setBreakTime(value);
    } finally {
      _$_PomodoroStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setisBreakTime(bool value) {
    final _$actionInfo = _$_PomodoroStoreBaseActionController.startAction();
    try {
      return super.setisBreakTime(value);
    } finally {
      _$_PomodoroStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'breakTime: ${breakTime.toString()},isBreakTime: ${isBreakTime.toString()},getBreakTime: ${getBreakTime.toString()},getisBreakTime: ${getisBreakTime.toString()}';
    return '{$string}';
  }
}
