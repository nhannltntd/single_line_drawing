// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateState {
  final bool isRate;

  RateState({required this.isRate});

  RateState copyWith({bool? isRate}) {
    return RateState(
      isRate: isRate ?? this.isRate,
    );
  }
}

class RateEvent {
  final bool isRate;

  RateEvent(this.isRate);
}

class RateBloc extends Bloc<RateEvent, RateState> {
  static const String _isRateKey = 'isRate';

  RateBloc() : super(RateState(isRate: false)) {
    _loadIsRate();
    on<RateEvent>((event, emit) async {
      await _saveIsRate(event.isRate);
      emit(state.copyWith(isRate: event.isRate));
    });
  }

  Future<void> _saveIsRate(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isRateKey, value);
  }

  Future<void> _loadIsRate() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getBool(_isRateKey) ?? false;
    emit(state.copyWith(isRate: storedValue));
  }

  void setRate(bool value) {
    add(RateEvent(value));
  }

  bool getRate() => state.isRate;
}
