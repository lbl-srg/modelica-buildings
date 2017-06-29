within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type AHUMode = enumeration(
    occupied   "Occupied Mode",
    coolDown   "Cool-down Mode",
    setup   "Setup Mode",
    warmup   "Warmup Mode",
    setback   "Setback Mode",
    freezeProtectionSetback   "Freeze Protection Setback Mode",
    unoccupied   "Unoccupied Mode") "AHU System Modes";

annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
