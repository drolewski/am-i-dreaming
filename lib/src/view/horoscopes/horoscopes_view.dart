import 'package:flutter/cupertino.dart';

import '../../ads/banner_ad_component.dart';

class HoroscopesView extends StatefulWidget {
  const HoroscopesView({super.key});

  @override
  State<StatefulWidget> createState() => _HoroscopeViewState();
}

class _HoroscopeViewState extends State<HoroscopesView> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [BannerAdWidget(), Text("horoscopy")],
    );
  }
}
