import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';

class CountryProvider {
  CountryProvider() {
    cs = CountryService();
  }

  late final CountryService cs;

  List<Country> getCountries() => cs.getAll();

  Country findByCode(String code) =>
      getCountries().firstWhere((country) => country.countryCode == code);

  String getCountryName(BuildContext context, String code) =>
      CountryLocalizations.of(context)!.countryName(countryCode: code) ??
      findByCode(code).displayName;
}
