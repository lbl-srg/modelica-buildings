within Buildings.Templates.AHUs.Types;
type HeatExchanger = enumeration(
    DXMultiStage
    "Direct expansion - Multi-stage",
    DXVariableSpeed
    "Direct expansion - Variable speed",
    WetCoilEffectivenessNTU
    "Water based - Effectiveness-NTU dry/wet coil",
    DryCoilEffectivenessNTU
    "Water based - Effectiveness-NTU dry coil",
    WetCoilCounterFlow
    "Water based - Discretized",
    None
    "None")
  "Enumeration to configure the HX";
