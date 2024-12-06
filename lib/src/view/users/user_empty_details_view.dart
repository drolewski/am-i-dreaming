import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class UserEmptyDetailsView extends StatelessWidget {
  const UserEmptyDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                          "Uzupełnij dane i ciesz się naszymi horoskopami")),
                  SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                          child: Text(AppLocalizations.of(context)!
                              .empty_user_form_button),
                          onPressed: () => context.push("/user/form"))),
                ])));
  }
}
