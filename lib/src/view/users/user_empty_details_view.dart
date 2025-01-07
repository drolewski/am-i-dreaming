import 'package:am_i_dreaming/src/ads/banner_ad_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

class UserEmptyDetailsView extends StatefulWidget {
  const UserEmptyDetailsView({super.key});

  @override
  State<UserEmptyDetailsView> createState() => _UserEmptyDetailsViewState();
}

class _UserEmptyDetailsViewState extends State<UserEmptyDetailsView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const BannerAdWidget(),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                          AppLocalizations.of(context)!.empty_user_form_text)),
                  SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                          child: Text(AppLocalizations.of(context)!
                              .empty_user_form_button),
                          onPressed: () => context.push("/user/form"))),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Center(
                          child: SizedBox(
                              width: double.infinity,
                              child: Consumer<ApplicationState>(
                                  builder: (context, appState, child) =>
                                      CupertinoButton(
                                          child: Text(
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400),
                                              AppLocalizations.of(context)!
                                                  .logout),
                                          onPressed: () {
                                            _signOut(appState);
                                          }))))),
                  Center(
                      child: SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                              child: Text(
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                  AppLocalizations.of(context)!
                                      .delete_account),
                              onPressed: () => Navigator.of(context)
                                  .restorablePush(_modalBuilder))))

                ])));
  }

  Future<void> _signOut(ApplicationState appState) async {
    await FirebaseAuth.instance.signOut();
    context.pushReplacement("/login");
    appState.destroy();
  }

  @pragma('vm:entry-point')
  static Route<void> _modalBuilder(BuildContext context, Object? arguments) {
    return CupertinoModalPopupRoute<void>(
      builder: (BuildContext context) {
        return Consumer<ApplicationState>(
            builder: (context, appState, child) => CupertinoActionSheet(
              title: Text(AppLocalizations.of(context)!.delete_account),
              message: Text(AppLocalizations.of(context)!
                  .delete_account_question_modal),
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  child: Text(AppLocalizations.of(context)!.yes),
                  onPressed: () async {
                    context.pushReplacement("/login");
                    appState.removeUser();
                    Navigator.pop(context);
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(AppLocalizations.of(context)!.no),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
      },
    );
  }
}
