within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Types;
type ZoneState = enumeration(
    heating "Output of the space heating control loop is nonzero",
    deadband "When not in either Heating or Cooling",
    cooling "Output of the space cooling control loop is nonzero")
      "AHU Zone State";
