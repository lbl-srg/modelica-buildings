within Buildings.Fluid.FMI.Interfaces;
connector MassFractionConnector =
  Modelica.Units.SI.MassFraction
  "Connector for mass fraction of water vapor per kg total mass"
  annotation (
  defaultComponentName="X_w",
  Icon(graphics,
    coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}},
      preserveAspectRatio=true,
      initialScale=0.2)),
  Diagram(
    coordinateSystem(preserveAspectRatio=true,
      initialScale=0.2,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Text(
      textColor={0,127,127},
      extent={{-10.0,60.0},{-10.0,85.0}},
      textString="%name")}),
  Documentation(info="<html>
<p>
Connector with variable of type <code>Modelica.Units.SI.MassFraction</code>.
Note that the mass fraction is in kg water vapor per total mass
of air, rathern than per kg of dry air.
</p>
<p>
This connector has been implemented to conditionally remove
the mass fraction if the medium has only one species.
While this could have been done using a vector of mass fractions
with zero length, as is used in fluid connectors,
this implemantation uses a scalar to avoid vectorized inputs
and outputs of FMUs.
</p>
</html>", revisions="<html>
<ul>
<li>
April 29,2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
