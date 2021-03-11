within Buildings.Templates.AHUs.Types;
type Damper = enumeration(
    NoPath
    "No fluid path",
    Nonactuated
    "Nonactuated",
    Modulated
    "Modulated damper",
    None
    "No damper",
    TwoPosition
    "Two-position damper")
  "Enumeration to configure the damper";
