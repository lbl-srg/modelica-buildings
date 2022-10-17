within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block HalfPeriodRatio
  "Calculate the half period ratio of a response from a relay controller"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn
    "Length for the On period"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOff
    "Length for the Off period"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput rho
    "Real signal of the half period ratio"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triSta
    "A boolean signal, true if the tuning starts" annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent=
            {{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triEnd
    "A boolean signal, true if the tuning completes" annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent=
           {{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Min tmin
    "Minimum value of the length for the On period and the length for the off period "
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gretOntOff
    "Check if both the length for the On period and the length for the off period are larger than 0"
    annotation (Placement(transformation(extent={{0,40},{20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLen(
     final k=0)
    "Minimum value for the horizon length"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler tOnSample(
    final y_start=Buildings.Controls.OBC.CDL.Constants.eps)
    "Sample tOn when the tuning period ends"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler tOffSample(
    final y_start=Buildings.Controls.OBC.CDL.Constants.eps)
    "Sample tOff when the tuning period ends"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samAddtOntOff
    "Sample the tmin when tmin is larger than 0"
    annotation (Placement(transformation(extent={{40,40},{60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater tIncrease
    "Check if either the length for the On period or the length for the off period increases after they both becomes positive"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Min mintOntOff
    "Find the smaller one between the length for the On period and the length for the off period"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Max maxtOntOff
    "Find the larger one between the length for the On period and the length for the off period"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide halPerRat
    "Calculate the half period ratio"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add AddtOntOff
    "Calculate the sum of the length for the On period and the length for the off period"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Detect if the the length for the On period or the length for the off period changes after both of them are larger than 0"
    annotation (Placement(transformation(extent={{-34,-40},{-14,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gretmaxtOntOff
    "Check if either the length for the On period or the length for the off period is larger than 0"
    annotation (Placement(transformation(extent={{0,10},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Less tDecrease
    "Check if either the length for the On period or the length for the off period decreases after they both becomes positive"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or tChanges
    "Check if the length for the On period or the length for the off period changes"
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
  connect(maxtOntOff.y, halPerRat.u1) annotation (Line(points={{2,70},{52,70},{52,
          76},{58,76}}, color={0,0,127}));
  connect(halPerRat.u2, mintOntOff.y) annotation (Line(points={{58,64},{32,64},{
          32,-34},{24,-34},{24,-70},{2,-70}}, color={0,0,127}));
  connect(halPerRat.y, rho) annotation (Line(points={{82,70},{94,70},{94,60},{120,
          60}}, color={0,0,127}));
  connect(triEnd, tOffSample.trigger) annotation (Line(points={{120,-60},{26,-60},
          {26,-52},{-70,-52},{-70,-58}}, color={255,0,255}));
  connect(AddtOntOff.u2, tOff) annotation (Line(points={{-82,-36},{-94,-36},{-94,
          -60},{-120,-60}}, color={0,0,127}));
  connect(AddtOntOff.u1, tOn) annotation (Line(points={{-82,-24},{-94,-24},{-94,
          60},{-120,60}},                   color={0,0,127}));
  connect(gretmaxtOntOff.y, triSta)
    annotation (Line(points={{22,0},{120,0}}, color={255,0,255}));
  connect(tChanges.u1, tIncrease.y)
    annotation (Line(points={{68,-30},{62,-30}}, color={255,0,255}));
  connect(tChanges.u2, tDecrease.y)
    annotation (Line(points={{68,-38},{68,-80},{62,-80}}, color={255,0,255}));
  connect(tChanges.y, tOffSample.trigger) annotation (Line(points={{92,-30},{92,
          -60},{26,-60},{26,-52},{-70,-52},{-70,-58}}, color={255,0,255}));
  connect(samAddtOntOff.y, tDecrease.u2) annotation (Line(points={{62,30},{76,30},
          {76,-6},{30,-6},{30,-88},{38,-88}}, color={0,0,127}));
  connect(gretmaxtOntOff.u1, AddtOntOff.y) annotation (Line(points={{-2,0},{-44,
          0},{-44,-30},{-58,-30}}, color={0,0,127}));
  connect(tOnSample.trigger, triEnd) annotation (Line(points={{-70,58},{-70,46},
          {-84,46},{-84,-52},{86,-52},{86,-60},{120,-60}}, color={255,0,255}));
  connect(gretmaxtOntOff.u2, minLen.y) annotation (Line(points={{-2,8},{-14,8},{
          -14,30},{-18,30}}, color={0,0,127}));
  connect(gretOntOff.u1, tmin.y) annotation (Line(points={{-2,30},{-6,30},{-6,12},
          {-44,12},{-44,30},{-58,30}}, color={0,0,127}));
  connect(mul.u1, tmin.y) annotation (Line(points={{-36,-24},{-36,6},{-48,6},{
          -48,30},{-58,30}}, color={0,0,127}));
  connect(mul.u2, AddtOntOff.y) annotation (Line(points={{-36,-36},{-40,-36},{
          -40,-30},{-58,-30}}, color={0,0,127}));
  connect(mul.y, tIncrease.u1)
    annotation (Line(points={{-12,-30},{38,-30}}, color={0,0,127}));
  connect(tDecrease.u1, mul.y) annotation (Line(points={{38,-80},{10,-80},{10,
          -30},{-12,-30}}, color={0,0,127}));
  connect(samAddtOntOff.u, mul.y) annotation (Line(points={{38,30},{36,30},{36,
          -24},{-4,-24},{-4,-30},{-12,-30}}, color={0,0,127}));
  annotation (
        Diagram(
           coordinateSystem(
           extent={{-100,-100},{100,100}})),
        defaultComponentName = "halPerRat",
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
<p>where <i>t<sub>on</sub></i> and <i>t<sub>off</sub></i> are the length of the On period and the Off period, respectively.</p>
<p>During an On period, the relay switch signal becomes True;</p>
<p>During an Off period,  the relay switch signal becomes False.</p>
<p>Note that only the first On period and the first Off period are considered.</p>
<h4>Algorithm</h4>
<p>
The algorithm for calculating <i>&rho;</i> is as follows:
</p>
<h5>Step 1: detects when the tuning period begins.</h5>
<p>The tuning period is considered to begin when either <i>t<sub>on</sub></i> or <i>t<sub>off</sub></i> are larger than 0.
In this implementation, we detect the beginning time by monitoring the sum of <i>t<sub>on</sub></i> and <i>t<sub>off</sub></i>.</p>

<h5>Step 2: detects when both <i>t<sub>on</sub></i> and <i>t<sub>off</sub></i> are larger than 0.</h5>
<p>
We then record the value of the minimum value between <i>(t<sub>on</sub>+t<sub>off</sub>)*min(t<sub>on</sub>,t<sub>off</sub>)</i> when both <i>t<sub>on</sub></i> and <i>t<sub>off</sub></i> are larger than 0.
</p>

<h5>Step 3: detects when the tuning period ends.</h5>
<p>
The tuning period is considered to end when either <i>t<sub>on</sub></i> or <i>t<sub>off</sub></i> changes after they become positive.
In this implementation, we detect the end time by checking if the value of <i>(t<sub>on</sub>+t<sub>off</sub>)*min(t<sub>on</sub>,t<sub>off</sub>)</i> is different from the output of step2.
</p>

<h4>References</h4>
<p>Josefin Berner (2017)
\"Automatic Controller Tuning using Relay-based Model Identification.\"
Department of Automatic Control, Lund Institute of Technology, Lund University. </p>
</html>"));
end HalfPeriodRatio;
