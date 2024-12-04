class MoonPhaseModel {
  MoonPhaseModel({required this.name, required this.icon});

  final MoonPhaseEnum name;
  final String icon;
}

enum MoonPhaseEnum {
  newMoon,
  firstQuarter,
  fullMoon,
  lastQuarter;
}
