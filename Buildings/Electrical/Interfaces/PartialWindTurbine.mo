within Buildings.Electrical.Interfaces;
model PartialWindTurbine
  "Partial model of a wind turbine with power output based on table as a function of wind speed"
  extends Buildings.Electrical.Interfaces.PartialWindTurbineBase;
  replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem
       constrainedby Buildings.Electrical.PhaseSystems.PartialPhaseSystem
    "Phase system"
    annotation (choicesAllMatching=true);

  replaceable Buildings.Electrical.Interfaces.Terminal terminal(
    redeclare package PhaseSystem = PhaseSystem) "Generalized terminal"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds per(
    final tableOnFile=tableOnFile,
    final table=cat(1, cat(1, [0, 0], table),
                    [vOut+10*Modelica.Constants.eps, 0;
                     vOut+20*Modelica.Constants.eps, 0]),
    final tableName=tableName,
    final fileName=fileName,
    final columns=2:2,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Performance table that maps wind speed to electrical power output"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Modelica.Blocks.Math.Gain gain(final k=scale)
    "Gain, used to allow a user to easily scale the power"
    annotation (Placement(transformation(extent={{2,20},{22,40}})));
  DC.Sources.BaseClasses.WindCorrection                      cor(
    final h=h,
    final hRef=hRef,
    final n=nWin) "Correction for wind"
  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-50,30})));
initial equation
  assert(abs(table[1,2]) < Modelica.Constants.eps,
  "First data point of performance table must be at cut-in wind speed,
   and be equal to 0 Watts.
   Received + " + String(table[1,1]) + " m/s with " + String(table[1,2]) + " Watts");
equation
  assert(gain.y>=0, "Wind power must be positive");
  connect(per.y[1],gain. u) annotation (Line(
      points={{-9,30},{0,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vWin,cor. vRef) annotation (Line(
      points={{1.77636e-15,120},{1.77636e-15,90},{-70,90},{-70,30},{-62.2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cor.vLoc,per. u) annotation (Line(
      points={{-39,30},{-32,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, P) annotation (Line(
      points={{23,30},{60,30},{60,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,102},{100,-98}},
          pattern=LinePattern.None,
          fillColor={202,230,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{42,46},{46,-52}},
          fillColor={233,233,233},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-42,14},{-38,-84}},
          fillColor={233,233,233},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-44,12},{-26,-40},{-38,16},{-44,12}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-38,12},{8,46},{-42,18},{-38,12}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-42,12},{-90,40},{-38,18},{-42,12}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{40,44},{100,40},{42,50},{40,44}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-21,-17},{27,17},{-25,-11},{-21,-17}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          origin={29,69},
          rotation=90,
          lineColor={0,0,0}),
        Polygon(
          points={{24,-14},{-20,22},{26,-8},{24,-14}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          origin={32,20},
          rotation=90,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-46,20},{-34,8}},
          lineColor={0,0,0},
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{38,52},{50,40}},
          lineColor={0,0,0},
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-42,134},{-20,108}},
          textColor={0,0,127},
          textString="v"),
        Text(
          extent={{100,100},{122,74}},
          textColor={0,0,127},
          textString="P")}),
    Documentation(info="<html>
<p>
Model of a wind turbine whose power is computed as a function of wind-speed as defined in a table.
</p>
<p>
Input to the model is the local wind speed.
The model requires the specification of a table that maps wind speed in meters per second to generated
power <i>P<sub>t</sub></i> in Watts.
The model has a parameter called <code>scale</code> with a default value of one
that can be used to scale the power generated by the wind turbine.
The generated electrical power is
<p align=\"center\" style=\"font-style:italic;\">
P = P<sub>t</sub> scale
</p>
<p>
For example, the following specification (with default <code>scale=1</code>) of a wind turbine
</p>
<pre>
  WindTurbine_Table tur(
    table=[3.5, 0;
           5.5,   100;
           12, 900;
           14, 1000;
           25, 1000]) \"Wind turbine\";
</pre>
<p>
yields the performance shown below. In this example, the cut-in wind speed is
<i>3.5</i> meters per second,
and the cut-out wind speed is <i>25</i> meters per second,
as entered by the first and last entry of the wind speed column.
Below and above these wind speeds, the generated power is zero.
</p>
<p align=\"center\">
<img alt=\"alt-image\" src=\"modelica://Buildings/Resources/Images/Electrical/DC/Sources/WindTurbine_Table.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
March 1, 2016, by Michael Wetter:<br/>
Removed test for equality of <code>Real</code> variables.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/493\">issue 493</a>.
</li>
<li>
January 10, 2013, by Michael Wetter:<br/>
First implementation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Models included in the Buildings library. Modified the information section.
</li>
</ul>
</html>"));
end PartialWindTurbine;
