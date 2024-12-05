import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DreamInput extends StatefulWidget {
  const DreamInput({super.key, required this.addDream});

  final FutureOr<void> Function(String dream) addDream;

  @override
  State<StatefulWidget> createState() => _DreamInputState();
}

class _DreamInputState extends State<DreamInput> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_DreamInputState');
  final _controller = TextEditingController();
  final _dreamMaxLength = 500;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          CupertinoTextFormFieldRow(
            placeholder: AppLocalizations.of(context)!.describe_dream,
            controller: _controller,
            maxLines: 5,
            minLines: 5,
            autofocus: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!
                    .validation_enter_describe_dream;
              }
              if (value.length >= _dreamMaxLength) {
                return AppLocalizations.of(context)!
                    .validation_too_long_describe_dream(_dreamMaxLength);
              }
              return null;
            },
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addDream(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.button_add_dream),
                ),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
