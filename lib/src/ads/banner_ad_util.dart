import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class BannerAdUtil {
  BannerAd? _bannerAd;

  BannerAd? get bannerAd => _bannerAd;

  void loadBannerAd() => BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _bannerAd = ad as BannerAd;
          },
          onAdFailedToLoad: (ad, err) {
            print('Failed to load a banner ad: ${err.message}');
            ad.dispose();
          },
        ),
      ).load();


  void dispose() {
    bannerAd?.dispose();
  }
}
