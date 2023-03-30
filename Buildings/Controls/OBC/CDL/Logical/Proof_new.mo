within Buildings.Controls.OBC.CDL.Logical;
block Proof_new "Verify two boolean inputs"
  parameter Real debounce(
    final quantity="Time",
    final unit="s")
    "Time during which input must remain unchanged for signal to considered valid and used in checks";
  parameter Real feedbackDelay(
    final quantity="Time",
    final unit="s")
    "Delay after which the two inputs are checked for equality once they become valid";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u_m "Measured status"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-200}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u_s
    "Commanded status setpoint" annotation (Placement(transformation(extent={{-220,
            -20},{-180,20}}),  iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLocFal
    "True: commanded status is true and current status is false"
    annotation (Placement(transformation(extent={{190,-96},{230,-56}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLocTru
    "True: commanded status is false and current status is true"
    annotation (Placement(transformation(extent={{180,80},{220,120}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Logical.Or or2 "Check if the input becomes valid after the delay time"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Or         or1 "Check if the input becomes valid after the delay time"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay valTru(
    final delayTime=debounce)
    "Valid change from false to true"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay valTru1(
    final delayTime=debounce)
    "Valid change from false to true"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Logical.Switch valFal
    "Valid change from true to false"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch valFal1
    "Valid change from true to false"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=debounce)
    "Delay a rising edge, to check if the false input is valid"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=debounce)
    "Delay a rising edge, to check if the false input is valid"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Logical.And botTru
    "Check if both valid inputs are true"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not notBotTru
    "Not both true input"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not notBotFal
    "Not both false input"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Logical.And falTru
    "Check if the valid commanded status is true and the valid measured status is false"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe(
    final delayTime=max(feedbackDelay, debounce))
    "Delay the difference check"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And truFal
    "Check if the valid commanded status is false and the valid measured status is true"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delChe1(
    final delayTime=max(feedbackDelay, debounce))
    "Delay the difference check"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "False input"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal equSta
    "Check if both status are the same"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Logical.And botFal
    "Both false status"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "True constant"
    annotation (Placement(transformation(extent={{-322,26},{-302,46}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "False input"
    annotation (Placement(transformation(extent={{-268,-92},{-248,-72}})));

  TrueDelay                                    truDel3(final delayTime=debounce)
    "Delay a rising edge, to check if the false input is valid"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
initial equation
  assert(
    feedbackDelay >= debounce,
    "In " + getInstanceName() + ": Require feedbackDelay >= debounce, setting feedbackDelay = debounce.",
    level=AssertionLevel.warning);

equation

  connect(u_m, valTru.u) annotation (Line(points={{0,-200},{0,-170},{-170,-170},
          {-170,-100},{-162,-100}}, color={255,0,255}));
  connect(u_m, not1.u) annotation (Line(points={{0,-200},{0,-170},{-170,-170},{
          -170,-150},{-162,-150}}, color={255,0,255}));
  connect(not1.y, truDel1.u)
    annotation (Line(points={{-138,-150},{-122,-150}}, color={255,0,255}));
  connect(valTru.y, or1.u1) annotation (Line(points={{-138,-100},{-120,-100},{
          -120,-50},{-62,-50}}, color={255,0,255}));
  connect(truDel1.y, or1.u2) annotation (Line(points={{-98,-150},{-80,-150},{
          -80,-58},{-62,-58}}, color={255,0,255}));
annotation (
    defaultComponentName="pro",
    Diagram(
      coordinateSystem(extent={{-180,-180},{180,180}})),
    Icon(
      coordinateSystem(extent={{-180,-180},{180,180}}), graphics={
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
Block that compares two boolean inputs <code>uMea</code> and <code>uCom</code>.
The block has two outputs
<code>yProTru</code> and <code>yProFal</code> that can trigger alarms
if <code>uMea &ne; uCom</code> after user-adjustable delay times.
</p>
<p>
The parameter <code>debounce</code> specifies the amount of time that the inputs
<code>uMea</code> and <code>uCom</code> must remain unchanged before they are
considered valid. If either of the valid input changes, after a delay which is
specified by the parameter <code>feedbackDelay</code>,
where <code>feedbackDelay &ge; debounce</code>, the block checks if
<code>uMea == uCom</code>.
If <code>feedbackDelay &lt; debounce</code>, the block issues a warning
and sets <code>feedbackDelay = debounce</code>.
</p>
<p>
Once <code>uMea</code> and <code>uCom</code> are valid, the outputs are as follows:
</p>
<ul>
<li>
The output <code>yProTru</code> is <code>yProTru = uCom == true and uMea == false</code>.<br/>
For example, <code>yProTru</code> indicates an alarm status (<code>yProTru = true</code>)
if an equipment is commanded on (it receives a <code>true</code> signal) but it does not run.
</li>
<li>
The output <code>yProFal</code> is <code>yProFal = uCom == false and uMea == true</code>.<br/>
For example, <code>yProFal</code> indicates an alarm status (<code>yProFal = true</code>)
if an equipment is commanded off but it runs.
</li>
</ul>
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
end Proof_new;
