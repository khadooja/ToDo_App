/// Shared spacing scale. Using these instead of ad-hoc numbers (the old
/// code had `10`, `20`, `6`, `8`, `12` scattered with no system behind them)
/// keeps paddings/margins visually consistent across the app.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
  static const double xxl = 36;
}

/// Shared corner-radius scale for cards, sheets, buttons, chips.
class AppRadius {
  AppRadius._();

  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double pill = 999;
}
