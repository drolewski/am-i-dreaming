import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<StatefulWidget> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_UserFormState');
  final _controller = TextEditingController();
  final _nameMaxLength = 30;

  @override
  Widget build(BuildContext contexts) {
    return CupertinoPageScaffold(
        child: SafeArea(
            child: Column(children: [
      Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            CupertinoTextFormFieldRow(
              autofillHints: const [AutofillHints.name],
              autovalidateMode: AutovalidateMode.always,
              placeholder: AppLocalizations.of(context)!.user_name,
              controller: _controller,
              autofocus: true,
              maxLength: _nameMaxLength,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .user_name_min_length_validation;
                }
                if (value.length > _nameMaxLength) {
                  return AppLocalizations.of(context)!
                      .user_name_max_length_validation(_nameMaxLength);
                }
                return null;
              },
            ),
          ],
        ),
      )
    ])));
  }
}
