import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PremiumButton extends StatelessWidget {
  const PremiumButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 24, bottom: 24),
        child: Center(
            child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                    child:
                        Text(AppLocalizations.of(context)!.buy_premium_button),
                    onPressed: () => print("premium")))));
  }
}
