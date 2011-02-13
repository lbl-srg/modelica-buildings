within Buildings.Fluid.Sensors;
model MassFraction "Ideal one port mass fraction sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RotationalSensor;
  parameter String substanceName = "water" "Name of species substance";

  Modelica.Blocks.Interfaces.RealOutput X(min=0, max=1)
    "Mass fraction in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));

protected
  parameter Integer ind(fixed=false)
    "Index of species in vector of auxiliary substances";
  Medium.MassFraction XiVec[Medium.nXi](
      quantity=Medium.extraPropertiesNames)
    "Trace substances vector, needed because indexed argument for the operator inStream is not supported";
initial algorithm
  ind:= -1;
  for i in 1:Medium.nX loop
    if ( Modelica.Utilities.Strings.isEqual(Medium.substanceNames[i], substanceName)) then
      ind := i;
    end if;
  end for;
  assert(ind > 0, "Species with name '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  XiVec = inStream(port.Xi_outflow);
  X = if ind > Medium.nXi then (1-sum(XiVec)) else XiVec[ind];
annotation (defaultComponentName="senMasFra",
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),     graphics),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{0,-70},{0,-100}}, color={0,0,127}),
        Text(
          extent={{-150,80},{150,120}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{160,-30},{60,-60}},
          lineColor={0,0,0},
          textString="X"),
        Line(points={{70,0},{100,0}}, color={0,0,127})}),
  Documentation(info="<HTML>
<p>
This component monitors the mass fraction contained in the fluid passing its port. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
April 7, 2009 by Michael Wetter:<br>
First implementation based on enthalpy sensor of Modelica.Fluid.
</li>
</ul>
</html>"));
end MassFraction;
