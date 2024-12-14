import 'package:am_i_dreaming/src/state/app_state.dart';
import 'package:am_i_dreaming/src/util/date_formater.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../ads/banner_ad_component.dart';
import '../../../ads/rewarded_ad.dart';
import '../../../functions/dream.dart';

class DreamDetails extends StatefulWidget {
  const DreamDetails({super.key, required this.dreamIndex});

  final int dreamIndex;

  @override
  State<DreamDetails> createState() => _DreamDetailsState();
}

class _DreamDetailsState extends State<DreamDetails> {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final RewardedAdUtil rewardedAd = RewardedAdUtil();

  @override
  void initState() {
    rewardedAd.loadRewardedAd();
    super.initState();
  }

  @override
  void dispose() {
    rewardedAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text(formatTimestampToDate(context,
                      appState.dreamDocuments[widget.dreamIndex].timestamp)),
                ),
                child: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20.0, right: 20.0),
                        child: Column(children: [
                          const BannerAdWidget(),
                          _generatedImage(appState),
                          _generateImageButton(appState, context),
                          Text(appState.dreamDocuments[widget.dreamIndex].text),
                        ])))));
  }

  Widget _generatedImage(ApplicationState appState) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: appState.dreamDocuments[widget.dreamIndex].url.isNotEmpty
            ? Image.network(loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                    child: loadingProgress.expectedTotalBytes != null &&
                            loadingProgress.cumulativeBytesLoaded <
                                loadingProgress.expectedTotalBytes!
                        ? const CircularProgressIndicator.adaptive()
                        : const SizedBox.shrink());
              },
                fit: BoxFit.scaleDown,
                appState.dreamDocuments[widget.dreamIndex].url)
            : const SizedBox.shrink());
  }

  SizedBox _generateImageButton(
      ApplicationState appState, BuildContext context) {
    return appState.dreamDocuments[widget.dreamIndex].url.isEmpty
        ? SizedBox(
            width: double.infinity,
            child: CupertinoButton(
                child: Text(AppLocalizations.of(context)!
                    .generate_dream_picture_button),
                onPressed: () async {
                  if (rewardedAd.rewardedAd != null) {
                    rewardedAd.rewardedAd?.show(
                      onUserEarnedReward: (_, reward) async {
                        setState(() {
                          _isLoading = true;
                        });
                        await dream(appState.dreamDocuments[widget.dreamIndex].id);
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    );
                  }
                }))
        : const SizedBox.shrink();
  }
}
