within Buildings.HeatTransfer.Convection.Functions.HeatFlux;
function constantCoefficient "Constant convective heat transfer coefficient"
  extends
    Buildings.HeatTransfer.Convection.Functions.HeatFlux.BaseClasses.PartialHeatFlux;
  input Modelica.SIunits.CoefficientOfHeatTransfer hCon = 3
    "Constant for convective heat transfer coefficient";
algorithm
  q_flow :=hCon*dT;
annotation (Documentation(info=
                             "<html>
This function computes the convective heat transfer coefficient as
<code>h=hCon</code>, where <code>hCon=3</code> is a default input argument.
The convective heat flux is
<code>q_flow = h * dT</code>,
where <code>dT</code> is the solid temperature minus the fluid temperature.
</html>",
        revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end constantCoefficient;
