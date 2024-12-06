import 'dart:async';

import 'package:am_i_dreaming/src/model/user_model.dart';
import 'package:am_i_dreaming/src/util/date_formater.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../model/sex_enum.dart';

class UserForm extends StatefulWidget {
  UserForm({super.key, required this.addUser}) {
    var countryService = CountryService();
    countries = countryService.getAll();
  }

  late final List<Country> countries;
  final List<SexEnum> sexes = SexEnum.values;
  final FutureOr<void> Function(UserModel user) addUser;

  @override
  State<StatefulWidget> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_UserFormState');
  final _nameController = TextEditingController();
  final _birthCityController = TextEditingController();
  final _nameMaxLength = 30;
  final _cityMaxLength = 30;
  final _prefixFontSize = 20.0;
  final _textFontSize = 20.0;
  final _prefixColor = CupertinoColors.white;
  final _textColor = CupertinoColors.systemTeal;
  final _maxYear = DateTime.now().subtract(const Duration(days: 10 * 365));

  var _birthDate = DateTime.now().subtract(const Duration(days: 10 * 365));

  var _birthTime = DateTime.now();

  int _selectedCountryIndex = 175;

  var _selectedSexIndex = 0;

  bool _isReloading = false;

  @override
  Widget build(BuildContext contexts) {
    return _isReloading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(),
            child: SafeArea(
                child: Column(children: [
              Form(
                  key: _formKey,
                  child: Column(children: [
                    CupertinoFormSection.insetGrouped(
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          controller: _nameController,
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
                                  .user_name_max_length_validation(
                                      _nameMaxLength);
                            }
                            return null;
                          },
                        ),
                        CupertinoFormRow(
                            prefix: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  AppLocalizations.of(context)!.sex,
                                  style: TextStyle(
                                      color: _prefixColor,
                                      fontSize: _prefixFontSize,
                                      fontWeight: FontWeight.w600),
                                )),
                            child: CupertinoButton(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Text(
                                    textAlign: TextAlign.end,
                                    translateSex(contexts, _selectedSexIndex),
                                    style: TextStyle(
                                        fontSize: _textFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: _textColor)),
                                onPressed: () => _showDialog(
                                      CupertinoPicker(
                                        looping: true,
                                        magnification: 2.35 / 2.1,
                                        squeeze: 1.25,
                                        useMagnifier: true,
                                        itemExtent: 32,
                                        scrollController:
                                            FixedExtentScrollController(
                                          initialItem: _selectedSexIndex,
                                        ),
                                        onSelectedItemChanged:
                                            (int selectedItem) {
                                          setState(() {
                                            _selectedSexIndex = selectedItem;
                                            ;
                                          });
                                        },
                                        children: List<Widget>.generate(
                                            widget.sexes.length, (int index) {
                                          return Center(
                                              child: Text(translateSex(
                                                  contexts, index)));
                                        }),
                                      ),
                                    ))),
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
                                    formatTimestampToDate(context,
                                        _birthDate.millisecondsSinceEpoch),
                                    style: TextStyle(
                                        fontSize: _textFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: _textColor)),
                                onPressed: () => _showDialog(
                                      CupertinoDatePicker(
                                        initialDateTime: _birthDate,
                                        mode: CupertinoDatePickerMode.date,
                                        use24hFormat: true,
                                        showDayOfWeek: false,
                                        maximumYear: _maxYear.year,
                                        minimumYear: 1900,
                                        onDateTimeChanged: (DateTime newDate) =>
                                            setState(
                                                () => _birthDate = newDate),
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
                                    formatTimestampToTime(context,
                                        _birthTime.millisecondsSinceEpoch),
                                    style: TextStyle(
                                        fontSize: _textFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: _textColor)),
                                onPressed: () => _showDialog(
                                      CupertinoDatePicker(
                                        initialDateTime: _birthTime,
                                        mode: CupertinoDatePickerMode.time,
                                        use24hFormat: true,
                                        showDayOfWeek: true,
                                        onDateTimeChanged: (DateTime newDate) =>
                                            setState(
                                                () => _birthTime = newDate),
                                      ),
                                    ))),
                        CupertinoTextFormFieldRow(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          controller: _birthCityController,
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
                                    translateCountry(
                                        contexts, _selectedCountryIndex),
                                    style: TextStyle(
                                        fontSize: _textFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: _textColor)),
                                onPressed: () => _showDialog(
                                      CupertinoPicker(
                                        looping: true,
                                        magnification: 2.35 / 2.1,
                                        squeeze: 1.25,
                                        useMagnifier: true,
                                        itemExtent: 32,
                                        scrollController:
                                            FixedExtentScrollController(
                                          initialItem: _selectedCountryIndex,
                                        ),
                                        onSelectedItemChanged:
                                            (int selectedItem) {
                                          setState(() {
                                            _selectedCountryIndex =
                                                selectedItem;
                                          });
                                        },
                                        children: List<Widget>.generate(
                                            widget.countries.length,
                                            (int index) {
                                          return Center(
                                              child: Text(translateCountry(
                                                  contexts, index)));
                                        }),
                                      ),
                                    ))),
                      ],
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: CupertinoButton.filled(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _saveData();
                              }
                            },
                            child: Text(
                                AppLocalizations.of(context)!.save_user_data),
                          ),
                        ))
                  ]))
            ])));
  }

  Future<void> _saveData() async {
    setState(() {
      _isReloading = true;
    });
    await widget.addUser(UserModel(
        name: _nameController.text,
        sex: widget.sexes[_selectedSexIndex].name,
        birthCity: _birthCityController.text,
        birthdayTimestampUTC: birthDateTimestampUTC(),
        birthCountryCode: widget.countries[_selectedCountryIndex].countryCode));
    _birthCityController.clear();
    _nameController.clear();
    setState(() {
      _isReloading = false;
    });
    context.pushReplacement("/");
  }

  int birthDateTimestampUTC() {
    return DateTime(_birthDate.year, _birthDate.month, _birthDate.day,
            _birthTime.hour, _birthTime.minute)
        .toUtc()
        .millisecondsSinceEpoch;
  }

  String translateCountry(BuildContext contexts, int index) =>
      CountryLocalizations.of(contexts)!
          .countryName(countryCode: widget.countries[index].countryCode) ??
      widget.countries[index].displayName;

  String translateSex(BuildContext contexts, int index) =>
      SexEnum.translate(contexts, widget.sexes[index]);

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
