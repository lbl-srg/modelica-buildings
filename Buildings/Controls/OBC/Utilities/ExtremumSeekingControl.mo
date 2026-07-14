within Buildings.Controls.OBC.Utilities;
block ExtremumSeekingControl
  "Block to implement extremum seeking control (ESC) logic"
  parameter Boolean have_hol=false
    "Set to true to allow holding the ESC output, false to continuously update when enabled"
    annotation(Dialog(group="General settings"), Evaluate=true);
  parameter Real iniSet(
    final unit="1",
    displayUnit="1")
    "Initial setpoint"
    annotation(Dialog(group="General settings"));
  parameter Real minSet(
    final unit="1",
    displayUnit="1")
    "Minimum setpoint"
    annotation(Dialog(group="General settings"));
  parameter Real maxSet(
    final unit="1",
    displayUnit="1")
    "Maximum setpoint"
    annotation(Dialog(group="General settings"));
  parameter Real delTim(
    min=100*1E-15,
    final unit="s")
    "Delay time between device being proven on and ESC start"
    annotation(Dialog(group="General settings"));
  parameter Real samplePeriod(
    min=1E-3,
    final unit="s")
    "Sample period of algorithm"
    annotation(Dialog(group="General settings"));
  parameter Real adjFac(
    final unit="1",
    displayUnit="1")
    "Step-change divisor"
    annotation(Dialog(group="General settings"));
  final parameter Real a=Modelica.Math.exp(-samplePeriod/tauFil)
    "Time-based filter for cost factor gradient";
  final parameter Real K=samplePeriod*(maxSet-minSet)/(adjFac*(tau+tauFil))
    "Integrator gain";
  parameter Real tau(
    final unit="s",
    displayUnit="s",
    final quantity="Time")
    "Time-constant of device"
    annotation(Dialog(group="Time constants"));
  parameter Real tauFil(
    final unit="s",
    displayUnit="s",
    final quantity="Time")
    "Time-constant of cost factor gradient filter"
    annotation(Dialog(group="Time constants"));
  parameter Real dtHol(
    min=0,
    start=0,
    final unit="s",
    displayUnit="s",
    final quantity="Time")=0
    "Minimum hold time"
    annotation(Dialog(group="General settings",enable=have_hol));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta
    "On/Off status of the associated device"
    annotation (Placement(transformation(extent={{-260,190},{-220,230}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHol if have_hol
    "Hold signal"
    annotation (Placement(transformation(extent={{-260,0},{-220,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCos(
    final unit="1",
    displayUnit="1")
    "Cost-function value input"
    annotation (Placement(transformation(extent={{-260,-140},{-220,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1",
    displayUnit="1")
    "Setpoint"
    annotation (Placement(transformation(extent={{220,190},{260,230}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay tim(
    final delayTime=delTim + samplePeriod,
    final delayOnInit=true)
    "Send an on signal after some delay time"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between initial setpoint and reset setpoint"
    annotation (Placement(transformation(extent={{160,220},{180,200}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Reinitialize setpoint to initial setting when device becomes OFF"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sampler(
    final samplePeriod=samplePeriod)
    "Sample the current value of the cost function at regular intervals"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay                        uniDel(final samplePeriod=
        samplePeriod, final y_start=iniSet)
    "Output the setpoint signal with a unit delay"
    annotation (Placement(transformation(extent={{-80,54},{-60,74}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay                        uniDel1(final samplePeriod=
        samplePeriod, final y_start=0)
    "Apply a time delay to the cost function"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=1/samplePeriod)
    "Divide by the sample period duration to get the derivative"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Check the change in cost function between the previous and current time instants"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay                        uniDel2(final samplePeriod=
        samplePeriod, final y_start=0)
    "Apply a time period delay on the derivative"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(k=a)
    "Multiply the cost function derivative by the filter value"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Add the current cost function value differential to the derivative from the previous instant"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(h=1e-3)
    "Check if the adjusted cost function differential is greater than zero"
    annotation (Placement(transformation(extent={{80,-160},{100,-140}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler                        sampler1(final samplePeriod=
        samplePeriod)
    "Sample the cost function at the previous discrete instant"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Start the timer when device is proven on and reset it when search direction is flipped"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Generate false signal when the search direction is flipped"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Feedback delay for search direction flip signal"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(t=tau + tauFil)
    "Check if minimum time between search direction flips has elapsed"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Trigger the search direction flip when both the cost function differential condition and minimum time condition are satisfied"
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Toggle tog
    "Switch the optimal setpoint search direction each time the conditions are satisfied"
    annotation (Placement(transformation(extent={{-160,-210},{-140,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(k=false) "Constant false Boolean signal"
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=-1, realFalse=1)
    "Convert the Boolean search direction into a Real value; The integer signs are based on the toggle behavior, which initially outputs False"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(k=K)
    "Multiply the search direction by the constant step-change value"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1 "Add the step-change to the output at previous instant"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-200}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant iniSetCon(final k=iniSet)
    "Initial setpoint"
    annotation (Placement(transformation(extent={{-90,220},{-70,240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxSetCon(final k=maxSet)
    "Maximum setpoint constant"
    annotation (Placement(transformation(extent={{-28,100},{-8,120}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Reset setpoint should not be higher than the maximum setpoint"
    annotation (Placement(transformation(extent={{12,130},{32,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Return true when device is off"
    annotation (Placement(transformation(extent={{-90,170},{-70,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minSetCon(k=minSet)
    "Minimum setpoint constant"
    annotation (Placement(transformation(extent={{12,100},{32,120}})));
  Buildings.Controls.OBC.CDL.Reals.Max maxInp
    "Reset setpoint should not be lower than the minimum setpoint"
    annotation (Placement(transformation(extent={{52,130},{72,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(final k=false) if not
    have_hol "Constant – Placeholder value if there is no hold signal"
    annotation (Placement(transformation(extent={{-210,50},{-190,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiHol
    "Switch to zero reset until hold is released and sampler clock ticks"
    annotation (Placement(transformation(extent={{-48,32},{-28,52}})));
  Buildings.Controls.OBC.CDL.Logical.Not notHol "Return true if hold is released"
    annotation (Placement(transformation(extent={{-170,50},{-150,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "True when hold is active and sampler clock ticks: enables applying the last calculated reset before freezing output"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol(
    final trueHoldDuration=dtHol,
    final falseHoldDuration=0) if have_hol
    "Hold true for the longer of dtHol and the time uHol remains true"
    annotation (Placement(transformation(extent={{-210,10},{-190,30}})));
  Buildings.Controls.OBC.CDL.Logical.And notHolAndTic
    "Return true if hold is released and sampler clock ticks"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(
    final period=samplePeriod,
    final shift=0)
    "Generate signal matching the request sampling frequency"
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));
equation
  connect(iniSetCon.y, swi.u3)
    annotation (Line(points={{-68,230},{80,230},{80,218},{158,218}},
      color={0,0,127}));
  connect(maxSetCon.y, min1.u2)
    annotation (Line(points={{-6,110},{6,110},{6,134},{10,134}},
      color={0,0,127}));
  connect(iniSetCon.y, swi2.u1)
    annotation (Line(points={{-68,230},{80,230},{80,188},{98,188}},
      color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{122,180},{140,180},{140,202},{158,202}},
      color={0,0,127}));
  connect(uDevSta, not1.u)
    annotation (Line(points={{-240,210},{-210,210},{-210,180},{-92,180}},
      color={255,0,255}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{-68,180},{98,180}},
      color={255,0,255}));
  connect(min1.y, maxInp.u1)
    annotation (Line(points={{34,140},{42,140},{42,146},{50,146}},
      color={0,0,127}));
  connect(minSetCon.y, maxInp.u2)
    annotation (Line(points={{34,110},{42,110},{42,134},{50,134}},
      color={0,0,127}));
  connect(uDevSta, tim.u)
    annotation (Line(points={{-240,210},{-202,210}}, color={255,0,255}));
  connect(tim.y, swi.u2)
    annotation (Line(points={{-178,210},{158,210}}, color={255,0,255}));
  connect(maxInp.y, swi2.u3)
    annotation (Line(points={{74,140},{80,140},{80,172},{98,172}}, color={0,0,127}));

  connect(fal.y, notHol.u) annotation (Line(points={{-188,60},{-172,60}},
                          color={255,0,255}));
  connect(lat.y, swiHol.u2) annotation (Line(points={{-68,20},{-60,20},{-60,42},
          {-50,42}}, color={255,0,255}));
  connect(uHol, truHol.u)
    annotation (Line(points={{-240,20},{-212,20}}, color={255,0,255}));
  connect(truHol.y, notHol.u) annotation (Line(points={{-188,20},{-180,20},{
          -180,60},{-172,60}}, color={255,0,255}));
  connect(notHol.y, notHolAndTic.u1)
    annotation (Line(points={{-148,60},{-140,60},{-140,40},{-132,40}},
                                                   color={255,0,255}));
  connect(notHolAndTic.y, lat.clr) annotation (Line(points={{-108,40},{-100,40},
          {-100,14},{-92,14}}, color={255,0,255}));
  connect(samTri.y, lat.u)
    annotation (Line(points={{-148,20},{-92,20}}, color={255,0,255}));
  connect(samTri.y, notHolAndTic.u2) annotation (Line(points={{-148,20},{-140,
          20},{-140,32},{-132,32}}, color={255,0,255}));
  connect(swiHol.y, min1.u1) annotation (Line(points={{-26,42},{-12,42},{-12,82},
          {-42,82},{-42,146},{10,146}}, color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{182,210},{240,210}}, color={0,0,127}));
  connect(uniDel.y, swiHol.u1)
    annotation (Line(points={{-58,64},{-50,64},{-50,50}}, color={0,0,127}));
  connect(swi.y, uniDel.u) annotation (Line(points={{182,210},{198,210},{198,252},
          {-102,252},{-102,64},{-82,64}}, color={0,0,127}));
  connect(uCos, sampler.u)
    annotation (Line(points={{-240,-120},{-202,-120}}, color={0,0,127}));
  connect(sub.y, gai.u)
    annotation (Line(points={{-98,-140},{-82,-140}}, color={0,0,127}));
  connect(sampler.y, sub.u1) annotation (Line(points={{-178,-120},{-130,-120},{-130,
          -134},{-122,-134}}, color={0,0,127}));
  connect(gai.y, uniDel2.u)
    annotation (Line(points={{-58,-140},{-42,-140}}, color={0,0,127}));
  connect(uniDel2.y, gai1.u)
    annotation (Line(points={{-18,-140},{-2,-140}}, color={0,0,127}));
  connect(gai1.y, add2.u1) annotation (Line(points={{22,-140},{30,-140},{30,-144},
          {38,-144}}, color={0,0,127}));
  connect(sub.y, add2.u2) annotation (Line(points={{-98,-140},{-90,-140},{-90,-160},
          {30,-160},{30,-156},{38,-156}}, color={0,0,127}));
  connect(add2.y, greThr.u)
    annotation (Line(points={{62,-150},{78,-150}}, color={0,0,127}));
  connect(uniDel1.y, sampler1.u)
    annotation (Line(points={{-178,-160},{-162,-160}}, color={0,0,127}));
  connect(uCos, uniDel1.u) annotation (Line(points={{-240,-120},{-210,-120},{-210,
          -160},{-202,-160}}, color={0,0,127}));
  connect(sampler1.y, sub.u2) annotation (Line(points={{-138,-160},{-130,-160},{
          -130,-146},{-122,-146}}, color={0,0,127}));
  connect(tim.y, and2.u1) annotation (Line(points={{-178,210},{-96,210},{-96,-40},
          {-82,-40}}, color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{-118,-40},{-100,-40},{-100,
          -48},{-82,-48}}, color={255,0,255}));
  connect(pre1.y, not2.u)
    annotation (Line(points={{-158,-40},{-142,-40}}, color={255,0,255}));
  connect(and2.y, tim1.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));
  connect(greThr.y, and1.u2) annotation (Line(points={{102,-150},{110,-150},{110,
          -158},{118,-158}}, color={255,0,255}));
  connect(tim1.passed, and1.u1) annotation (Line(points={{-18,-48},{114,-48},{114,
          -150},{118,-150}}, color={255,0,255}));
  connect(and1.y, pre1.u) annotation (Line(points={{142,-150},{150,-150},{150,-20},
          {-190,-20},{-190,-40},{-182,-40}}, color={255,0,255}));
  connect(and1.y, tog.u) annotation (Line(points={{142,-150},{150,-150},{150,-180},
          {-170,-180},{-170,-200},{-162,-200}}, color={255,0,255}));
  connect(con1.y, tog.clr) annotation (Line(points={{-178,-210},{-170,-210},{-170,
          -206},{-162,-206}}, color={255,0,255}));
  connect(tog.y, booToRea.u)
    annotation (Line(points={{-138,-200},{-122,-200}}, color={255,0,255}));
  connect(booToRea.y, gai2.u)
    annotation (Line(points={{-98,-200},{-82,-200}}, color={0,0,127}));
  connect(gai2.y, add1.u1) annotation (Line(points={{-58,-200},{-50,-200},{-50,-204},
          {-42,-204}}, color={0,0,127}));
  connect(add1.y, swiHol.u3) annotation (Line(points={{-18,-210},{168,-210},{168,
          8},{-54,8},{-54,34},{-50,34}}, color={0,0,127}));
  connect(uniDel.y, add1.u2) annotation (Line(points={{-58,64},{198,64},{198,-240},
          {-50,-240},{-50,-216},{-42,-216}}, color={0,0,127}));
annotation (
  defaultComponentName = "esc",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={223,211,169},
        lineThickness=5.0,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-114,146},{106,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-88,58},{90,-42}},
          textColor={192,192,192},
        textString="ESC")}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-260},{220,
            260}}),
           graphics={
        Rectangle(
          extent={{-218,258},{218,82}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-214,260},{-118,230}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Check device status,
Count time"),
        Rectangle(
          extent={{-218,80},{218,2}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{22,68},{174,20}},
          textColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Optional hold of the loop output")}),
   Documentation(info="<html>
<p>
This block implements an extremum seeking control (ESC) algorithm
that automatically drives a setpoint towards the value that optimises
a user-supplied cost function.
</p>
<h4>Algorithm</h4>
<p>
The block operates in discrete time with a fixed sample period
<code>samplePeriod</code>.
At each sample instant, the cost function value <code>uCos</code> is
sampled and an approximate gradient is computed using a first-order
exponential filter with time constant <code>tauFil</code>:
</p>
<p align=\"center\" style=\"font-style:italic;\">
g<sub>k</sub> = a &middot; g<sub>k-1</sub>
+ (uCos<sub>k</sub> &minus; uCos<sub>k-1</sub>) / samplePeriod,
</p>
<p>
where
</p>
<p align=\"center\" style=\"font-style:italic;\">
a = exp(-samplePeriod / tauFil)
</p>
<p>
is the filter coefficient.
When the filtered gradient exceeds zero, the search direction is reversed.
To prevent rapid oscillation, a direction reversal cannot occur until a
minimum inter-flip time of <i>tau + tauFil</i> seconds has elapsed since
the last reversal.
</p>
<p>
The setpoint is incremented at each step by
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Delta;y = K &middot; d,
</p>
<p>
where <i>d &isin; {-1, +1}</i> is the current search direction and
</p>
<p align=\"center\" style=\"font-style:italic;\">
K = samplePeriod &middot; (maxSet &minus; minSet)
/ (adjFac &middot; (tau + tauFil))
</p>
<p>
is the step size. The output is clamped to
[<code>minSet</code>, <code>maxSet</code>].
</p>
<p>
The algorithm activates <code>delTim</code> seconds after the associated
device switches on (<code>uDevSta = true</code>).
While the device is off, the setpoint is held at <code>iniSet</code>.
</p>
<h4>Options</h4>
<p>
If <code>have_hol = true</code>, an optional Boolean input <code>uHol</code>
allows the ESC loop output to be frozen at its current value for the longer
of the duration that <code>uHol</code> remains true and the minimum hold
time <code>dtHol</code>.
When <code>uHol</code> switches back to false, the algorithm resumes from
the held value without reinitialising to <code>iniSet</code> or waiting for
<code>delTim</code>.
</p>
<p>
This is typically used in control sequences to freeze the setpoint during
the plant staging process.
Consider for example the following specification:<br/>
\"When a plant stage change is initiated, the ESC output shall be held at
its last value for the longer of <i>15</i> minutes and the time it takes
for the plant to successfully stage.\"<br/>
Using this block with <code>have_hol=true</code> and <code>dtHol=15*60</code>
yields the following sequence of events.
</p>
<ul>
<li>0:00 - Stage change is initiated. ESC output is at <i>50&nbsp;%</i>.</li>
<li>0:12 - Stage change is completed. ESC output remains at <i>50&nbsp;%</i>
since <i>&lt;&nbsp;15&nbsp;</i>minutes have elapsed.</li>
<li>0:15 - ESC resumes and continues from <i>50&nbsp;%</i>.</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 13, 2026, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExtremumSeekingControl;
