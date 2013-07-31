within Buildings.Rooms.BaseClasses;
record FFDSurfaceIdentifier "Data record to identify surfaces in the FFD code"
    extends Modelica.Icons.Record;
 parameter String name "Name of the surface";
 parameter Modelica.SIunits.Area A "Area of the surface";
 parameter Modelica.SIunits.Angle til "Tilt of the surface";
 parameter Types.CFDBoundaryConditions bouCon
    "Boundary condition used in the CFD simulation";

annotation (
Documentation(
info="<html>
<p>
This record is a data structure that is used to assemble
information that is used in FFD to identify surface data
that are exchanged with Modelica.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 30, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end FFDSurfaceIdentifier;
