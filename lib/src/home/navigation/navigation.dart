import 'package:am_i_dreaming/src/ads/banner_ad_util.dart';
import 'package:am_i_dreaming/src/ads/full_screen_ad.dart';
import 'package:am_i_dreaming/src/view/dreams/dream_view.dart';
import 'package:am_i_dreaming/src/view/users/user_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final FullScreenAdUtil fullScreenAd = FullScreenAdUtil();
  final BannerAdUtil bannerAd = BannerAdUtil();

  @override
  void initState() {
    super.initState();
    fullScreenAd.loadInterstitialAd();
    bannerAd.loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.moon_zzz_fill),
              label: AppLocalizations.of(context)!.dreams), // dreams
          BottomNavigationBarItem(
              // zodiac icon based on zodiac symbol of user
              icon: const Icon(CupertinoIcons.star_fill),
              label: AppLocalizations.of(context)!.horoscopes), // horoscopes
          BottomNavigationBarItem(
              // zodiac icon based on zodiac symbol of user
              icon: const Icon(CupertinoIcons.person_fill),
              label: AppLocalizations.of(context)!.user) // user
        ]),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return _navigationTab(context, index);
            },
          );
        });
  }

  @override
  void dispose() {
    bannerAd.dispose();
    fullScreenAd.dispose();
    super.dispose();
  }

  Widget _navigationTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const DreamView();
      case 1:
        return Padding(
            padding: const EdgeInsets.only(top: 60),
            child: SafeArea(
                child: Column(children: [
              CupertinoButton.filled(
                  child: const Text(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                      "Reklama"),
                  onPressed: () {
                    print("Reklama");
                    if (fullScreenAd.interstitialAd != null) {
                      fullScreenAd.interstitialAd?.show();
                    }
                  }),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: bannerAd.bannerAd!.size.width.toDouble(),
                  height: bannerAd.bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: bannerAd.bannerAd!),
                ),
              )
            ])));
      case 2:
        return const UserView();
      default:
        return const CupertinoPageScaffold(child: Text("null"));
    }
  }
}
