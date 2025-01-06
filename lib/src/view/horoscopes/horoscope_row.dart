import 'package:flutter/cupertino.dart';

class HoroscopeListRow {
  HoroscopeListRow({required this.header, required this.language, required this.date, required this.value});

  final String header;
  final String language;
  final String date;
  final String value;
}

class HoroscopeRow extends StatelessWidget{
  const HoroscopeRow({super.key, required this.horoscope});

  final HoroscopeListRow horoscope;

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
                horoscope.header)),
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
}