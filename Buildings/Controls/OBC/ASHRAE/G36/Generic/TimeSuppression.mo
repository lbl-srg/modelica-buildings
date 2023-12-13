within Buildings.Controls.OBC.ASHRAE.G36.Generic;
block TimeSuppression
  "Calculate a time-delay period after change in set point"

  parameter Real chaRat(final unit="s/K")=540
    "Gain factor to calculate suppression time based on the change of the setpoint, seconds per Kelvin. For cooling or heating request, it should be 540 seconds, for temperature alarms, it should be 1080 seconds"
    annotation (__cdl(ValueInReference=true));
  parameter Real maxTim(
    final unit="s",
    final quantity="Time")=1800
    "Maximum suppression time. For cooling or heating request, it should be 1800 seconds, for temperature alarms, it should be 7200 seconds"
    annotation (__cdl(ValueInReference=true));
  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time")=120
    "Sample period of component, set to the same value as the trim and respond that process static pressure reset"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Near zero temperature difference, below which the difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Setpoint temperature"
    annotation (Placement(transformation(extent={{-220,150},{-180,190}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAftSup
    "True when there is no setpoint change, or suppression time has passed after setpoint change"
    annotation (Placement(transformation(extent={{180,-120},{220,-80}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Min supTim
    "Calculated suppression time due to the setpoint change"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
protected
  Buildings.Controls.OBC.CDL.Discrete.Sampler samSet(
    final samplePeriod=samplePeriod)
    "Sample current setpoint"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=samplePeriod)
    "Delay value to record input value"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    "Absolute change of the setpoint temperature"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "New setpoint temperature"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Instants when input becomes true"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Output true when there is setpoint change and maintain the true output until the suppresiong time has passed"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Output true when the suppression time has passed"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Time when the setpoint is being changed"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if there is setpoint change"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=chaRat)
    "Setpoint change rate"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Calculate difference of previous and current setpoints"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxSupTim(
    final k=maxTim) "Maximum suppression time "
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5(
    final k=true)
    "Constant true"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Use setpoint different value when sample period time has passed"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(
    final duration=samplePeriod)
    "Hold true signal for sample period of time"
    annotation (Placement(transformation(extent={{80,-160},{100,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch pasSupTim
    "Check if suppression time has passed"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Greater pasSup
    "Check if the change has been suppressed by sufficient time"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract temDif
    "Difference between setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    "Zone temperature at the moment when there is setpoint change"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2
    "Absolute temperature difference"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=samplePeriod,
    final delayOnInit=true)
    "Ignore the first sampling period"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true) "Constant true"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

equation
  connect(TSet, samSet.u)
    annotation (Line(points={{-200,170},{-142,170}}, color={0,0,127}));
  connect(samSet.y, uniDel.u)
    annotation (Line(points={{-118,170},{-82,170}}, color={0,0,127}));
  connect(greThr.y, lat.u)
    annotation (Line(points={{-98,-150},{-82,-150}}, color={255,0,255}));
  connect(lat.y,tim. u)
    annotation (Line(points={{-58,-150},{-42,-150}}, color={255,0,255}));
  connect(lat.y,edg. u)
    annotation (Line(points={{-58,-150},{-50,-150},{-50,-120},{-42,-120}},
      color={255,0,255}));
  connect(edg.y,lat1. clr)
    annotation (Line(points={{-18,-120},{40,-120},{40,-86},{78,-86}},
      color={255,0,255}));
  connect(sub1.y,swi. u1)
    annotation (Line(points={{2,140},{20,140},{20,118},{38,118}},
      color={0,0,127}));
  connect(conZer.y,swi. u3)
    annotation (Line(points={{2,80},{20,80},{20,102},{38,102}}, color={0,0,127}));
  connect(swi.y, abs1.u)
    annotation (Line(points={{62,110},{98,110}}, color={0,0,127}));
  connect(abs1.y, greThr.u) annotation (Line(points={{122,110},{140,110},{140,60},
          {-140,60},{-140,-150},{-122,-150}}, color={0,0,127}));
  connect(truHol.y,lat. clr)
    annotation (Line(points={{102,-150},{110,-150},{110,-170},{-90,-170},{-90,-156},
          {-82,-156}}, color={255,0,255}));
  connect(gai.y,supTim. u1)
    annotation (Line(points={{42,30},{60,30},{60,16},{78,16}}, color={0,0,127}));
  connect(maxSupTim.y,supTim. u2)
    annotation (Line(points={{42,-10},{60,-10},{60,4},{78,4}}, color={0,0,127}));
  connect(lat.y, pasSupTim.u2) annotation (Line(points={{-58,-150},{-50,-150},{-50,
          -100},{138,-100}}, color={255,0,255}));
  connect(lat1.y, pasSupTim.u1) annotation (Line(points={{102,-80},{120,-80},{120,
          -92},{138,-92}}, color={255,0,255}));
  connect(con5.y, pasSupTim.u3) annotation (Line(points={{102,-120},{120,-120},{
          120,-108},{138,-108}}, color={255,0,255}));
  connect(tim.y, pasSup.u1)
    annotation (Line(points={{-18,-150},{18,-150}}, color={0,0,127}));
  connect(pasSup.y, lat1.u) annotation (Line(points={{42,-150},{60,-150},{60,-80},
          {78,-80}}, color={255,0,255}));
  connect(pasSup.y, truHol.u)
    annotation (Line(points={{42,-150},{78,-150}}, color={255,0,255}));
  connect(pasSupTim.y, yAftSup)
    annotation (Line(points={{162,-100},{200,-100}}, color={255,0,255}));
  connect(TSet, triSam.u) annotation (Line(points={{-200,170},{-160,170},{-160,30},
          {-122,30}}, color={0,0,127}));
  connect(TZon, triSam1.u)
    annotation (Line(points={{-200,-20},{-122,-20}}, color={0,0,127}));
  connect(triSam.y, temDif.u1)
    annotation (Line(points={{-98,30},{-80,30},{-80,36},{-62,36}}, color={0,0,127}));
  connect(edg.y, triSam1.trigger) annotation (Line(points={{-18,-120},{40,-120},
          {40,-86},{-80,-86},{-80,-40},{-110,-40},{-110,-32}},   color={255,0,255}));
  connect(edg.y, triSam.trigger) annotation (Line(points={{-18,-120},{40,-120},
          {40,-86},{-80,-86},{-80,10},{-110,10},{-110,18}},  color={255,0,255}));
  connect(temDif.y, abs2.u)
    annotation (Line(points={{-38,30},{-22,30}}, color={0,0,127}));
  connect(abs2.y, gai.u)
    annotation (Line(points={{2,30},{18,30}}, color={0,0,127}));
  connect(supTim.y, pasSup.u2) annotation (Line(points={{102,10},{120,10},{120,-40},
          {0,-40},{0,-158},{18,-158}}, color={0,0,127}));
  connect(uniDel.y, sub1.u2) annotation (Line(points={{-58,170},{-40,170},{-40,134},
          {-22,134}}, color={0,0,127}));
  connect(samSet.y, sub1.u1) annotation (Line(points={{-118,170},{-100,170},{-100,
          146},{-22,146}}, color={0,0,127}));
  connect(triSam1.y, temDif.u2) annotation (Line(points={{-98,-20},{-70,-20},{-70,
          24},{-62,24}}, color={0,0,127}));
  connect(con1.y, truDel.u)
    annotation (Line(points={{-118,110},{-82,110}}, color={255,0,255}));
  connect(truDel.y, swi.u2)
    annotation (Line(points={{-58,110},{38,110}}, color={255,0,255}));
annotation (defaultComponentName="timSup",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,48},{-62,30}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSet"),
        Text(
          extent={{52,12},{96,-8}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yAftSup"),
        Text(
          extent={{-100,-30},{-62,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-180,-200},{180,200}}),
    graphics={
        Rectangle(
          extent={{-178,198},{178,62}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{74,196},{174,176}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Find change of the setpoint"),
        Rectangle(
          extent={{-180,38},{176,-38}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-178,-62},{178,-198}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{100,40},{168,22}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Suppression time"),
        Text(
          extent={{16,-174},{158,-200}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it has passed suppression time")}),
Documentation(info="<html>
<p>
This sequence checks if there is setpoint change and if the time-based suppression
has finished. The implementation is according to the Section 5.1.20 of ASHRAE
Guideline 36, May 2020. 
</p>
<p>
Calculate a time-delay period after any change in setpoint based on the difference
between the controlled variable at the time of the change and the new setpoint. The
default time delay period shall be as follows:
</p>
<ol>
<li>
For thermal zone temperature alarms: 18 minutes per &deg;C (10 minutes per &deg;F)
of difference (<code>chaRat</code>) but no longer than 120 minutes (<code>1800</code>).
</li>
<li>
For thermal zone temperature cooling requests: 9 minutes per &deg;C (5 minutes per &deg;F)
of difference (<code>chaRat</code>) but no longer than 30 minutes (<code>1800</code>).
</li>
<li>
For thermal zone temperature heating requests: 9 minutes per &deg;C (5 minutes per &deg;F)
of difference (<code>chaRat</code>) but no longer than 30 minutes (<code>1800</code>).
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
December 12, 2023, by Jianjun Hu:<br/>
Reimplemented the check of ignoring the first sampling period.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3596\">issue 3596</a>.
</li>
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TimeSuppression;
