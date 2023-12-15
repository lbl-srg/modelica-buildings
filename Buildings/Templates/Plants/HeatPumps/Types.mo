within Buildings.Templates.Plants.HeatPumps;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
  type Controller = enumeration(
      ClosedLoop "Closed ClosedLoop",
      OpenLoop "Open loop")
      "Enumeration to specify the plant controller";
  type Distribution = enumeration(
      Variable1Only "Variable primary-only",
      Constant1Variable2 "Constant primary - Variable secondary centralized",
      Variable1And2 "Variable primary - Variable secondary centralized")
      "Enumeration to specify the type of HW distribution system";
  type PumpsPrimary = enumeration(
      FactoryConstant "Constant speed pump provided with heat pump with factory controls",
      FactoryVariable "Variable speed pump provided with heat pump with factory controls",
      Constant "Constant speed pump specified separately",
      Variable "Variable speed pump specified separately")
      "Enumeration to specify the type of primary pumps";
  type PumpsSecondary = enumeration(
      None "No secondary pumps (primary-only)",
      Centralized "Variable secondary centralized")
      "Enumeration to specify the type of secondary HW pumps";
  type SensorLocation = enumeration(
      Return "Sensor in the return line",
      Supply "Sensor in the supply line")
      "Enumeration to specify the sensor location";
  annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
