within Buildings.HeatTransfer.Convection.Functions.HeatFlux.BaseClasses;
partial function PartialHeatFlux "Partial function for convective heat flux"
 input Modelica.SIunits.TemperatureDifference dT
    "Temperature difference solid minus fluid";
 output Modelica.SIunits.HeatFlux q_flow
    "Convective heat flux from solid to fluid";
annotation (Documentation(info=
                             "<html>
Partial function that is used to implement the convective heat flux
as <code>q_flow = f(dT)</code>,
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
end PartialHeatFlux;
