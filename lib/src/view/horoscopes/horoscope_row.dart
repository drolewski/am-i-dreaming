import 'package:am_i_dreaming/src/model/horoscope_model.dart';
import 'package:flutter/cupertino.dart';

class HoroscopeRow extends StatelessWidget{
  const HoroscopeRow({super.key, required this.horoscope});

  final Horoscope horoscope;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
                '${horoscope.zodiac.icon} ${_capitalize(horoscope.zodiac.name.name)}')),
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                horoscope.value))
      ],
    );
  }

  String _capitalize(String name) {
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

}