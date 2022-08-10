within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block HalfPeriodRatio
  "Calculates the half period ratio of a response from a relay controller"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn
    "Connector for a signal of the length for the On period"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOff
    "Connector for a signal of the length for the Off period"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput rho
    "Connector for a real signal of the half period ratio"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triggerStart
    "Connector for a boolean signal, true if the tuning starts"
    annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={
            {100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triggerEnd
    "Connector for a boolean signal, true if the tuning completes"
    annotation (Placement(
        transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent=
           {{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Min tmin
    "The minimum value of tOn and tOff"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gretOntOff
    "Check if tOn*tOff*min(tOn*tOff) is larger than 0"
    annotation (Placement(transformation(extent={{0,40},{20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLen(final k=0)
    "Minimum value for the horizon length"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler tOnSample(y_start=Buildings.Controls.OBC.CDL.Constants.eps)
    "Sampling tOn when the tuning period ends"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler tOffSample(y_start=Buildings.Controls.OBC.CDL.Constants.eps)
    "Sampling tOff when the tuning period ends"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samAddtOntOff
    "Sampling the tmin when tmin is larger than 0"
    annotation (Placement(transformation(extent={{40,40},{60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater tIncrease
    "Checking if either tOn or tOff increases after they both becomes positive"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Min mintOntOff
    "The smaller one between tOn and tOff"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Max maxtOntOff
    "The larger one between tOn and tOff"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide halfPeriodRatioCal
    "Calculating the half period ratio"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add AddtOntOff
     "The sum of tOn and tOff"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Detects if the tOn or tOff changes after both of them are larger than 0"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gretmaxtOntOff
    "Check if either tOn or tOff is larger than 0"
    annotation (Placement(transformation(extent={{0,10},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Less tDecrease
    "Checking if either tOn or tOff decreases after they both becomes positive"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or tChanges
    "Checks if tOn or tOff changes"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
equation
  connect(tmin.u1, tOn) annotation (Line(points={{-82,36},{-94,36},{-94,60},{-120,
          60}},      color={0,0,127}));
  connect(tmin.u2, tOff) annotation (Line(points={{-82,24},{-88,24},{-88,-46},{-94,
          -46},{-94,-60},{-120,-60}},
                    color={0,0,127}));
  connect(minLen.y, gretOntOff.u2) annotation (Line(points={{-18,30},{-10,30},{
          -10,38},{-2,38}}, color={0,0,127}));
  connect(tOnSample.u, tOn)
    annotation (Line(points={{-82,70},{-94,70},{-94,60},{-120,60}},
                                                 color={0,0,127}));
  connect(tOffSample.u, tOff) annotation (Line(points={{-82,-70},{-92,-70},{-92,
          -60},{-120,-60}},
                       color={0,0,127}));
  connect(tOnSample.trigger, tOffSample.trigger) annotation (Line(points={{-70,58},
          {-70,46},{-90,46},{-90,-52},{-70,-52},{-70,-58}},
                                                         color={255,0,255}));
  connect(samAddtOntOff.y, tIncrease.u2) annotation (Line(points={{62,30},{64,
          30},{64,-48},{28,-48},{28,-38},{38,-38}}, color={0,0,127}));
  connect(gretOntOff.y, samAddtOntOff.trigger) annotation (Line(points={{22,30},
          {24,30},{24,46},{50,46},{50,42}}, color={255,0,255}));
  connect(tOnSample.y, maxtOntOff.u1) annotation (Line(points={{-58,70},{-30,70},
          {-30,76},{-22,76}},
                           color={0,0,127}));
  connect(maxtOntOff.u2, tOffSample.y) annotation (Line(points={{-22,64},{-46,64},
          {-46,-70},{-58,-70}},
                              color={0,0,127}));
  connect(mintOntOff.u2, tOffSample.y) annotation (Line(points={{-22,-76},{-46,-76},
          {-46,-70},{-58,-70}},
                              color={0,0,127}));
  connect(mintOntOff.u1, maxtOntOff.u1) annotation (Line(points={{-22,-64},{-54,
          -64},{-54,70},{-30,70},{-30,76},{-22,76}},
                            color={0,0,127}));
  connect(maxtOntOff.y, halfPeriodRatioCal.u1) annotation (Line(points={{2,70},{
          52,70},{52,76},{58,76}},                color={0,0,127}));
  connect(halfPeriodRatioCal.u2, mintOntOff.y) annotation (Line(points={{58,64},
          {32,64},{32,-34},{24,-34},{24,-70},{2,-70}},  color={0,0,127}));
  connect(halfPeriodRatioCal.y, rho) annotation (Line(points={{82,70},{94,70},{94,
          60},{110,60}}, color={0,0,127}));
  connect(triggerEnd, tOffSample.trigger) annotation (Line(points={{110,-60},{26,
          -60},{26,-52},{-70,-52},{-70,-58}}, color={255,0,255}));
  connect(AddtOntOff.u2, tOff) annotation (Line(points={{-82,-36},{-94,-36},{-94,
          -60},{-120,-60}}, color={0,0,127}));
  connect(samAddtOntOff.u, tIncrease.u1) annotation (Line(points={{38,30},{28,
          30},{28,-30},{38,-30}}, color={0,0,127}));
  connect(tmin.y, mul.u1) annotation (Line(points={{-58,30},{-52,30},{-52,-24},{
          -42,-24}},            color={0,0,127}));
  connect(AddtOntOff.u1, tOn) annotation (Line(points={{-82,-24},{-94,-24},{-94,
          60},{-120,60}},                   color={0,0,127}));
  connect(AddtOntOff.y, mul.u2) annotation (Line(points={{-58,-30},{-50,-30},{-50,
          -36},{-42,-36}},                     color={0,0,127}));
  connect(mul.y, gretOntOff.u1) annotation (Line(points={{-18,-30},{-8,-30},{-8,
          30},{-2,30}}, color={0,0,127}));
  connect(mul.y, tIncrease.u1)
    annotation (Line(points={{-18,-30},{38,-30}}, color={0,0,127}));
  connect(gretmaxtOntOff.y, triggerStart)
    annotation (Line(points={{22,0},{110,0}}, color={255,0,255}));
  connect(gretmaxtOntOff.u2, gretOntOff.u2) annotation (Line(points={{-2,8},{
          -16,8},{-16,30},{-10,30},{-10,38},{-2,38}}, color={0,0,127}));
  connect(gretmaxtOntOff.u1, mul.u2) annotation (Line(points={{-2,0},{-50,0},{
          -50,-36},{-42,-36}}, color={0,0,127}));
  connect(tDecrease.u1, tIncrease.u1) annotation (Line(points={{38,-80},{34,-80},
          {34,-30},{38,-30}}, color={0,0,127}));
  connect(tDecrease.u2, tIncrease.u2) annotation (Line(points={{38,-88},{28,-88},
          {28,-38},{38,-38}}, color={0,0,127}));
  connect(tChanges.u1, tIncrease.y)
    annotation (Line(points={{68,-30},{62,-30}}, color={255,0,255}));
  connect(tChanges.u2, tDecrease.y)
    annotation (Line(points={{68,-38},{68,-80},{62,-80}}, color={255,0,255}));
  connect(tChanges.y, tOffSample.trigger) annotation (Line(points={{92,-30},{92,
          -60},{26,-60},{26,-52},{-70,-52},{-70,-58}}, color={255,0,255}));
  annotation (
        Diagram(
           coordinateSystem(
           extent={{-100,-100},{100,100}})),
        defaultComponentName = "halfPeriodRatio",
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{80,
            100}}),                                      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-154,148},{146,108}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>This block calculates the half-period ratio of the output from a relay controller.</p>
<h4>Main equations</h4>
<p align=\"center\" style=\"font-style:italic;\">
&rho; = max(t<sub>on</sub>,t<sub>off</sub>)/ min(t<sub>on</sub>,t<sub>off</sub>),
</p>
<p>where <i>t<sub>on</i></sub> and <i>t<sub>on</i></sub> are the length of the On period and the Off period, respectively.</p>
<p>During an On period, the relay switch signal becomes True;</p>
<p>During an Off period,  the relay switch signal becomes False.</p>
<p>Note that only the first On period and the first Off period are considered.</p>
<h4>References</h4>
<p>Josefin Berner (2017). &quot;Automatic Controller Tuning using Relay-based Model Identification.&quot; Department of Automatic Control, Lund Institute of Technology, Lund University. </p>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{240,100}})));
end HalfPeriodRatio;
