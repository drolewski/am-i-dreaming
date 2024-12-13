import 'package:am_i_dreaming/src/view/horoscopes/horoscopes_view.dart';
import 'package:am_i_dreaming/src/view/horoscopes/no_user_data_horoscopes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../model/user_document.dart';
import '../../state/app_state.dart';

class HoroscopesOptions extends StatelessWidget {
  const HoroscopesOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(AppLocalizations.of(context)!.horoscopes),
        ),
        child: SafeArea(
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
                child: Consumer<ApplicationState>(
                    builder: (context, appState, _) =>
                        appState.userDocument != UserDocument.empty()
                            ? const HoroscopesView()
                            : const NoUserDataHoroscopes()))));
  }
}
