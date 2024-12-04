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

  MoonPhaseModel toModel() {
    Map<MoonPhaseEnum, String> icons = {
      MoonPhaseEnum.newMoon: "🌑",
      MoonPhaseEnum.firstQuarter: "🌓",
      MoonPhaseEnum.fullMoon: "🌕",
      MoonPhaseEnum.lastQuarter: "🌗",
    };

    return MoonPhaseModel(name: this, icon: icons[this] ?? "🌑");
  }
}
