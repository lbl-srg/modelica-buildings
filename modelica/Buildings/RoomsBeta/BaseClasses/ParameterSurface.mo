within Buildings.RoomsBeta.BaseClasses;
record ParameterSurface "Record for surfaces that are used in the room model"
  extends Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic;

  parameter Buildings.RoomsBeta.Types.ConvectionModel conMod=
    Buildings.RoomsBeta.Types.ConvectionModel.Fixed
    "Convective heat transfer model"
  annotation(Evaluate=true);
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hFixed=3
    "Constant convection coefficient"
    annotation (Dialog(enable=(conMod == Buildings.RoomsBeta.Types.ConvectionModel.fixed)));

  annotation (
Documentation(info="<html>
<p>
This data record is used to set the parameters of surfaces
that are used in the room model.
</p>
<p>
The surface tilt is defined in <a href=\"modelica://Buildings.RoomsBeta.Types.Tilt\">
Buildings.RoomsBeta.Types.Tilt</a>
</p>
</html>", revisions="<html>
<ul>
<li>
January 14, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end ParameterSurface;
