within Buildings.HeatTransfer.Convection.Functions.HeatFlux.BaseClasses;
partial function PartialHeatFlux "Partial function for convective heat flux"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.TemperatureDifference dT
    "Temperature difference solid minus fluid";
  output Modelica.Units.SI.HeatFlux q_flow
    "Convective heat flux from solid to fluid";
annotation (Documentation(info=
"<html>
<p>
Partial function that is used to implement the convective heat flux
as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  q&#775; = h &Delta;T,
</p>
<p>
where
<i>&Delta;T</i> is the solid temperature minus the fluid temperature and
<i>h</i> is the convective heat transfer coefficient.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2014, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
March 10 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialHeatFlux;
