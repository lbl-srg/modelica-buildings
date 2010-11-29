within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckCeilingHeight
  "Ensures that the ceiling height is not lower than bound"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput ceiHeiIn(final quantity="Height", final unit
      =    "m") "Input ceiling height"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput ceiHeiOut(final quantity="Height",
      final unit="m") "Ceiling height"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  constant Modelica.SIunits.Height ceiHeiMin=0 "Minimum allowed ceiling height";
equation

  ceiHeiOut = Buildings.Utilities.Math.Functions.smoothMax(
    ceiHeiIn,
    ceiHeiMin,
    0.1);

  annotation (
    defaultComponentName="cheCeiHei",
    Documentation(info="<HTML>
<p>
This component ensures that the ceiling height is no less than -1000m.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-28,42},{26,-34}},
          lineColor={0,0,255},
          textString="m")}));
end CheckCeilingHeight;
