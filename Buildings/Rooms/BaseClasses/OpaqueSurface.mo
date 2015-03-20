within Buildings.Rooms.BaseClasses;
record OpaqueSurface "Record for exterior constructions that have no window"
  extends Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic;
  parameter String name = ""
    "Surface name. Optional for MixedAir, required for CFD.";

  parameter Buildings.Rooms.Types.CFDBoundaryConditions boundaryCondition=
    Buildings.Rooms.Types.CFDBoundaryConditions.Temperature
    "Boundary condition used in the CFD simulation"
    annotation(Dialog(group="Boundary condition"));

  annotation (
Documentation(info="<html>
<p>
This data record is used to set the parameters of opaque surfaces.
</p>
<p>
The surface tilt is defined in <a href=\"modelica://Buildings.Types.Tilt\">
Buildings.Types.Tilt</a>
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end OpaqueSurface;
