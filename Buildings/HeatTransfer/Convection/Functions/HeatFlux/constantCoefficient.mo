within Buildings.HeatTransfer.Convection.Functions.HeatFlux;
function constantCoefficient "Constant convective heat transfer coefficient"
  extends
    Buildings.HeatTransfer.Convection.Functions.HeatFlux.BaseClasses.PartialHeatFlux;
  input Modelica.Units.SI.CoefficientOfHeatTransfer hCon=3
    "Constant for convective heat transfer coefficient";
algorithm
  q_flow :=hCon*dT;

annotation (
Documentation(info=
"<html>
<p>
This function computes the buoyancy-driven convective heat flux as
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
end constantCoefficient;
