within Buildings.Templates.AHUs.Types;
type Damper = enumeration(
    NoConnection
    "No damper, neither a fluid connection",
    Nonactuated
    "Nonactuated",
    Modulated
    "Modulated damper",
    None
    "No damper",
    TwoPosition
    "Two-position damper")
  "Enumeration to configure the damper";
