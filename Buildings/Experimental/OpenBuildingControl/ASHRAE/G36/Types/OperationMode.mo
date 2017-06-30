within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Types;
type OperationMode = enumeration(
    occupied "Occupied Mode",
    coolDown "Cool-down Mode",
    setup "Setup Mode",
    warmup "Warmup Mode",
    setback "Setback Mode",
    freezeProtectionSetback "Freeze Protection Setback Mode",
    unoccupied "Unoccupied Mode") "AHU System Modes";
