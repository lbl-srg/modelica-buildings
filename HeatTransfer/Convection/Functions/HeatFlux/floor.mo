within Buildings.HeatTransfer.Convection.Functions.HeatFlux;
function floor "Free convection, floor"
  extends
    Buildings.HeatTransfer.Convection.Functions.HeatFlux.BaseClasses.PartialHeatFlux;

algorithm
  q_flow  := noEvent(smooth(1, if (dT>0) then 1.51*dT^1.3333 else -0.76*(-dT)^1.3333));
annotation(smoothOrder=1,
              Documentation(info=
"<html>
This function computes the buoyancy-driven convective heat transfer coefficient 
for a floor as
<code>h=k*|dT|^0.3333</code>,
where 
<code>k=1.51</code> if the floor is warmer than the fluid,
or <code>k=0.76</code> otherwise, and where
<code>dT</code> is the solid temperature minus the fluid temperature.
The convective heat flux is then
<code>q_flow = h * dT</code>.
</html>",
revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end floor;
