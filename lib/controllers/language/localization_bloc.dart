import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'localization_event.dart';
part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(LocalizationState.initial()) {
    on<LoadSavedLocalization>(getLanguage);
    on<LoadLocalization>(changeLanguage);
  }

  Future<Locale> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('language') ?? 'en';
    print("NTD-Log-------------------------languageCode: $languageCode");
    return Locale(languageCode);
  }

  Future<void> getLanguage(
      LoadSavedLocalization event, Emitter<LocalizationState> emit) async {
    Locale saveLocale = await getLocale();
    emit(LocalizationState(saveLocale));
  }

  void changeLanguage(LoadLocalization event, Emitter<LocalizationState> emit) {
    if (event.locale == state.locale) return;
    saveLocale(event.locale);
    emit(LocalizationState(event.locale));
  }

  void saveLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', locale.languageCode);
  }
}