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
