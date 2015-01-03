within Buildings.HeatTransfer.Convection.Functions.HeatFlux;
function ceiling "Free convection, ceiling"
  extends
    Buildings.HeatTransfer.Convection.Functions.HeatFlux.BaseClasses.PartialHeatFlux;

algorithm
   q_flow  := noEvent(smooth(1, if (dT>0) then 0.76*dT^1.3333 else -1.51*(-dT)^1.3333));

annotation(smoothOrder=1,
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
<i>h</i> is the convective heat transfer coefficient
for a ceiling, computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
h=k |&Delta;T|<sup>0.3333</sup>,
</p>
<p>
where
<i>k=1.51</i> if the fluid is warmer than the ceiling,
or <i>k=0.76</i> otherwise.
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
end ceiling;
