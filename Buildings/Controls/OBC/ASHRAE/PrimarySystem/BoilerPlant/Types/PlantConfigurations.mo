within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types;
type PlantConfigurations = enumeration(
    primaryHeadered
                "Primary only, Headered pumps",
    primarySecondaryDedicated
                          "Primary-Secondary, Dedicated Primary Pumps",
    primarySecondaryHeadered
                         "Primary-Secondary, Headered Primary Pumps",
    distributedSecondaryHeadered
                             "Primary-Distributed Secondary, Headered Primary Pumps",
    separatePrimaryCommonSecondary
                               "Hybrid, Separate Non-Condensing and Condensing
                                Primary Loops, Common Secondary")
"Definitions for boiler plant configurations";
