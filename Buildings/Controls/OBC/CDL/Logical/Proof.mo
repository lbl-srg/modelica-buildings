within Buildings.Controls.OBC.CDL.Logical;
block Proof "Verify two boolean inputs"
  parameter Real debounce(
    final quantity="Time",
    final unit="s")
    "Time during which input must remain unchanged for signal to considered valid and used in checks";
  parameter Real feedbackDelay(
    final quantity="Time",
    final unit="s")
    "Delay after which the two inputs are checked for equality once they become valid";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u_s
    "Commanded status setpoint"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u_m
    "Measured status"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=90, origin={0,-260}),
        iconTransformation(extent={{-20,-20},{20,20}}, rotation=90, origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLocFal
    "True: measured input is locked to false even after the setpoint has changed to true"
    annotation (Placement(transformation(extent={{240,160},{280,200}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLocTru
    "True: measured input is locked to true even after the setpoint has changed to false"
    annotation (Placement(transformation(extent={{240,-80},{280,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Or valInp
    "Check if the input becomes valid after the delay time"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Logical.Change chaMeaInp
    "Output rising edge when measured input changes"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=debounce)
    "Check if it has passed the debounce time since the first input change"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch holCha
    "Hold the true output when the input changes to true"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Logical.And invInp
    "Debounce time has passed and there is still no stable input"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "True: the measured input becomes valid"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Or pasDel
    "Check if the feedback checking time is passed"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or cheDif
    "Check if the measured input is valid, or the feedback checking time is passed"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.And botTru
    "Check if both valid measured input and the setpoint input are true"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And truFal
    "Setpoint input is true but the valid measured input is false"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay valTru(
    final delayTime=debounce) "Valid measured input change from false to true"
    annotation (Placement(transformation(extent={{-240,170},{-220,190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch valFal
    "Valid measured input change from true to false"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch cheDif1
    "Check if it should check the difference"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=debounce)
    "Delay a rising edge, to check if the false input is valid"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-240,130},{-220,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not notBotFal "Not both false inputs"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And falTru
    "Setpoint input is false but the valid measured input is true"
    annotation (Placement(transformation(extent={{80,-200},{100,-180}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe1(
    final delayTime=feedbackDelay + debounce)
    "Delay the difference check"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Integers.Equal equSta
    "Check if both status are the same"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));
  Buildings.Controls.OBC.CDL.Logical.And botFal
    "Both false status"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conTru(
    final k=true)
    "True constant"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Input is invalid"
    annotation (Placement(transformation(extent={{0,170},{20,190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch locFal
    "Output if the measured input is locked to false"
    annotation (Placement(transformation(extent={{160,170},{180,190}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe2(
    final delayTime=feedbackDelay + debounce)
    "Delay the difference check"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conFal(
    final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not notBotTru
    "Not both true inputs"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch cheDif2
    "Check if it should check the difference"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch locTru
    "Output if the measured input is locked to false"
    annotation (Placement(transformation(extent={{160,-70},{180,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch holCha1
    "Hold the true output when the input changes to true"
    annotation (Placement(transformation(extent={{200,170},{220,190}})));
  Buildings.Controls.OBC.CDL.Logical.Latch holCha2
    "Hold the true output when the input changes to true"
    annotation (Placement(transformation(extent={{200,-70},{220,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{40,-230},{60,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Equal equSta1
    "Check if both status are the same"
    annotation (Placement(transformation(extent={{140,-180},{160,-160}})));

initial equation
  assert(
    feedbackDelay >= debounce,
    "In " + getInstanceName() + ": Require feedbackDelay >= debounce, setting feedbackDelay = debounce.",
    level=AssertionLevel.warning);

equation
  connect(u_m, valTru.u) annotation (Line(points={{0,-260},{0,-220},{-250,-220},
          {-250,180},{-242,180}},   color={255,0,255}));
  connect(u_m, not1.u) annotation (Line(points={{0,-260},{0,-220},{-250,-220},{-250,
          140},{-242,140}},        color={255,0,255}));
  connect(not1.y, truDel1.u)
    annotation (Line(points={{-218,140},{-202,140}},   color={255,0,255}));
  connect(valTru.y, valInp.u1)
    annotation (Line(points={{-218,180},{-102,180}},color={255,0,255}));
  connect(truDel1.y, valInp.u2) annotation (Line(points={{-178,140},{-160,140},{
          -160,172},{-102,172}},color={255,0,255}));
  connect(truDel1.y, valFal.u2) annotation (Line(points={{-178,140},{-160,140},{
          -160,110},{-142,110}}, color={255,0,255}));
  connect(u_m, valFal.u1) annotation (Line(points={{0,-260},{0,-220},{-250,-220},
          {-250,118},{-142,118}}, color={255,0,255}));
  connect(conTru.y, valFal.u3) annotation (Line(points={{-178,210},{-170,210},{-170,
          102},{-142,102}}, color={255,0,255}));
  connect(u_m, chaMeaInp.u) annotation (Line(points={{0,-260},{0,-220},{-250,-220},
          {-250,90},{-102,90}},color={255,0,255}));
  connect(chaMeaInp.y, holCha.u)
    annotation (Line(points={{-78,90},{-62,90}}, color={255,0,255}));
  connect(holCha.y, tim.u)
    annotation (Line(points={{-38,90},{-2,90}}, color={255,0,255}));
  connect(valInp.y, not3.u)
    annotation (Line(points={{-78,180},{-2,180}}, color={255,0,255}));
  connect(not3.y, invInp.u1)
    annotation (Line(points={{22,180},{38,180}}, color={255,0,255}));
  connect(tim.passed, invInp.u2) annotation (Line(points={{22,82},{30,82},{30,172},
          {38,172}}, color={255,0,255}));
  connect(invInp.y, locFal.u2)
    annotation (Line(points={{62,180},{158,180}}, color={255,0,255}));
  connect(conTru.y, locFal.u1) annotation (Line(points={{-178,210},{110,210},{110,
          188},{158,188}}, color={255,0,255}));
  connect(valInp.y, edg.u) annotation (Line(points={{-78,180},{-20,180},{-20,50},
          {-2,50}}, color={255,0,255}));
  connect(edg.y, holCha.clr) annotation (Line(points={{22,50},{30,50},{30,70},{-70,
          70},{-70,84},{-62,84}}, color={255,0,255}));
  connect(u_s, not2.u) annotation (Line(points={{-280,0},{-240,0},{-240,-50},{-222,
          -50}}, color={255,0,255}));
  connect(not2.y, delChe1.u)
    annotation (Line(points={{-198,-50},{-182,-50}}, color={255,0,255}));
  connect(u_s, delChe2.u)
    annotation (Line(points={{-280,0},{-222,0}}, color={255,0,255}));
  connect(delChe2.y, pasDel.u1)
    annotation (Line(points={{-198,0},{-102,0}},color={255,0,255}));
  connect(delChe1.y, pasDel.u2) annotation (Line(points={{-158,-50},{-120,-50},{
          -120,-8},{-102,-8}},color={255,0,255}));
  connect(valInp.y, cheDif.u2) annotation (Line(points={{-78,180},{-20,180},{-20,
          -8},{-2,-8}}, color={255,0,255}));
  connect(pasDel.y, cheDif.u1)
    annotation (Line(points={{-78,0},{-2,0}}, color={255,0,255}));
  connect(cheDif.y, cheDif1.u2) annotation (Line(points={{22,0},{90,0},{90,110},
          {118,110}}, color={255,0,255}));
  connect(botTru.y, notBotTru.u)
    annotation (Line(points={{-78,-80},{-62,-80}}, color={255,0,255}));
  connect(notBotTru.y, truFal.u1) annotation (Line(points={{-38,-80},{-20,-80},{
          -20,-100},{-2,-100}}, color={255,0,255}));
  connect(valTru.y, botTru.u1) annotation (Line(points={{-218,180},{-150,180},{-150,
          -80},{-102,-80}},color={255,0,255}));
  connect(u_s, truFal.u2) annotation (Line(points={{-280,0},{-240,0},{-240,-108},
          {-2,-108}}, color={255,0,255}));
  connect(u_s, booToInt1.u) annotation (Line(points={{-280,0},{-240,0},{-240,-170},
          {-102,-170}},color={255,0,255}));
  connect(valFal.y, booToInt.u) annotation (Line(points={{-118,110},{-110,110},{
          -110,-130},{-102,-130}}, color={255,0,255}));
  connect(booToInt.y, equSta.u1)
    annotation (Line(points={{-78,-130},{-62,-130}}, color={255,127,0}));
  connect(booToInt1.y, equSta.u2) annotation (Line(points={{-78,-170},{-70,-170},
          {-70,-138},{-62,-138}}, color={255,127,0}));
  connect(not2.y, botFal.u1) annotation (Line(points={{-198,-50},{-190,-50},{-190,
          -150},{-2,-150}}, color={255,0,255}));
  connect(equSta.y, botFal.u2) annotation (Line(points={{-38,-130},{-20,-130},{-20,
          -158},{-2,-158}}, color={255,0,255}));
  connect(botFal.y, notBotFal.u)
    annotation (Line(points={{22,-150},{38,-150}}, color={255,0,255}));
  connect(notBotFal.y, falTru.u1) annotation (Line(points={{62,-150},{70,-150},{
          70,-190},{78,-190}}, color={255,0,255}));
  connect(not2.y, falTru.u2) annotation (Line(points={{-198,-50},{-190,-50},{-190,
          -198},{78,-198}}, color={255,0,255}));
  connect(cheDif1.y, locFal.u3) annotation (Line(points={{142,110},{150,110},{150,
          172},{158,172}}, color={255,0,255}));
  connect(cheDif.y, cheDif2.u2) annotation (Line(points={{22,0},{90,0},{90,-120},
          {118,-120}}, color={255,0,255}));
  connect(cheDif2.y, locTru.u3) annotation (Line(points={{142,-120},{150,-120},{
          150,-68},{158,-68}}, color={255,0,255}));
  connect(invInp.y, locTru.u2) annotation (Line(points={{62,180},{80,180},{80,-60},
          {158,-60}},      color={255,0,255}));
  connect(conTru.y, locTru.u1) annotation (Line(points={{-178,210},{110,210},{110,
          -52},{158,-52}}, color={255,0,255}));
  connect(conFal.y, cheDif1.u3) annotation (Line(points={{-38,30},{100,30},{100,
          102},{118,102}}, color={255,0,255}));
  connect(conFal.y, cheDif2.u3) annotation (Line(points={{-38,30},{100,30},{100,
          -128},{118,-128}}, color={255,0,255}));
  connect(falTru.y, cheDif2.u1) annotation (Line(points={{102,-190},{110,-190},{
          110,-112},{118,-112}}, color={255,0,255}));
  connect(truFal.y, cheDif1.u1) annotation (Line(points={{22,-100},{60,-100},{60,
          118},{118,118}}, color={255,0,255}));
  connect(u_s, botTru.u2) annotation (Line(points={{-280,0},{-240,0},{-240,-88},
          {-102,-88}}, color={255,0,255}));
  connect(locFal.y, holCha1.u)
    annotation (Line(points={{182,180},{198,180}}, color={255,0,255}));
  connect(holCha1.y, yLocFal)
    annotation (Line(points={{222,180},{260,180}}, color={255,0,255}));
  connect(locTru.y, holCha2.u)
    annotation (Line(points={{182,-60},{198,-60}}, color={255,0,255}));
  connect(holCha2.y, yLocTru)
    annotation (Line(points={{222,-60},{260,-60}}, color={255,0,255}));
  connect(u_m, booToInt2.u)
    annotation (Line(points={{0,-260},{0,-220},{38,-220}}, color={255,0,255}));
  connect(booToInt2.y, equSta1.u2) annotation (Line(points={{62,-220},{130,-220},
          {130,-178},{138,-178}}, color={255,127,0}));
  connect(booToInt1.y, equSta1.u1)
    annotation (Line(points={{-78,-170},{138,-170}}, color={255,127,0}));
  connect(equSta1.y, holCha2.clr) annotation (Line(points={{162,-170},{190,-170},
          {190,-66},{198,-66}}, color={255,0,255}));
  connect(equSta1.y, holCha1.clr) annotation (Line(points={{162,-170},{190,-170},
          {190,174},{198,174}}, color={255,0,255}));
annotation (
    defaultComponentName="pro",
    Diagram(
      coordinateSystem(extent={{-260,-240},{240,240}}), graphics={
        Rectangle(
          extent={{-258,238},{58,42}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-258,38},{58,-58}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-258,-62},{58,-198}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-242,58},{-38,44}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Check if there is valid measured input"),
        Text(
          extent={{-104,-42},{106,-54}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Check if it has passed the feedback delay"),
        Text(
          extent={{-240,-176},{46,-200}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Check if there is difference between setpoint and the measured inputs")}),
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
</li>
<li>
<b>Inputs differ.</b><br/>
If <code>u_s = true </code>, then<br/>
&nbsp; &nbsp; set  <code>yLocFal = true </code> and <code>yLocTru = false</code>.<br/>
&nbsp; &nbsp; (The equipment is commanded on, but it is off.)<br/>
Else,<br/>
&nbsp; &nbsp; set  <code>yLocFal = false </code> and <code>yLocTru = true</code>.<br/>
&nbsp; &nbsp; (The equipment is commanded off, but it is on.)<br/>
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
