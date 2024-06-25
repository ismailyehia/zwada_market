import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:get_it/get_it.dart';

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  late Map<String, String> _localizedValues;

  Future<void> load() async {
    String jsonStringValues = await rootBundle.loadString('assets/language/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? translate(String? key) {
    throwIf(_localizedValues[key] == null, 'key [$key] is missing');
    return _localizedValues[key];
  }




  String getCurrentLanguageCode() {
    return locale.languageCode;
  }



  static const Map<String, Map<String, String>> localizedValues = {
  'en': {
    'minimum_order_amount_message_part1': 'Minimum order amount is',
    'minimum_order_amount_message_part2': 'you have',
    'minimum_order_amount_message_part3': 'in your cart, please add more items.',
  },
  'ar': {
    'minimum_order_amount_message_part1': 'الحد الأدنى للطلب',
    'minimum_order_amount_message_part2': 'لديك',
    'minimum_order_amount_message_part3': 'في سلة التسوق الخاصة بك، يرجى إضافة المزيد من العناصر.',
  },
  // Add translations for other languages
};



  static const LocalizationsDelegate<AppLocalization> delegate = _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    List<String?> languageString = [];
    for (var language in AppConstants.languages) {
      languageString.add(language.languageCode);
    }
    return languageString.contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}

extension StringExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');

}