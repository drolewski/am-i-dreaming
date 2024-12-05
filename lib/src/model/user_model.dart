class UserModel {
  UserModel(
      {required this.sex,
      required this.name,
      required this.birthCity,
      required this.birthdayTimestampUTC,
      required this.birthCountryCode});

  final String name;
  final String birthCity;
  final int birthdayTimestampUTC;
  final String birthCountryCode;
  final String sex;
}
