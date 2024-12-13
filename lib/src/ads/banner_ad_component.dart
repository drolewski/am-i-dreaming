import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  final AdSize adSize;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  /// The banner ad to show. This is `null` until the ad is actually loaded.
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SizedBox(
            width: widget.adSize.width.toDouble(),
            height: widget.adSize.height.toDouble(),
            child: _bannerAd == null
                // Nothing to render yet.
                ? const SizedBox()
                // The actual ad.
                : AdWidget(ad: _bannerAd!),
          ),
        )));
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void _loadAd() {
    final bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }
}
