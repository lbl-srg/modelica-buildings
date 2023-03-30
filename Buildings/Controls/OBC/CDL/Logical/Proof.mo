within Buildings.Controls.OBC.CDL.Logical;
block Proof "Verify two boolean inputs"
  parameter Real validDelay(
    final quantity="Time",
    final unit="s")
    "Time during which input must remain unchanged for signal to considered valid and used in checks";
  parameter Real checkDelay(
    final quantity="Time",
    final unit="s")
    "Delay after which the two inputs are checked for equality once they become valid";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uMea
    "Current status"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCom
    "Commanded status"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yProTru
    "True: commanded status is true and current status is false"
    annotation (Placement(transformation(extent={{160,60},{200,100}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yProFal
    "True: commanded status is false and current status is true"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay valTru(
    final delayTime=validDelay)
    "Valid change from false to true"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay valTru1(
    final delayTime=validDelay)
    "Valid change from false to true"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch valFal
    "Valid change from true to false"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch valFal1
    "Valid change from true to false"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=validDelay)
    "Delay a rising edge, to check if the false input is valid"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=validDelay)
    "Delay a rising edge, to check if the false input is valid"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And botTru
    "Check if both valid inputs are true"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not notBotTru
    "Not both true input"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not notBotFal
    "Not both false input"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And falTru
    "Check if the valid commanded status is true and the valid measured status is false"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe(
    final delayTime=max(checkDelay, validDelay))
    "Delay the difference check"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Logical.And truFal
    "Check if the valid commanded status is false and the valid measured status is true"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe1(
    final delayTime=max(checkDelay, validDelay))
    "Delay the difference check"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "False input"
    annotation (Placement(transformation(extent={{42,-100},{62,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Integers.Equal equSta
    "Check if both status are the same"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And botFal
    "Both false status"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "True constant"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "False input"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

initial equation
  assert(
    checkDelay >= validDelay,
    "In " + getInstanceName() + ": Require checkDelay >= validDelay, setting checkDelay = validDelay.",
    level=AssertionLevel.warning);

equation
  connect(uMea,valTru. u)
    annotation (Line(points={{-200,80},{-170,80},{-170,130},{-162,130}},
                                                     color={255,0,255}));
  connect(uMea, not1.u) annotation (Line(points={{-200,80},{-162,80}},
                      color={255,0,255}));
  connect(not1.y, truDel1.u)
    annotation (Line(points={{-138,80},{-122,80}}, color={255,0,255}));
  connect(uCom,valTru1. u)
    annotation (Line(points={{-200,-60},{-170,-60},{-170,-10},{-162,-10}},
                                                     color={255,0,255}));
  connect(uCom, not2.u) annotation (Line(points={{-200,-60},{-170,-60},{-170,-90},
          {-162,-90}}, color={255,0,255}));
  connect(not2.y, truDel2.u)
    annotation (Line(points={{-138,-90},{-122,-90}}, color={255,0,255}));
  connect(valTru.y, botTru.u1)
    annotation (Line(points={{-138,130},{-62,130}}, color={255,0,255}));
  connect(valTru1.y, botTru.u2) annotation (Line(points={{-138,-10},{-80,-10},{-80,
          122},{-62,122}}, color={255,0,255}));
  connect(botTru.y, notBotTru.u)
    annotation (Line(points={{-38,130},{-22,130}}, color={255,0,255}));
  connect(notBotTru.y, delChe.u)
    annotation (Line(points={{2,130},{38,130}}, color={255,0,255}));
  connect(delChe.y, falTru.u1)
    annotation (Line(points={{62,130},{98,130}}, color={255,0,255}));
  connect(valTru1.y, falTru.u2) annotation (Line(points={{-138,-10},{70,-10},{70,
          122},{98,122}}, color={255,0,255}));
  connect(falTru.y, yProTru) annotation (Line(points={{122,130},{152,130},{152,80},
          {180,80}}, color={255,0,255}));
  connect(notBotFal.y, delChe1.u)
    annotation (Line(points={{62,-60},{78,-60}}, color={255,0,255}));
  connect(delChe1.y, truFal.u1)
    annotation (Line(points={{102,-60},{118,-60}}, color={255,0,255}));
  connect(truFal.y, yProFal)
    annotation (Line(points={{142,-60},{180,-60}}, color={255,0,255}));
  connect(not5.y, truFal.u2) annotation (Line(points={{64,-90},{110,-90},{110,-68},
          {118,-68}},        color={255,0,255}));
  connect(booToInt.y, equSta.u1)
    annotation (Line(points={{2,80},{38,80}},  color={255,127,0}));
  connect(booToInt1.y, equSta.u2) annotation (Line(points={{2,-60},{10,-60},{10,
          72},{38,72}},     color={255,127,0}));
  connect(equSta.y, botFal.u1)
    annotation (Line(points={{62,80},{98,80}}, color={255,0,255}));
  connect(truDel1.y, valFal.u2)
    annotation (Line(points={{-98,80},{-62,80}}, color={255,0,255}));
  connect(uMea, valFal.u1) annotation (Line(points={{-200,80},{-170,80},{-170,100},
          {-70,100},{-70,88},{-62,88}},      color={255,0,255}));
  connect(truDel2.y, valFal1.u2)
    annotation (Line(points={{-98,-90},{-62,-90}}, color={255,0,255}));
  connect(uCom, valFal1.u1) annotation (Line(points={{-200,-60},{-80,-60},{-80,-82},
          {-62,-82}},  color={255,0,255}));
  connect(valFal1.y, booToInt1.u)
    annotation (Line(points={{-38,-90},{-30,-90},{-30,-60},{-22,-60}}, color={255,0,255}));
  connect(con.y, valFal.u3) annotation (Line(points={{-138,40},{-90,40},{-90,72},
          {-62,72}}, color={255,0,255}));
  connect(con.y, valFal1.u3) annotation (Line(points={{-138,40},{-90,40},{-90,-98},
          {-62,-98}}, color={255,0,255}));
  connect(valFal.y, booToInt.u)
    annotation (Line(points={{-38,80},{-22,80}},  color={255,0,255}));
  connect(botFal.y, notBotFal.u) annotation (Line(points={{122,80},{140,80},{140,
          -20},{20,-20},{20,-60},{38,-60}}, color={255,0,255}));
  connect(valFal1.y, not5.u) annotation (Line(points={{-38,-90},{40,-90}},
                     color={255,0,255}));
  connect(valTru1.y, not3.u) annotation (Line(points={{-138,-10},{-80,-10},{-80,
          20},{-62,20}}, color={255,0,255}));
  connect(not3.y, botFal.u2) annotation (Line(points={{-38,20},{80,20},{80,72},{
          98,72}}, color={255,0,255}));

annotation (
    defaultComponentName="pro",
    Diagram(
      coordinateSystem(extent={{-180,-120},{160,160}})),
    Icon(
      coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{-73,67},{-87,53}},
          lineColor=DynamicSelect({235,235,235}, if uMea then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if uMea then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-73,-53},{-87,-67}},
          lineColor=DynamicSelect({235,235,235}, if uCom then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if uCom then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{73,67},{87,53}},
          lineColor=DynamicSelect({235,235,235}, if yProTru then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if yProTru then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{73,-53},{87,-67}},
          lineColor=DynamicSelect({235,235,235}, if yProFal then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if yProFal then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
Documentation(info="<html>
<p>
Block that compares a boolean set point <code>u_s</code> with
a measured signal <code>u_m</code> and produces two outputs
that may be used to raise alarms about malfunctioning equipment.
</p>
<p>
The block sets the output <code>yLocTru = true</code> if
the set point is <code>u_s = true</code> but the measured signal is locked
at <code>false</code>, i.e., <code>u_m = false</code>.
Similarly, the block sets the output <code>yLocFal = true</code>
if the set point is <code>u_s = false</code> but the measured signal is locked
at <code>true</code>, i.e., <code>u_m = true</code>.
Hence, any output being <code>true</code> indicates an operational
problem.
</p>
<p>
To use this block, proceed as follows:
Set the parameter <code>feedbackDelay &ge; 0</code> to specify how long the
feedback of the controlled device is allowed to take to report
its measured operational signal <code>u_s</code>
after a set point change <code>u_m</code>.
Set the parameter <code>debounce &ge; 0</code>
to specify how long the measured
signal <code>u_m</code> need to remain constant for it to be considered
stable.
Connect the set point to <code>u_s</code> and
the measured signal to <code>u_m</code>.
If either output is <code>true</code>, raise an alarm, such as by
connecting instances of
<a href=\"modelica://Buildings.Controls.OBC.CDL.Utilities.Assert\">
Buildings.Controls.OBC.CDL.Utilities.Assert</a>
to the outputs of this block.
</p>
<p>
Any output being <code>true</code> indicates a problem.
</p>
<p>
The block has two timers that each start whenever the corresponding input changes.
One timer, called <code>feedbackDelay+debounce</code> timer, starts
whenever the set point <code>u_s</code> change, and it runs for a time equal to
<code>feedbackDelay+debounce</code>.
The other timer, called <code>debounce</code> timer, starts whenever
the measured signal <code>u_m</code> changes, and it runs for a time equal to
<code>debounce</code>.
The block starts verifying the inputs whenever the <code>feedbackDelay+debounce</code> timer
lapsed, or the <code>debounce</code> timer lapsed,
(and hence the measurement is stable,) whichever is first.
</p>
<p>
Both outputs being <code>true</code> indicates that the measured signal <code>u_m</code>
is not stable within <code>feedbackDelay+debounce</code> time.
Exactly one output being <code>true</code> indicates
that the measured signal <code>u_m</code> is stable, but
<code>u_s &ne; u_m</code>. In this case,
the block sets <code>yLocFal = true</code> if <code>u_s = true</code>
(the measured signal is locked at <code>false</code>),
or it sets <code>yLocTru = true</code> if <code>u_s = false</code>
(the measured signal is locked at <code>true</code>).
</p>
<p>
Therefore, exactly one output being <code>true</code> can be interpreted as follows:
Suppose <code>true</code> means on and <code>false</code> means off.</br>
Then, <code>yLocTru = true</code> indicates that an equipment is locked
in operation mode but is commanded off; and similarly,
<code>yLocFal = true</code> indicates that it is locked in off mode
when it is commanded on.
</p>
<h4>Detailed description</h4>
<p>
The block works as follows.
Any change in set point <code>u_s</code> starts the <code>feedbackDelay+debounce</code> timer, and
any change in measured signal <code>u_m</code> starts the <code>debounce</code> timer.
</p>
<p>
As soon as the <code>feedbackDelay+debounce</code> timer
or the <code>debounce</code> timer lapsed,
whichever happens first,
the controller continuously performs these checks:
</p>
<ol>
<li>
<b>Check for stable measured signal.</b><br/>
If <code>u_m</code> is stable, then<br/>
&nbsp; &nbsp; goto step 2.<br/>
Else:<br/>
&nbsp; &nbsp; Set <code>yLocFal = yLocTru = true</code>.<br/>
&nbsp; &nbsp; (Equipment is commanded on but we cannot conclude it is running;<br/>
&nbsp; &nbsp; set both <code>true</code> to flag an unstable measurement signal.)<br/>
</li>
<li>
<b>Check for commanded and measured input to be equal.</b><br/>
If <code>u_s &NotEqual; u_m</code>, then<br/>
&nbsp; &nbsp; goto step 3.<br/>
Else,<br/>
&nbsp; &nbsp; set <code>yLocFal = false </code> and <code>yLocTru = false</code>.<br/>
&nbsp; &nbsp; (Equipment is operating as commanded, verified using stable input.)
<li>
<b>Inputs differ.</b><br/>
If <code>u_s = true </code>, then<br/>
&nbsp; &nbsp; set  <code>yLocFal = true </code> and <code>yLocTru = false</code>.<br/>
&nbsp; &nbsp; (The equipment is commanded on, but it is off.)<br/>
Else,<br/>
&nbsp; &nbsp; set  <code>yLocFal = false </code> and <code>yLocTru = true</code>.<br/>
&nbsp; &nbsp; (The equipment is commanded off, but it is on.)<br/>
</li>
</li>
</ol>
</html>",
revisions="<html>
<ul>
<li>
March 28, 2023, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
March 27, 2023, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Proof;
