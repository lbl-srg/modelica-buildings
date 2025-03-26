within Buildings.Fluid.DXSystems.Cooling.BaseClasses;
block SpeedShift "Interpolates values between speeds"
  parameter Integer nSta "Number of standard compressor speeds";
  parameter Modelica.Units.SI.AngularVelocity speSet[nSta](each displayUnit=
        "1/min") "Compressor speeds";
  constant Boolean variableSpeedCoil "Flag, set to true to interpolate data";

  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput u[nSta] "Array to be interpolated"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput y "Interpolated value"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.IntegerInput stage
    "Stage of coil, or 0/1 for variable-speed coil"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
equation
  if variableSpeedCoil then
    y=Buildings.Fluid.DXSystems.Cooling.BaseClasses.Functions.speedShift(
      spe=speRat*speSet[nSta],
      speSet=speSet,
      u=u);
  else
    y = if stage == 0 then 0  else u[stage];
  end if;
  annotation (defaultComponentName="speSh",
  Documentation(info="<html>
<p>
This block uses the
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.Functions.speedShift\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.Functions.speedShift</a> function
to interpolate the input array.
Depending on input speed ratio and speed set array the input array <i>u</i> is interpolated.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 24, 2012, by Michael Wetter:<br/>
Moved function from
<code>Buildings.Fluid.DXSystems.BaseClasses</code>
to
<code>Buildings.Fluid.DXSystems.Cooling.BaseClasses.Functions</code>
because the package
<code>Buildings.Fluid.DXSystems.BaseClasses</code>
already contains a block called
<code>SpeedShift</code> which gives a clash in file names on file systems
that do not distinguish between upper and lower case letters.
</li>
<li>
Aug. 9, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(extent={{-120,140},{120,100}},
          textColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-70,68},{70,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(points={{0,68},{0,38}}, color={0,0,0}),
        Line(points={{25,36},{39.2,56.3}},     color={0,0,0}),
        Line(points={{-25,36},{-39.2,56.3}},     color={0,0,0}),
        Line(points={{41,15},{65.8,23.9}},     color={0,0,0}),
        Line(points={{-43,15},{-64.8,23.9}},     color={0,0,0}),
        Line(points={{0,0},{9.02,28.6}}, color={0,0,0}),
        Polygon(
          points={{6,29},{12,27},{15,45},{6,29}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-5,5},{5,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-66.4,-23.3},{-42,-14}}, color={0,0,0}),
        Line(points={{66.4,-23.3},{41,-15}},     color={0,0,0}),
        Line(
          points={{-70,0},{-57,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{57,0},{70,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-54,42},{-44,35}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,64},{-16,54}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{22,64},{18,52}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{54,42},{46,34}},
          color={0,0,0},
          smooth=Smooth.None)}));
end SpeedShift;
