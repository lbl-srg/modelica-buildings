within Buildings.Experimental.Templates.AHUs.Types;
type Main = enumeration(
    SupplyOnly
    "Supply only system",
    ExhaustOnly
    "Exhaust only system",
    SupplyReturn
    "Supply and return system") "Enumeration to configure the AHU";
