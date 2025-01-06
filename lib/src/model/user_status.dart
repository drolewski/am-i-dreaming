class UserStatus {
  UserStatus(
      {required this.id,
      required this.updatedAt,
      required this.isSingleHoroscopeGenerated,
      required this.areAllHoroscopesGenerated,
      required this.isPersonalizedHoroscopeGenerated,
      required this.numberOfDreams});

  final String? id;
  final int updatedAt;
  final bool isSingleHoroscopeGenerated;
  final bool areAllHoroscopesGenerated;
  final bool isPersonalizedHoroscopeGenerated;
  final int numberOfDreams;
}
