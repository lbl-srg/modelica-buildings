within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block DryWetPredictor "Decides condition of the coil"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput XIn "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput XADP "Mass fraction at ADP"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput dryWetCoi(min=-1, max=1)
    "Surface condition of the coil (1=wet; -1=dry)"
     annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Utilities.Math.Splice spl(deltax=0.00001) "splice"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.RealExpression pos(y=1) "Wet coil condition"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Modelica.Blocks.Sources.RealExpression neg(y=-1) "Dry coil condition"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Modelica.Blocks.Math.Add dif(k2=-1) "Difference in mass fractions"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(XIn, dif.u1) annotation (Line(
      points={{-110,50},{-80,50},{-80,6},{-62,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XADP, dif.u2) annotation (Line(
      points={{-110,-50},{-80,-50},{-80,-6},{-62,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dif.y, spl.x) annotation (Line(
      points={{-39,6.10623e-16},{-1.5,6.10623e-16},{-1.5,6.66134e-16},{38,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(pos.y, spl.u1) annotation (Line(
      points={{1,40},{20,40},{20,6},{38,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(neg.y, spl.u2) annotation (Line(
      points={{1,-40},{20,-40},{20,-6},{38,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(spl.y, dryWetCoi) annotation (Line(
      points={{61,6.10623e-16},{81.5,6.10623e-16},{81.5,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="dryWetPre",
      Documentation(info="<html>
<p>
This block smoothly transits the output signal between -1 and 1 for dry and wet coil respectively 
by comparing water mass fractions at apparatus dew point and coil inlet 
[i.e. if X<sub>ADP</sub> &gt; X<sub>In</sub> dry coil condition (-1) and 
if X<sub>ADP</sub> &lt; X<sub>In</sub> wet coil condition (1)] 
</p>
</html>",
revisions="<html>
<ul>
<li>
August 9, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
      Icon(graphics={Text(
          extent={{-16,86},{96,54}},
          lineColor={0,0,255},
          textString="Dry = -1"), Text(
          extent={{-12,-46},{96,-78}},
          lineColor={0,0,255},
          textString="Wet = 1"),
        Ellipse(extent={{-58,28},{-2,-28}}, lineColor={0,0,255}),
        Line(
          points={{-100,50},{-82,50},{-50,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-100,-50},{-82,-50},{-50,-20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-42,14},{-16,0},{-40,-16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-2,0},{48,-48}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-2,0},{48,48}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.DashDotDot),
        Polygon(
          points={{48,48},{20,32},{30,22},{48,48}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.CrossDiag),
        Polygon(
          points={{48,-48},{20,-32},{30,-22},{48,-48}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(graphics));
end DryWetPredictor;
