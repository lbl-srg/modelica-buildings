within Buildings.Utilities.Math;
block Splice "Block for splice function opertation"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput x "Independent value"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput u1 "Argument of u > 0 (pos)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput u2 "Argument of u < 0 (neg)"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput y "Smoothed value"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
parameter Real deltax "Half width of transition interval";
equation
  y=Buildings.Utilities.Math.Functions.spliceFunction(
    pos=u1,
    neg= u2,
    x= x,
    deltax= deltax);
  annotation (defaultComponentName="spl",Icon(graphics={
    Polygon(
      points={{0,88},{-6,72},{6,72},{0,88}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-35,90},{-6,72}},
      textColor={160,160,164},
      textString="y"),
    Line(points={{0,-90},{0,84}}, color={192,192,192}),
        Line(
          points={{-82,-74},{-40,-74},{-18,-58},{-6,-34},{0,-10},{14,24},{32,44},
              {46,48},{80,48}}),
    Text(
      extent={{-53,-78},{-24,-96}},
      textColor={160,160,164},
          textString="-delta"),
    Text(
      extent={{34,-78},{60,-94}},
      textColor={160,160,164},
          textString="delta"),
    Line(points={{46,-78},{46,56}},
                                  color={192,192,192}),
    Line(points={{-40,-80},{-40,-68}},
                                  color={192,192,192}),
    Text(
      extent={{49,38},{88,22}},
      textColor={160,160,164},
          textString="if x > 0"),
    Text(
      extent={{-81,-58},{-42,-74}},
      textColor={160,160,164},
          textString="if x < 0"),
    Text(
      extent={{-74,-46},{-52,-58}},
      textColor={160,160,164},
          textString="u2"),
    Text(
      extent={{54,48},{76,36}},
      textColor={160,160,164},
          textString="u1")}),
Documentation(info="<html>
<p>
This block implements <a href=\"modelica://Buildings.Utilities.Math.Functions.spliceFunction\">
Buildings.Utilities.Math.Functions.spliceFunction</a>, which provides a continuously differentiable transition between two arguments.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 31, 2012, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
July 30, 2012, by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end Splice;
