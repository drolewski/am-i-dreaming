import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class RewardedAdUtil {
  RewardedAd? _rewardedAd;

  RewardedAd? get rewardedAd => _rewardedAd;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
          );
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  void dispose() {
    _rewardedAd?.dispose();
  }
}
