import 'package:am_i_dreaming/src/util/date_formater.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserForm extends StatefulWidget {
  UserForm({super.key}) {
    var countryService = CountryService();
    countries = countryService.getAll();
  }

  late final List<Country> countries;

  @override
  State<StatefulWidget> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_UserFormState');
  final _controller = TextEditingController();
  final _nameMaxLength = 30;
  final _cityMaxLength = 30;
  final _prefixFontSize = 20.0;
  final _textFontSize = 20.0;
  final _prefixColor = CupertinoColors.white;
  final _textColor = CupertinoColors.systemTeal;
  final _maxYear = DateTime.now().subtract(const Duration(days: 10 * 365));

  var _date;

  get date => _maxYear;

  var _time = DateTime.now();

  int _selectedCountry = 0;

  @override
  Widget build(BuildContext contexts) {
    return SafeArea(
        child: Column(children: [
      Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: CupertinoFormSection.insetGrouped(
          header: Center(
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    AppLocalizations.of(context)!.about_you_form,
                    style: const TextStyle(
                        color: CupertinoColors.systemTeal,
                        fontSize: 28,
                        fontWeight: FontWeight.w600),
                  ))),
          children: <Widget>[
            CupertinoTextFormFieldRow(
              textAlign: TextAlign.end,
              textCapitalization: TextCapitalization.sentences,
              prefix: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    AppLocalizations.of(context)!.user_name,
                    style: TextStyle(
                        color: _prefixColor,
                        fontSize: _prefixFontSize,
                        fontWeight: FontWeight.w600),
                  )),
              autofillHints: const [AutofillHints.name],
              placeholder: AppLocalizations.of(context)!.user_name,
              keyboardType: TextInputType.name,
              controller: _controller,
              autofocus: true,
              maxLength: _nameMaxLength,
              style: TextStyle(
                  fontSize: _textFontSize,
                  fontWeight: FontWeight.w600,
                  color: _textColor),
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
            CupertinoFormRow(
                prefix: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      AppLocalizations.of(context)!.birth_date,
                      style: TextStyle(
                          color: _prefixColor,
                          fontSize: _prefixFontSize,
                          fontWeight: FontWeight.w600),
                    )),
                child: CupertinoButton(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Text(
                        formatTimestampToDate(
                            context, date.millisecondsSinceEpoch),
                        style: TextStyle(
                            fontSize: _textFontSize,
                            fontWeight: FontWeight.w600,
                            color: _textColor)),
                    onPressed: () => _showDialog(
                          CupertinoDatePicker(
                            initialDateTime: _maxYear,
                            mode: CupertinoDatePickerMode.date,
                            use24hFormat: true,
                            showDayOfWeek: true,
                            maximumDate: _maxYear,
                            onDateTimeChanged: (DateTime newDate) =>
                                setState(() => _date = newDate),
                          ),
                        ))),
            CupertinoFormRow(
                prefix: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      AppLocalizations.of(context)!.birth_date_time,
                      style: TextStyle(
                          color: _prefixColor,
                          fontSize: _prefixFontSize,
                          fontWeight: FontWeight.w600),
                    )),
                child: CupertinoButton(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Text(
                        formatTimestampToTime(
                            context, date.millisecondsSinceEpoch),
                        style: TextStyle(
                            fontSize: _textFontSize,
                            fontWeight: FontWeight.w600,
                            color: _textColor)),
                    onPressed: () => _showDialog(
                          CupertinoDatePicker(
                            initialDateTime: _time,
                            mode: CupertinoDatePickerMode.time,
                            use24hFormat: true,
                            showDayOfWeek: true,
                            onDateTimeChanged: (DateTime newDate) =>
                                setState(() => _time = newDate),
                          ),
                        ))),
            CupertinoTextFormFieldRow(
              textAlign: TextAlign.end,
              textCapitalization: TextCapitalization.sentences,
              prefix: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    AppLocalizations.of(context)!.birth_city,
                    style: TextStyle(
                        color: _prefixColor,
                        fontSize: _prefixFontSize,
                        fontWeight: FontWeight.w600),
                  )),
              keyboardType: TextInputType.streetAddress,
              autofillHints: const [AutofillHints.addressCity],
              placeholder: AppLocalizations.of(context)!.birth_city,
              controller: _controller,
              autofocus: true,
              maxLength: _cityMaxLength,
              style: TextStyle(
                  fontSize: _textFontSize,
                  fontWeight: FontWeight.w600,
                  color: _textColor),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .city_min_length_validation;
                }
                if (value.length > _cityMaxLength) {
                  return AppLocalizations.of(context)!
                      .city_max_length_validation(_cityMaxLength);
                }
                return null;
              },
            ),
            CupertinoFormRow(
                prefix: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      AppLocalizations.of(context)!.birth_country,
                      style: TextStyle(
                          color: _prefixColor,
                          fontSize: _prefixFontSize,
                          fontWeight: FontWeight.w600),
                    )),
                child: CupertinoButton(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                    child: Text(
                        textAlign: TextAlign.end,
                        translateCountry(contexts, _selectedCountry),
                        style: TextStyle(
                            fontSize: _textFontSize,
                            fontWeight: FontWeight.w600,
                            color: _textColor)),
                    // Display a CupertinoPicker with list of fruits.
                    onPressed: () => _showDialog(
                          CupertinoPicker(
                            looping: true,
                            magnification: 2.35 / 2.1,
                            squeeze: 1.25,
                            useMagnifier: true,
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(
                              initialItem: _selectedCountry,
                            ),
                            onSelectedItemChanged: (int selectedItem) {
                              setState(() {
                                _selectedCountry = selectedItem;
                              });
                            },
                            children: List<Widget>.generate(
                                widget.countries.length, (int index) {
                              return Center(
                                  child:
                                      Text(translateCountry(contexts, index)));
                            }),
                          ),
                        )))
          ],
        ),
      )
    ]));
  }

  String translateCountry(BuildContext contexts, int index) =>
      CountryLocalizations.of(contexts)!
          .countryName(countryCode: widget.countries[index].countryCode) ??
      widget.countries[index].displayName;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 256,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
