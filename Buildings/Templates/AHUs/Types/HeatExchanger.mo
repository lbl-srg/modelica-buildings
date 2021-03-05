within Buildings.Templates.AHUs.Types;
type HeatExchanger = enumeration(
    EffectivenessNTUWet
    "Effectiveness-NTU dry/wet coil",
    EffectivenessNTUDry
    "Effectiveness-NTU dry coil",
    Discretized
    "Discretized",
    None
    "None")
  "Enumeration to configure the HX";
