within Buildings.Templates.AHUs.Types;
type HeatExchanger = enumeration(
    DXMultiStage
    "Direct expansion - Multi-stage",
    DXVariableSpeed
    "Direct expansion - Variable speed",
    WaterEpsNTUWet
    "Water based - Effectiveness-NTU dry/wet coil",
    WaterEpsNTUDry
    "Water based - Effectiveness-NTU dry coil",
    WaterDiscretized
    "Water based - Discretized",
    None
    "None")
  "Enumeration to configure the HX";
