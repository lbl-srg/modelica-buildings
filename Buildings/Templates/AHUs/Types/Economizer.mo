within Buildings.Experimental.Templates.AHUs.Types;
type Economizer = enumeration(
    None
    "No economizer",
    CommonDamperTandem
    "Single common OA damper - Dampers actuated in tandem",
    DedicatedDamperTandem
    "Separate dedicated OA damper - Dampers actuated in tandem",
    CommonDamperFree
    "Single common OA damper - Dampers actuated individually",
    CommonDamperFreeNoRelief
    "Single common OA damper - Dampers actuated individually, no relief") "Enumeration to configure the economizer";
