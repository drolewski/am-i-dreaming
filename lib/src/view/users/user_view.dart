import 'package:am_i_dreaming/src/component/premium_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/detail_record.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<StatefulWidget> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var _isEditModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: GestureDetector(
              onTap: () =>
                  setState(() => _isEditModeEnabled = !_isEditModeEnabled),
              child: _isEditModeEnabled
                  ? const Icon(
                      CupertinoIcons.check_mark_circled_solid) // floppy_disk
                  : const Icon(CupertinoIcons.pencil)),
          middle: Text(AppLocalizations.of(context)!.user),
        ),
        child: Padding(
            padding: const EdgeInsets.only(
                top: 120.0, left: 20.0, right: 20.0, bottom: 80),
            child: SingleChildScrollView(
                child: _isEditModeEnabled ? _editUser() : _displayUser())));
  }

  Column _displayUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 12),
            child: Text(
              "Dominik",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            )),
        const DetailsRecord(label: "Data urodzenia", value: "05:48 09.04.1998",),
        const DetailsRecord(label: "Miejsce urodzenia", value: "Poznańxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx, Polska",),
        const DetailsRecord(label: "Znak zodiaku", value: "x",),
        const DetailsRecord(label: "Dom astrologiczny", value: "x",),
        const DetailsRecord(label: "Żywioł znaku zodiaku", value: "x",),
        const DetailsRecord(label: "Jakość znaku zodiaku", value: "x",),
        const DetailsRecord(label: "Fazy księżyca", value: "x",),
        const DetailsRecord(label: "Powroty planetarne?", value: "x",),
        const DetailsRecord(label: "Układ planet?", value: "x",),
        const DetailsRecord(label: "Aspekty planetarne?", value: "x",),
        const PremiumButton(),
        Container(
            margin: EdgeInsets.only(top: 10),
            child: Center(
                child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                        child: Text(AppLocalizations.of(context)!.logout),
                        onPressed: () => FirebaseAuth.instance.signOut())))),
        Container(
            margin: const EdgeInsets.only(top: 10),
            child: Center(
                child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                        child:
                            Text(AppLocalizations.of(context)!.delete_account),
                        onPressed: () => Navigator.of(context)
                            .restorablePush(_modalBuilder)))))
      ],
    );
  }

  Column _editUser() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Edit"),
      ],
    );
  }

  @pragma('vm:entry-point')
  static Route<void> _modalBuilder(BuildContext context, Object? arguments) {
    return CupertinoModalPopupRoute<void>(
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(AppLocalizations.of(context)!.delete_account),
          message:
              Text(AppLocalizations.of(context)!.delete_account_question_modal),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.yes),
              onPressed: () {
                // logout -> logout should redirect also
                // remove account
                // redirect to login view
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
        );
      },
    );
  }
}
