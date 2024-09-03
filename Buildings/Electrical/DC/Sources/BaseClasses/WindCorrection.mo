within Buildings.Electrical.DC.Sources.BaseClasses;
block WindCorrection "Block for wind correction"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Height h "Height over ground";
  parameter Modelica.Units.SI.Height hRef
    "Reference height for wind measurement";
  parameter Real n(min=0) = 0.4 "Height exponent for wind profile calculation";
  Modelica.Blocks.Interfaces.RealOutput vLoc( unit="m/s")
    "Wind velocity at the location"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput vRef(unit="m/s")
    "Wind velocity at the reference height"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-142,-20},{-102,20}})));
equation
  vLoc=vRef * (h / hRef)^n;
  annotation (
  defaultComponentName = "cor",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Text(
          extent={{-92,48},{-32,-50}},
          textColor={0,128,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="vRef"),
        Polygon(
          points={{26,0},{6,20},{6,10},{-24,10},{-24,-10},{6,-10},{6,-20},{26,0}},
          lineColor={0,128,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{30,50},{90,-48}},
          textColor={0,128,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="vLoc")}),Documentation(info="<html>
<p>
This model calculates the wind velocity at the location as a function of the height over ground.
The equation is based on Gash (1991).

The model computes the wind velocity <i>vLoc</i> as
</p>

<p align=\"center\" style=\"font-style:italic;\">
vLoc = vRef * (h / hRef)<sup>n</sup>
</p>

<p>
where <i>vRef</i> is the wind velocity at the reference height, <i>h</i> is the height over ground, <i>hRef</i>
is the reference height, and <i>n</i> is the height exponent for wind calculation.
</p>
<h4>Reference</h4>
<p>
Gasch, R. 1991. Windkraftanlagen. Grundlagen und Entwurf (German). Teubner, Stuttgart.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 2, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
February 7, 2013, by Michael Wetter:<br/>
Removed <code>final</code> keyword for parameters to allow users to adjust them,
and removed default value for <code>h</code>.
</li>
<li>
February 1, 2013, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end WindCorrection;
