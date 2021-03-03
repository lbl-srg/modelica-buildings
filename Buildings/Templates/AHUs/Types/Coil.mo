within Buildings.Experimental.Templates.AHUs.Types;
type Coil = enumeration(
    None
    "No economizer",
    WaterBased
    "Water-based coil",
    DXMultiStage
    "Direct expansion, multi-stage",
    DXVariableSpeed
    "Direct expansion, variable speed") "Enumeration to configure the coil";
