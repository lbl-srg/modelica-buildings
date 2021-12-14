within Buildings.ThermalZones.Detailed.BaseClasses;
record CFDSurfaceIdentifier "Data record to identify surfaces in the CFD code"
    extends Modelica.Icons.Record;
 String name "Name of the surface";
  Modelica.Units.SI.Area A "Area of the surface";
  Modelica.Units.SI.Angle til "Tilt of the surface";
 Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions bouCon
    "Boundary condition used in the CFD simulation";

annotation (
Documentation(
info="<html>
<p>
This record is a data structure that is used to assemble
information that is used in the CFD to identify surface data
that are exchanged with Modelica.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 18, 2021, by Francesco Casella:<br/>
Removed parameter prefix for OpenModelica.<br/>
See
<a href=\"https://github.com/OpenModelica/OpenModelica/issues/7839\">OpenModelica, #7839</a>.
</li>
<li>
July 30, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end CFDSurfaceIdentifier;
