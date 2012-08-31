within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block SpeedShift "Interpolates values beween two speeds"
  parameter Integer nSpe "Number of standard compressor speeds";
  parameter Modelica.SIunits.AngularVelocity maxSpe(displayUnit="1/min")= speSet[nSpe]
    "Maximum rotational speed";
  parameter Real speSet[nSpe] "Array of standard compressor speeds";
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput u[nSpe] "Array to be interpolated"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput y "Interpolated value"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealOutput spe(displayUnit="1/min")
    "Rotational speed"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
equation
  spe=speRat*maxSpe;
  y=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift(
    spe=spe,
    speSet=speSet,
    u=u);
  annotation (defaultComponentName="speSh",
  Documentation(info="<html>
<p>
This block uses the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift</a> function 
to interpolate the input array.
Depending on input speed ratio and speed set array the input array u is interpolated.  
</p>
</html>",
revisions="<html>
<ul>
<li>
August 24, 2012, by Michael Wetter:<br>
Moved function from 
<code>Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses</code>
to 
<code>Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions</code>
because the package 
<code>Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses</code>
already contains a block called 
<code>SpeedShift</code> which gives a clash in file names on file systems
that do not distinguish between upper and lower case letters.
</li>
<li>
Aug. 9, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),
  Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(extent={{-120,140},{120,100}},
          lineColor={0,0,255},
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
