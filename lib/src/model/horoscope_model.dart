import 'package:am_i_dreaming/src/model/zodiac_model.dart';

class Horoscope {
  Horoscope({required this.zodiac,
    required this.language,
    required this.date,
    required this.value});

  final ZodiacModel zodiac;
  final String language;
  final String date;
  final String value;
}