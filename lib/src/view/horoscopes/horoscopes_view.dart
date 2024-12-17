import 'package:am_i_dreaming/src/functions/horoscopes.dart';
import 'package:am_i_dreaming/src/state/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../ads/banner_ad_component.dart';

class HoroscopesView extends StatefulWidget {
  const HoroscopesView({super.key});

  @override
  State<StatefulWidget> createState() => _HoroscopeViewState();
}

class _HoroscopeViewState extends State<HoroscopesView> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => _isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Column(
                children: [
                  const BannerAdWidget(),
                  Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      child: Center(
                          child: SizedBox(
                              width: double.infinity,
                              child: CupertinoButton.filled(
                                  child: Text(
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                      AppLocalizations.of(context)!
                                          .horoscopes_button_generate_horoscope_for_my_zodiac(
                                              appState.userDocument.sunZodiac
                                                  .toModel()
                                                  .icon)),
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    final hor = await horoscope(
                                        AppLocalizations.of(context)!.language,
                                        appState.userDocument.sunZodiac);
                                    print(hor.date);
                                    print(hor.language);
                                    print(hor.value);
                                    print(hor.zodiac.icon);
                                    print(hor.zodiac.name);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }))))
                ],
              ));
  }
}
