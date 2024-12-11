import 'package:am_i_dreaming/src/view/dreams/dream_view.dart';
import 'package:am_i_dreaming/src/view/users/user_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../ads/ad_helper.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  BannerAd? _bannerAd;

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _loadRewardedAd();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
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
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _moveToHome();
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void _moveToHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
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
                    if (_interstitialAd != null) {
                      _interstitialAd?.show();
                    }
                  }),
              CupertinoButton.filled(
                  child: const Text(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                      "Reklama nagradzana"),
                  onPressed: () {
                    print("Reklama nagradzana");
                    if (_rewardedAd != null) {
                      _rewardedAd?.show(
                        onUserEarnedReward: (_, reward) {
                          print("nagroda");
                        },
                      );
                    }
                  }),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
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
