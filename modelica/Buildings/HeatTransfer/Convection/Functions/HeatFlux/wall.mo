within Buildings.HeatTransfer.Convection.Functions.HeatFlux;
function wall "Free convection, wall"
  extends
    Buildings.HeatTransfer.Convection.Functions.HeatFlux.BaseClasses.PartialHeatFlux;
algorithm
  q_flow := sign(dT)*1.3*abs(dT)^1.3333;

annotation (Documentation(info=
"<html>
This function computes the buoyancy-driven convective heat transfer coefficient 
for a wall as
<code>h=1.3*|dT|^0.3333</code>,
where <code>dT</code> is the solid temperature minus the fluid temperature.
The convective convective heat flux is then
<code>q_flow = h * dT</code>.
</html>",
revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end wall;
