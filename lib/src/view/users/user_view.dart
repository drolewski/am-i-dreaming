import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            child: _isEditModeEnabled ? _editUser() : _displayUser()));
  }

  Column _displayUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Imię"),
        Text("Data urodzenia"),
        Text("Płeć"),
        Text("miejsce urodzenia"),
        Text("godzina urodzenia"),
        Text("Dane wyliczone przez system"),
        CupertinoButton(
            child: Text("premium"), onPressed: () => print("premium")),
        CupertinoButton(
            child: Text("wyloguj"), onPressed: () => print("wyloguj")),
        CupertinoButton(
            child: Text("Usuń konto"), onPressed: () => print("usuń konto"))
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
}
