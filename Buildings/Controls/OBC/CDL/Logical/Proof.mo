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
    annotation (Placement(transformation(extent={{240,100},{280,140}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLocTru
    "True: measured input is locked to true even after the setpoint has changed to false"
    annotation (Placement(transformation(extent={{240,-140},{280,-100}}),
        iconTransformation(extent={{100,-70},{140,-30}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Or valInp
    "Output true if the input becomes stable after the delay time"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Logical.And invInp
    "Output true if debounce time has passed and there is still no stable input"
    annotation (Placement(transformation(extent={{0,170},{20,190}})));
  Buildings.Controls.OBC.CDL.Logical.Or pasDel
    "Output true if the feedback checking time has passed"
    annotation (Placement(transformation(extent={{-142,-10},{-122,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or cheDif
    "Output true if the measured input is stable, or the feedback checking time has passed"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.And botTru
    "Output true if both valid measured input and the setpoint input are true"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And truFal
    "Output true if the setpoint input is true but the valid measured input is false"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay valTru(
    final delayTime=debounce) "Valid measured input change from false to true"
    annotation (Placement(transformation(extent={{-240,170},{-220,190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch valFal
    "Output false if measured input is stable and changed from true to false"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch cheDif1
    "Output the difference check result if the difference check condition is satisfied"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
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
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And falTru
    "Output true if the setpoint input is false but the valid measured input is true"
    annotation (Placement(transformation(extent={{80,-200},{100,-180}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe1(
    final delayTime=feedbackDelay + debounce)
    "Delay the difference check"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Integers.Equal equSta
    "Output true if both inputs are same"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));
  Buildings.Controls.OBC.CDL.Logical.And botFal
    "Output true if both valid measured input and the setpoint input are false"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conTru(
    final k=true)
    "True constant"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Input is invalid"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch cheStaMea
    "Output true if there is no stable measured input"
    annotation (Placement(transformation(extent={{160,110},{180,130}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe2(
    final delayTime=feedbackDelay + debounce)
    "Delay the difference check"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conFal(
    final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{40,132},{60,152}})));
  Buildings.Controls.OBC.CDL.Logical.Not notBotTru
    "Not both true inputs"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch cheDif2
    "Output the difference check result if the difference check condition is satisfied"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch cheStaMea1
    "Output true if there is no stable measured input"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer pasDeb(
    final t=feedbackDelay + debounce)
    "Check if the debounce time has passed"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Logical.Latch holTru
    "Hold the true output when the input changes to true"
    annotation (Placement(transformation(extent={{200,110},{220,130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch holTru1
    "Hold the true output when the input changes to true"
    annotation (Placement(transformation(extent={{200,-130},{220,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or equInp
    "Output true if the measured input is valid and equal to the set point"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Logical.Edge samInpEdg
    "Output a rising edge when both inputs are same"
    annotation (Placement(transformation(extent={{160,20},{180,40}})));

initial equation
  assert(
    feedbackDelay >= debounce,
    "In " + getInstanceName() + ": Require feedbackDelay >= debounce, setting feedbackDelay = debounce.",
    level=AssertionLevel.warning);

equation
  connect(u_m, valTru.u) annotation (Line(points={{0,-260},{0,-220},{-250,-220},
          {-250,180},{-242,180}}, color={255,0,255}));
  connect(u_m, not1.u) annotation (Line(points={{0,-260},{0,-220},{-250,-220},{-250,
          140},{-242,140}}, color={255,0,255}));
  connect(not1.y, truDel1.u)
    annotation (Line(points={{-218,140},{-202,140}}, color={255,0,255}));
  connect(valTru.y, valInp.u1)
    annotation (Line(points={{-218,180},{-142,180}},color={255,0,255}));
  connect(truDel1.y, valInp.u2) annotation (Line(points={{-178,140},{-160,140},{
          -160,172},{-142,172}},color={255,0,255}));
  connect(truDel1.y, valFal.u2) annotation (Line(points={{-178,140},{-160,140},{
          -160,110},{-142,110}}, color={255,0,255}));
  connect(u_m, valFal.u1) annotation (Line(points={{0,-260},{0,-220},{-250,-220},
          {-250,118},{-142,118}}, color={255,0,255}));
  connect(conTru.y, valFal.u3) annotation (Line(points={{-178,210},{-170,210},{-170,
          102},{-142,102}}, color={255,0,255}));
  connect(valInp.y, not3.u)
    annotation (Line(points={{-118,180},{-82,180}}, color={255,0,255}));
  connect(not3.y, invInp.u1)
    annotation (Line(points={{-58,180},{-2,180}},color={255,0,255}));
  connect(conTru.y, cheStaMea.u1) annotation (Line(points={{-178,210},{110,210},
          {110,128},{158,128}}, color={255,0,255}));
  connect(u_s, not2.u) annotation (Line(points={{-280,0},{-240,0},{-240,-40},{
          -222,-40}}, color={255,0,255}));
  connect(not2.y, delChe1.u)
    annotation (Line(points={{-198,-40},{-182,-40}}, color={255,0,255}));
  connect(u_s, delChe2.u)
    annotation (Line(points={{-280,0},{-222,0}}, color={255,0,255}));
  connect(delChe2.y, pasDel.u1)
    annotation (Line(points={{-198,0},{-144,0}},color={255,0,255}));
  connect(delChe1.y, pasDel.u2) annotation (Line(points={{-158,-40},{-154,-40},
          {-154,-8},{-144,-8}}, color={255,0,255}));
  connect(valInp.y, cheDif.u2) annotation (Line(points={{-118,180},{-100,180},{-100,
          -8},{-62,-8}},     color={255,0,255}));
  connect(pasDel.y, cheDif.u1)
    annotation (Line(points={{-120,0},{-62,0}}, color={255,0,255}));
  connect(cheDif.y, cheDif1.u2) annotation (Line(points={{-38,0},{90,0},{90,150},
          {118,150}}, color={255,0,255}));
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
  connect(not2.y, botFal.u1) annotation (Line(points={{-198,-40},{-190,-40},{
          -190,-150},{-2,-150}}, color={255,0,255}));
  connect(equSta.y, botFal.u2) annotation (Line(points={{-38,-130},{-10,-130},{-10,
          -158},{-2,-158}}, color={255,0,255}));
  connect(botFal.y, notBotFal.u)
    annotation (Line(points={{22,-150},{38,-150}}, color={255,0,255}));
  connect(notBotFal.y, falTru.u1) annotation (Line(points={{62,-150},{70,-150},{
          70,-190},{78,-190}}, color={255,0,255}));
  connect(not2.y, falTru.u2) annotation (Line(points={{-198,-40},{-190,-40},{
          -190,-198},{78,-198}}, color={255,0,255}));
  connect(cheDif1.y, cheStaMea.u3) annotation (Line(points={{142,150},{150,150},
          {150,112},{158,112}}, color={255,0,255}));
  connect(cheDif.y, cheDif2.u2) annotation (Line(points={{-38,0},{90,0},{90,-80},
          {118,-80}},  color={255,0,255}));
  connect(cheDif2.y, cheStaMea1.u3) annotation (Line(points={{142,-80},{150,-80},
          {150,-128},{158,-128}},
                                color={255,0,255}));
  connect(conTru.y, cheStaMea1.u1) annotation (Line(points={{-178,210},{110,210},
          {110,-112},{158,-112}},
                                color={255,0,255}));
  connect(conFal.y, cheDif1.u3) annotation (Line(points={{62,142},{118,142}},
                      color={255,0,255}));
  connect(conFal.y, cheDif2.u3) annotation (Line(points={{62,142},{100,142},{
          100,-88},{118,-88}},
                       color={255,0,255}));
  connect(falTru.y, cheDif2.u1) annotation (Line(points={{102,-190},{114,-190},
          {114,-72},{118,-72}},  color={255,0,255}));
  connect(truFal.y, cheDif1.u1) annotation (Line(points={{22,-100},{70,-100},{
          70,158},{118,158}},
                           color={255,0,255}));
  connect(u_s, botTru.u2) annotation (Line(points={{-280,0},{-240,0},{-240,-88},
          {-102,-88}}, color={255,0,255}));
  connect(cheStaMea.y, holTru.u)
    annotation (Line(points={{182,120},{198,120}}, color={255,0,255}));
  connect(cheStaMea1.y, holTru1.u)
    annotation (Line(points={{182,-120},{198,-120}},
                                                   color={255,0,255}));
  connect(holTru.y, yLocFal)
    annotation (Line(points={{222,120},{260,120}}, color={255,0,255}));
  connect(holTru1.y, yLocTru)
    annotation (Line(points={{222,-120},{260,-120}},
                                                   color={255,0,255}));
  connect(botTru.y, equInp.u1) annotation (Line(points={{-78,-80},{-70,-80},{
          -70,30},{118,30}},
                         color={255,0,255}));
  connect(equSta.y, equInp.u2) annotation (Line(points={{-38,-130},{-10,-130},{
          -10,22},{118,22}},
                         color={255,0,255}));
  connect(equInp.y, samInpEdg.u)
    annotation (Line(points={{142,30},{158,30}}, color={255,0,255}));
  connect(samInpEdg.y, holTru.clr) annotation (Line(points={{182,30},{190,30},{
          190,114},{198,114}},
                           color={255,0,255}));
  connect(samInpEdg.y, holTru1.clr) annotation (Line(points={{182,30},{190,30},
          {190,-126},{198,-126}},
                               color={255,0,255}));
  connect(invInp.y, cheStaMea.u2)
    annotation (Line(points={{22,180},{80,180},{80,120},{158,120}},
                                                  color={255,0,255}));
  connect(invInp.y, cheStaMea1.u2) annotation (Line(points={{22,180},{80,180},{
          80,-120},{158,-120}},
                           color={255,0,255}));
  connect(not3.y, pasDeb.u) annotation (Line(points={{-58,180},{-50,180},{-50,
          150},{-42,150}}, color={255,0,255}));
  connect(pasDeb.passed, invInp.u2) annotation (Line(points={{-18,142},{-10,142},
          {-10,172},{-2,172}}, color={255,0,255}));
annotation (
    defaultComponentName="pro",
    Diagram(
      coordinateSystem(extent={{-260,-240},{240,240}}), graphics={
        Rectangle(
          extent={{-258,236},{28,42}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-258,38},{-114,-58}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-116,-62},{66,-198}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-248,38},{-174,20}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Output true if u_s has passed
the feedback delay"),
        Text(
          extent={{-90,-182},{-4,-196}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Check if the inputs are different"),
        Text(
          extent={{-252,236},{-130,224}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Check if there is a stable measured input u_m")}),
    Icon(
      coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{7,-73},{-7,-87}},
          lineColor=DynamicSelect({235,235,235}, if u_m then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if u_m then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-73,7},{-87,-7}},
          lineColor=DynamicSelect({235,235,235}, if u_s then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if u_s then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{73,57},{87,43}},
          lineColor=DynamicSelect({235,235,235}, if yLocFal then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if yLocFal then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{75,-43},{89,-57}},
          lineColor=DynamicSelect({235,235,235}, if yLocTru then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if yLocTru then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Line(
          points={{-60,60},{-60,-88}},
          color={192,192,192}),
        Polygon(
          points={{-60,82},{-68,60},{-52,60},{-60,82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,-68},{80,-68}},
          color={192,192,192}),
        Polygon(
          points={{90,-68},{68,-60},{68,-76},{90,-68}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,44}}, color={28,108,200}),
        Line(points={{-60,-36},{-40,-36},{-40,-16},{20,-16},{20,-36},{60,-36}},
            color={0,0,0}),
        Line(points={{-60,-68},{-14,-68},{-14,-48},{40,-48},{40,-68},{60,-68}},
            color={0,0,0}),
        Line(points={{-60,44},{-40,44},{-40,64},{-14,64},{-14,44},{60,44}},
            color={28,108,200}),
        Line(points={{-60,12},{20,12},{20,32},{40,32},{40,12},{60,12}}, color={28,
              108,200}),
        Line(
          points={{-40,40},{-40,-12}},
          color={28,108,200},
          pattern=LinePattern.Dash),
        Line(
          points={{-14,40},{-14,-44}},
          color={28,108,200},
          pattern=LinePattern.Dash),
        Line(
          points={{20,8},{20,-12}},
          color={28,108,200},
          pattern=LinePattern.Dash),
        Line(
          points={{40,8},{40,-44}},
          color={28,108,200},
          pattern=LinePattern.Dash),
        Text(
          extent={{-6,-4},{6,-14}},
          textColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textString="u_s"),
        Text(
          extent={{-10,-36},{6,-46}},
          textColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textString="u_m"),
        Text(
          extent={{22,44},{44,32}},
          textColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textString="yLocTru"),
        Text(
          extent={{-40,76},{-18,64}},
          textColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textString="yLocFal")}),
Documentation(info="<html>
<p>
Block that compares a boolean set point <code>u_s</code> with
a measured signal <code>u_m</code> and produces two outputs
that may be used to raise alarms about malfunctioning equipment.
</p>
<p>
The block sets the output <code>yLocFal = true</code> if
the set point is <code>u_s = true</code> but the measured signal is locked
at <code>false</code>, i.e., <code>u_m = false</code>.
Similarly, the block sets the output <code>yLocTru = true</code>
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
Connect the inputs for the set point <code>u_s</code> and
the measured signal <code>u_m</code> to the output signals that need to be checked.
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
